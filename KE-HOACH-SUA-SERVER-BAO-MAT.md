# Kế hoạch sửa server: chống sập và bảo vệ tài khoản (6/11/2026, chờ duyệt)

Chưa sửa dòng Java nào. Lỗi và bằng chứng ở [BAO-MAT.md](BAO-MAT.md). Code mẫu dưới đây viết theo code hiện tại nhưng **chưa biên dịch, chưa chạy thử**. Không gói nào đổi giao thức, nên **client không cần cập nhật**.

## Thứ tự làm

| Đợt | Việc | Công sức | Rủi ro với người chơi |
|---|---|---|---|
| 0 | Đổi mật khẩu, khóa MySQL, firewall (làm tay) | 15 phút | Không |
| 1 | Chặn sập bằng 1 kết nối: gói `-74`, trần hàng đợi | Nhỏ | Thấp, cần thử client mới tải dữ liệu |
| 2 | Sửa đếm IP, rò session, trần tổng kết nối | Nhỏ | Thấp |
| 3 | Giới hạn gói/giây, `AntiLogin` | Vừa | Trung bình, phải đo trước |
| 4 | Tăng pool DB | Nhỏ | Trung bình, có thể lộ lỗi đua dữ liệu |
| 5 | Bcrypt mật khẩu | Vừa | Trung bình, sửa cả web và game |
| 6 | Kiểm tra di chuyển, khoảng cách nhặt đồ | Vừa | **Cao**, xem mục "Cần chốt" |
| 7 | VPS / proxy chống DDoS lưu lượng | Theo nhà cung cấp | Đổi IP/tên miền máy chủ |

Đợt 1–3 chống được tấn công nhỏ và script. **DDoS lưu lượng lớn chỉ đợt 7 giải quyết được.**

## Đợt 0: làm tay trên máy chạy server

1. Đổi mật khẩu các tài khoản admin. Tối thiểu 12 ký tự, không trùng nhau.
2. Tạo user MySQL riêng cho game và web, đặt mật khẩu cho `root`. Ghi mật khẩu vào `Config.properties` và `web/config.php`, **đừng commit** (cân nhắc chuyển 2 file đó sang bản mẫu + gitignore).
3. Trong `C:\xampp\mysql\bin\my.ini`, mục `[mysqld]`, bỏ dấu `#` ở `bind-address="127.0.0.1"`, rồi khởi động lại MySQL.
4. Firewall (PowerShell quyền Admin), chỉ mở cổng cần thiết:

```powershell
New-NetFirewallRule -DisplayName "NRO game" -Direction Inbound -Protocol TCP -LocalPort 14446 -Action Allow
New-NetFirewallRule -DisplayName "NRO web" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow
New-NetFirewallRule -DisplayName "Chan MySQL" -Direction Inbound -Protocol TCP -LocalPort 3306 -Action Block
```

5. Kiểm tra router: chỉ chuyển tiếp 14446 và 8080, không chuyển 3306.

## Đợt 1: chặn sập server bằng 1 kết nối (ưu tiên cao nhất)

**Lỗi:** gói `-74` type 2 chỉ vài byte nhưng gọi được khi chưa đăng nhập. `DataGame.sendRes` đọc toàn bộ `data/res/x<zoom>` (1.413 file, 13–28 MB) vào RAM và xếp hàng. Client không đọc socket mà gửi lặp lại khoảng 20 lần là đầy heap 512 MB.

### 1a. `-74` type 2 mỗi kết nối chỉ một lần

`MySession.java`: thêm `public boolean sentRes;`

`Controller.java` (case `-74`):

```java
} else if (type == 2 && !_session.sentRes) {
    _session.sentRes = true;
    DataGame.sendRes(_session);
}
```

### 1b. Trần dung lượng hàng đợi gửi

Tính theo byte, không theo số gói, vì một lần tải dữ liệu hợp lệ đã có hơn 1.400 gói.

`Message.java`:

```java
public int size() {
    return this.os != null ? this.os.size() : 0;
}
```

`Sender.java`:

```java
private static final long MAX_QUEUE_BYTES = 64L * 1024 * 1024; // lớn hơn bộ res x4 (28 MB)
private final AtomicLong queuedBytes = new AtomicLong();
public volatile boolean overflow;

public void sendMessage(Message msg) {
    try {
        if (this.session.isConnected()) {
            int size = msg.size();
            if (this.queuedBytes.addAndGet(size) > MAX_QUEUE_BYTES) {
                this.queuedBytes.addAndGet(-size);
                this.overflow = true; // Client.update đá phiên này, không đá ngay trên luồng game
                return;
            }
            this.messages.add(msg);
        }
    } catch (Exception exception) {
    }
}
```

Trong `run()`, sau `doSendMessage(message)`: `queuedBytes.addAndGet(-message.size());` (lấy `size` trước khi gửi, vì `doSendMessage` gọi `msg.cleanup()`; `os` vẫn còn nhưng nên lấy trước cho chắc).

`Session.java`: thêm `public boolean isOverflow() { return sender != null && sender.overflow; }`

`Client.update()`: nếu `session.isOverflow()` thì `kickSession(session)`, ghi log kèm IP.

**Thử:** xóa cache client (`%USERPROFILE%\AppData\LocalLow\DefaultCompany\DragonBoy\`), mở game ở cấu hình cao nhất, phải tải xong dữ liệu mà không bị đá.

## Đợt 2: sửa đếm IP, rò session, trần tổng

### 2a. Đếm IP không trừ sai

**Lỗi:** client tự ngắt thì bị trừ 2 lần; session bị từ chối thì bị trừ dù chưa từng cộng.

`MySession.java`: thêm `public boolean countedIp;`

`ServerManager.java`, thay `CLIENTS` bằng `ConcurrentHashMap<String, Integer>` (hiện là `HashMap` dùng từ nhiều luồng):

```java
public static final Map<String, Integer> CLIENTS = new ConcurrentHashMap<>();

private boolean canConnectWithIp(MySession session) {
    if (SessionManager.gI().getNumSession() >= Manager.MAX_CONNECTION) {
        return false;
    }
    final boolean[] accepted = {false};
    CLIENTS.compute(session.getIP(), (ip, n) -> {
        int count = n == null ? 0 : n;
        if (count >= Manager.MAX_PER_IP) {
            return count;
        }
        accepted[0] = true;
        return count + 1;
    });
    session.countedIp = accepted[0];
    return accepted[0];
}

public void disconnect(MySession session) {
    synchronized (session) {
        if (!session.countedIp) {
            return;
        }
        session.countedIp = false;
    }
    CLIENTS.computeIfPresent(session.getIP(), (ip, n) -> n <= 1 ? null : n - 1);
}
```

`disconnect` giờ gọi nhiều lần cũng an toàn, nên giữ nguyên chỗ gọi cũng được; vẫn nên bỏ dòng `disconnect((MySession) session);` thừa ở `sessionDisconnect`. `sessionInit` đổi sang `canConnectWithIp((MySession) is)`. Việc xóa khỏi map khi về 0 cũng tránh map to dần theo số IP.

### 2b. Trần tổng kết nối

`Manager.java`: `public static int MAX_CONNECTION = 3000;`, đọc từ `server.maxconnection` như `server.maxperip`. `Config.properties`: `server.maxconnection=1500` (khoảng 1,5 lần `maxplayer`).

### 2c. Hết rò session bị từ chối

`Network.run()`, đảo thứ tự để `removeSession` trong `disconnect` có tác dụng:

```java
SessionManager.gI().putSession(session);
this.acceptHandler.sessionInit(session);
```

`Sender.close()`: `if (this.messages != null) this.messages.clear();`

`Session.disconnect()`: thoát sớm nếu đã ngắt, tránh chạy lần 2 trên object đã `dispose`.

```java
if (!this.connected) {
    return;
}
```

Sau khi sửa, `Client.update` không còn gặp NPE làm dừng vòng lặp. Lưu ý `getNumSession` đếm cả session vừa thêm nên trần thực tế thấp hơn 1, không đáng kể.

## Đợt 3: giới hạn gói và đăng nhập

### 3a. Giới hạn gói mỗi giây

Mod client gửi rất nhanh (AutoItem 50 ms/lần, cộng di chuyển, đánh, nhặt đồ). **Phải đo trước**: chạy bản thử chỉ ghi log số gói/giây cao nhất khi bật hết auto, sau đó đặt ngưỡng gấp 3 lần con số đó. Ngưỡng ghi trong code là tạm.

`Collector.run()`:

```java
long windowStart = System.currentTimeMillis();
int count = 0;
while (this.session != null && this.session.isConnected()) {
    Message msg = this.collect.readMessage(this.session, this.dis);
    long now = System.currentTimeMillis();
    if (now - windowStart >= 1000) {
        windowStart = now;
        count = 0;
    }
    if (++count > Manager.MAX_PACKET_PER_SECOND) {
        Logger.warning("Spam goi tin, ngat IP " + this.session.getIP() + "\n");
        break; // rơi xuống đoạn sessionDisconnect sẵn có
    }
    // ... xử lý như cũ
}
```

Thêm `server.maxpacket` trong `Config.properties`, bắt đầu 300.

### 3b. `AntiLogin` khó vượt hơn

- Đổi `ANTILOGIN` trong `MySession` sang `ConcurrentHashMap` (hiện `HashMap` không đồng bộ, không bao giờ xóa).
- Thêm một bộ đếm theo **tên tài khoản**, không chỉ theo IP. Đăng nhập đúng chỉ reset bộ đếm của chính tài khoản đó, không reset bộ đếm IP. Như vậy không còn xen kẽ tài khoản của mình để xóa đếm.
- Sửa giới hạn `al.reset()` trong `MrBlue.login`: hiện chạy cả khi tài khoản bị `ban`.
- Dọn mục cũ định kỳ để map không lớn mãi.

## Đợt 4: pool DB

`Config.properties`: `database.max=10`, `database.min=2`. `LocalManager.createConfig`: thêm `config.setConnectionTimeout(5000);`

**Rủi ro:** pool 1 kết nối đang vô tình xếp hàng mọi truy vấn. Tăng lên có thể lộ lỗi đua dữ liệu (lưu người chơi chen với đọc lại khi đăng nhập, ký gửi `TRUNCATE`). Thử nhiều tài khoản đăng nhập, đăng xuất, giao dịch, tự lưu cùng lúc rồi so dữ liệu.

## Đợt 5: mật khẩu bcrypt

- Thêm thư viện `jbcrypt` vào `lib/` (`lib` hiện chưa có), chỉnh `build.bat` nếu cần.
- `MrBlue.login`: đổi `where username = ? and password = ?` thành tìm theo `username` rồi so ở Java. Chấp nhận cả chuỗi cũ: nếu cột là chữ thường và khớp thì băm và ghi lại ngay. Tài khoản tự chuyển dần khi đăng nhập.
- Web: `dangky.php` và `doimatkhau.php` dùng `password_hash`; `dang-nhap.php` đã đọc được cả hai dạng. Bản `$2y$` của PHP phải được jBCrypt đọc (đổi tiền tố sang `$2a$` khi so).
- Cột `password` phải đủ 60 ký tự. Có SQL, ghi vào THAY-DOI.md khi làm.
- Web và game phải lên cùng lúc.

Bước này chỉ bảo vệ khi lộ DB. Trên đường truyền mật khẩu vẫn gần như chữ thường, muốn che phải đổi giao thức và sửa client.

## Đợt 7: chống DDoS thật

- Chuyển server lên VPS có lọc DDoS, hoặc đặt proxy TCP chuyên cho game phía trước, không để lộ IP thật. Nếu IP cũ đã lộ thì phải đổi IP.
- Web đặt sau Cloudflare (gói miễn phí được). Cổng game TCP thô không đi qua được gói miễn phí.
- Đổi `server.sv2` trong `Config.properties` sang địa chỉ mới.
- Tăng `-Xmx` trong `run.bat` theo RAM máy chủ.

## Cần chốt

1. **Duyệt làm đợt 1, 2?** Nhỏ, rủi ro thấp, nên làm trước.
2. **Đợt 6 có làm không?** Kiểm tra tốc độ di chuyển ở server sẽ chặn dịch chuyển tức thời, nhưng cũng **chặn luôn tính năng mod bạn đang phát** (bay tới boss, tàn sát, tự nhặt). Phải chọn giữ auto hay chống hack, hoặc chỉ giới hạn ở vài map.
3. **Server chạy ở đâu?** Máy nhà/công ty hay VPS. Quyết định đợt 7 và rule firewall.
4. **Bật lại đổi mật khẩu?** Nút đang tắt ở web từ commit đầu, không có ghi chú lý do, trong khi `doimatkhau.php` vẫn nhận yêu cầu.
5. **Các ngưỡng:** `maxconnection=1500`, trần hàng đợi 64 MB, `maxpacket` theo kết quả đo.
