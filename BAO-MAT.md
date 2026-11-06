# Bảo mật và chống DDoS (dò 6/11/2026)

Kết quả đọc code và cấu hình, **chưa chạy thử tấn công**. Chưa xem được cổng đang nghe khi server chạy thật, rule firewall và router. Cách sửa server từng bước: [KE-HOACH-SUA-SERVER-BAO-MAT.md](KE-HOACH-SUA-SERVER-BAO-MAT.md).

**Kết luận:** không có lớp chống DDoS nào. Có một số giới hạn cơ bản, trong đó giới hạn theo IP đang có lỗi. Client và manager không chống được DDoS vì tấn công đánh vào server.

## Đã có

| Lớp | Bảo vệ | Ở đâu |
|---|---|---|
| Server | Giới hạn kết nối mỗi IP (`server.maxperip=5`) | `ServerManager.canConnectWithIp` |
| Server | Kết nối chưa đăng nhập bị đá sau 100 giây | `MySession.timeWait`, `Client.update` |
| Server | Sai mật khẩu 5 lần thì khóa IP 60 giây | `AntiLogin`, `MySession.login` |
| Server | Chờ giữa 2 lần đăng nhập (`server.waitlogin=3`), giới hạn `server.maxplayer=1000` khi đăng nhập | `MrBlue.login` |
| Server | SQL tham số hóa; 4 chỗ ghép chuỗi đều chỉ ghép số hoặc IP lấy từ socket, không do người chơi nhập | `LocalManager`, `MrBlue:127`, `SuperRankDAO:158,190`, `ClanService:890` |
| Server | Lệnh admin chặn theo `account.is_admin`; kiểm tra hồi chiêu, mana, tầm đánh cận chiến, số lượng âm khi giao dịch | `Command:284`, `SkillService`, `TransactionService:127` |
| Server | Mã bảo vệ tài khoản (`mbv`, `baovetaikhoan`) | `Service.mabaove` |
| Web | Prepared statement ở đăng nhập, đăng ký, đổi mật khẩu; CSRF ở đăng nhập; `session_regenerate_id`; 13 trang admin đều kiểm tra `is_admin` (`logout.php` không cần); phpMyAdmin `Require local`; không có upload file; `.gitignore` chặn `db/*.sql`, `mcp.json` | `web/` |
| Manager | `accounts.txt` mã hóa DPAPI theo user Windows, gitignore; không gọi mạng; không ghi vào client gốc | `manager/src/Core.cs` |

## Lỗi chống DDoS và làm sập server

0. **Một kết nối chưa đăng nhập có thể làm đầy RAM (nặng nhất).** Gói `-74` type 2 chỉ vài byte, `DataGame.sendRes` đọc cả `data/res/x<zoom>` (1.413 file, 13–28 MB) vào heap rồi xếp hàng gửi, không giới hạn số lần. Client gửi lặp mà không đọc socket thì khoảng 20 lần là đầy `-Xmx512m`.
1. **Không có lớp chịu DDoS lưu lượng.** Không có proxy, scrubbing hay rate limit ở mạng. Game chạy TCP thô cổng `14446` qua tên DDNS `ngocrongprivate.kozow.com`, lộ thẳng IP máy chủ. Nghẽn đường truyền thì code không cứu được.
2. **Đếm kết nối theo IP bị trừ 2 lần** khi client tự ngắt: `Collector.run` → `sessionDisconnect` → `Client.kickSession` → `remove` → `ServerManager.disconnect` (trừ lần 1), rồi `sessionDisconnect` gọi `disconnect` lần nữa (`ServerManager.java:234`). Đóng 1 mở 2 lặp lại là vượt giới hạn 5 kết nối.
3. **Không có trần tổng số kết nối.** `maxplayer` chỉ xét lúc đăng nhập. Mỗi kết nối 2 thread (`Session`), thêm buffer 1 MB (yêu cầu với OS). Botnet nhiều IP vượt được giới hạn theo IP.
4. **Rò bộ nhớ khi từ chối kết nối.** `Network.run` gọi `sessionInit` (từ chối → `disconnect` → `removeSession`) rồi mới `putSession`, nên session đã hủy vẫn nằm trong danh sách. `startCleanupThread` có định nghĩa nhưng không ai gọi. 100 giây sau `Client.update` gọi `kickSession` → `Sender.close()` gặp `messages == null` → NPE: session ở lại vĩnh viễn, IP bị trừ đếm sai, vòng `update` tick đó dừng giữa chừng. `SessionManager.sessions` là `CopyOnWriteArrayList` nên mỗi lần thêm chép cả danh sách, luồng nhận kết nối chậm dần. Heap chỉ `-Xmx512m`.
5. **Hàng đợi gửi không giới hạn.** `Sender.messages` là `LinkedBlockingDeque` không trần, không ai xét `getNumMessages`. Client gửi yêu cầu dữ liệu lớn mà không đọc socket làm đầy heap. Chưa đăng nhập vẫn gọi được: `-111`, `-74`, `-28` sub 6/7/8/10 (`Controller.onMessage` không kiểm tra `player`).
6. **Không giới hạn tần suất gói.** `Collector` xử lý từng gói ngay trên thread của kết nối, không đếm, không có cơ chế đá hay chặn IP spam.
7. **Pool DB chỉ 1 kết nối** (`database.max=1`, Hikari `maximumPoolSize`, chờ mặc định 30 giây). Lặp đăng nhập (mỗi lần một `SELECT`) làm mọi truy vấn khác phải xếp hàng, kể cả lưu người chơi.
8. **Web không chống spam.** Apache không có `mod_evasive`/giới hạn tần suất. `Options Indexes` bật liệt kê thư mục, `web/` không có `.htaccess`.

## Lỗi bảo mật tài khoản và dữ liệu

1. **Mật khẩu lưu chữ thường** trong `account.password`. Lộ DB là lộ hết. Game so `password = ?` trực tiếp, đổi sang bcrypt phải sửa cả `MrBlue.login`.
2. **Mật khẩu truyền đi coi như chữ thường.** `Network.randomKey` không ai bật nên khóa XOR luôn là `"NRO"`, và khóa còn được gửi lên đường truyền. Không có TLS, không xác thực server. Web long chạy HTTP, không HTTPS.
3. **Tài khoản admin yếu nằm trong git.** `Teamobi2026/team10_long.sql` (có theo dõi) có 3 tài khoản đều `is_admin=1`, mật khẩu dài 1 ký tự. DB trên máy này có 5/6 tài khoản là admin: 1 mật khẩu 1 ký tự, 4 mật khẩu 6 ký tự. Repo private nhưng mật khẩu ngắn thế này đoán ra rất nhanh.
4. **Đăng nhập web không giới hạn số lần thử** (`dang-nhap.php`), không dùng `AntiLogin` của game. Dò mật khẩu qua đây không bị chặn.
5. **Vượt được `AntiLogin` của game**: `al.reset()` chạy khi đăng nhập đúng bất kỳ tài khoản nào, nên kẻ tấn công xen kẽ tài khoản của mình giữa các lần đoán. Giới hạn tính theo IP, nên nhiều IP cũng vượt được.
6. **Captcha đổi mật khẩu dùng lại được** (`doimatkhau.php` không xóa `$_SESSION['captcha']` sau khi kiểm tra), và câu báo lộ tài khoản có tồn tại hay không.
7. **Giới hạn đăng ký theo session** (`dangky.php`): bỏ cookie là hết giới hạn; `token`/`fp` chỉ kiểm tra không rỗng; không captcha. Mỗi tài khoản mới có sẵn `vnd` 1.000.000 (giá trị test).
8. **MySQL `root` không mật khẩu** (`Config.properties`, `web/config.php`), `bind-address` trong `C:\xampp\mysql\bin\my.ini` đang tắt nên nghe mọi card mạng. Web dùng luôn `root`. Máy này `root` chỉ có `localhost`, `127.0.0.1`, `::1` nên từ xa không vào bằng `root` được; rủi ro còn lại là lỗi ở web hoặc phần mềm trên máy chủ dùng được toàn quyền DB.
9. **Trang admin thiếu CSRF** ở `account.php`, `item.php`, `itemshop.php`, `map.php`, `player.php`… (chỉ `ajax_update_shop`, `giftcode`, `ngoc`, `vang` có). Trình duyệt mới mặc định cookie `SameSite=Lax` nên giảm bớt rủi ro. `web/get_cols.php` công khai danh sách cột của `history_transaction`.
10. **Đã sửa 6/11/2026 khi làm lại giao diện web:** bỏ câu khẳng định sai "Mã hóa chuẩn quân đội, HTTPS SSL 256-bit, Anti DDoS, Firewall" ở `tai-khoan.php`; bỏ giấy phép Bộ TT&TT và bản quyền Gomobi ở chân trang; bỏ script tải từ `ngocrongonline.com`, `pay.teamobi.com`, Google Analytics của site khác, ảnh `my.teamobi.com`; escape tên nhân vật ở `bxh01.php`/`bxh02.php` (trước đó in thẳng, có nguy cơ XSS); các trang công khai đều escape qua `site_e`. Trang admin giữ nguyên, chưa rà XSS.
11. **`web/counter.php` nhân đôi số lượt truy cập** (`* 2`). Web mới không hiển thị số này.

## Gian lận game (server tin client)

- `-7` di chuyển nhận `x,y` từ client, chỉ map Ngọc Rồng Đen giới hạn 500 đơn vị (`Controller:386`). Không kiểm tra tốc độ, dịch chuyển tức thời được.
- `Zone.pickItem` không thấy kiểm tra khoảng cách (chỉ chờ 1 giây giữa 2 lần nhặt).
- Mọi tính năng auto có trong mod (tàn sát, bay tới boss, tự nhặt) chạy được vì server không phân biệt.

## Client Unity

Không có bảo vệ thật:

- IL2CPP chỉ làm khó đọc. `global-metadata.dat` không mã hóa, Il2CppDumper dump được (chính repo dùng cách này).
- Không kiểm tra toàn vẹn: `client-patch/*.ps1` sửa byte `GameAssembly.dll` tự do và client vẫn chạy.
- Server không xác minh client: `setClientType` chỉ đọc số version, không chặn gì. Bot tự viết nói chuyện được với server.
- Mật khẩu lưu chữ thường ở `%USERPROFILE%\AppData\LocalLow\...\pass` và `accManager` (`tk$mk|tk$mk`). `NRlink2` XOR khóa `"69"` chỉ là che chữ.

## Manager

- DPAPI chỉ bảo vệ `accounts.txt`. Mỗi lần mở slot, `Core.cs:426` ghi mật khẩu **chữ thường** vào RMS `pass` của slot, file nằm lại trong `LocalLow`.
- Dòng `raw:<mật khẩu>` trong `accounts.txt` là chữ thường đến khi manager lưu lại.
- `NroManager.exe` và `GameAssembly.dll` của slot không ký số, antivirus có thể cảnh báo.
- Manager không liên quan đến chống DDoS.

## Thứ tự nên làm

1. **Ngay**: đổi mật khẩu các tài khoản admin; đặt mật khẩu MySQL, tạo user riêng cho web/game, bật `bind-address=127.0.0.1`; không mở `3306` ra router. Xóa mật khẩu đó khỏi file SQL trong git (lịch sử git vẫn còn).
2. **Sửa lỗi server**: theo các đợt trong [KE-HOACH-SUA-SERVER-BAO-MAT.md](KE-HOACH-SUA-SERVER-BAO-MAT.md).
3. **Web**: giới hạn đăng nhập theo tài khoản và IP, xóa captcha sau khi dùng, đăng ký giới hạn theo IP, thêm CSRF cho admin, tắt `Indexes`, xóa `get_cols.php`, khóa `/admin` theo IP, bật HTTPS.
4. **Mật khẩu**: chuyển bcrypt (web và `MrBlue.login`), dùng khóa ngẫu nhiên `randomKey(true)` chỉ che được người xem lén, muốn chắc phải có TLS/trao đổi khóa trong client.
5. **Chống DDoS thật**: chạy trên VPS có anti-DDoS hoặc proxy TCP chuyên cho game, không để lộ IP thật. Web đặt sau Cloudflare; game TCP thô không đi qua được gói Cloudflare miễn phí. Thêm firewall/`netsh` chặn IP theo log nếu cần.
6. **Chống gian lận**: kiểm tra tốc độ di chuyển và khoảng cách nhặt đồ ở server. Đừng đầu tư vào khóa client, server mới là chỗ quyết định.
