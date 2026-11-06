# Kế hoạch: nro-long-manager (quản lý nhiều tài khoản, mở nhiều cửa sổ game)

Trạng thái: **đang làm** (lập và duyệt 3/11/2026). Code nằm trong repo này ở `manager\` (đổi từ `F:\nro-long-manager` theo yêu cầu dùng chung 1 git), hướng dẫn: [manager/README.md](manager/README.md). Các điểm ở mục 4 chưa được trả lời nên làm theo mặc định đề xuất: C# WinForms, vá tự đăng nhập chỉ trong slot, mật khẩu DPAPI, bỏ qua giai đoạn 3; giai đoạn 2 (thông tin nhân vật từ DB, hẹn giờ, chụp màn hình) chưa làm.

## 0. Kết quả đã chạy (3/11/2026)
- **Bước 0 đạt**: slot hard link + đổi `DefaultCompany` → `NROSLOT0000001` cho thư mục RMS riêng `LocalLow\NROSLOT0000001\DragonBoy`; mở được slot cùng client gốc.
- Tham số Unity `-screen-width/-height` **bị client bỏ qua** (luôn ra 1024x600 trong, 1040x639 ngoài). Kéo cửa sổ bằng `SetWindowPos` thì **được** (thử 800x480, sau 6 giây vẫn giữ, không crash), nhưng user không cần đổi cỡ cửa sổ game nên đã bỏ ô "Kích thước" (4/11/2026); chỉ cửa sổ manager co giãn.
- Giao diện 2 tab theo ảnh QLTK + Control Manager của AutoMax (4/11/2026 theo yêu cầu): tab 1 chạy được, tab 2 chỉ dựng giao diện, chờ duyệt mục 6.
- Slot không vá chạy bình thường và kết nối `192.168.1.11:14446`.
- Bản vá tự đăng nhập: lần 1 **crash** vì ô `AutoLogin_TypeInfo` (`0xCA45E0`) chưa được nạp lười (mọi hàm IL2CPP gọi `0x99030` với địa chỉ ô trước khi dùng; `ModFunc.AutoLogin()` chưa dùng kiểu này). Lần 2 thêm `lea rcx,[ô]; call 0x99030` đầu cave: **chạy được**, slot mở lên tự vào game (DB `account.last_time_login` đổi đúng lúc mở, cửa sổ chạy 35 giây không crash).
- **Chưa thử**: tự đăng nhập lại sau khi rớt mạng/bảo trì (cờ `AutoLogin.waitToNextLogin` +10h bị đặt true sau lần `doLogin` đầu, chưa dò chỗ nào đặt lại về false); mở 2 tài khoản cùng lúc; giao diện `NroManager.exe` (mới build, chưa bấm thử).
- Lỗi `shader == null` ở `mGraphics.CreateLineMaterial` và dòng `host: ngocrongprivate.kozow.com:14446` trong Player.log **có cả ở client gốc**, không phải lỗi của slot.
- Tool thử: `manager\tools\thu-slot.ps1` (không chụp màn hình vì `CopyFromScreen` bắt cả vùng màn hình ngoài game; kiểm tra đăng nhập bằng `account.last_time_login` trong DB).

## 1. Đã dò: AutoMax / AutoManager (bản 0.1.3)

Thư mục: `C:\Users\nguye\OneDrive\Desktop\game\giainenvr\AutoMax [version 0.1.3]\AutoMax [version 0.1.3]`.

| File | Là gì |
|---|---|
| `AutoMax.exe` + `GameAssembly.dll` + `AutoMax_Data` | client Unity đã mod (game NRO khác, có auto); `global-metadata.dat` không mã hóa (v27, Il2CppDumper đọc được) nhưng tên class/hàm game đã bị đổi tên làm rối (không có `GameScr`, `ModFunc`…), dump ra cũng khó đọc. Không cần cho plan này |
| `AutoManager.exe` (chỉ còn file `*.PendingOverwrite`) | **script AutoIt** biên dịch (`AU3!EA06`). Windows Defender báo phần mềm không mong muốn |
| `AutoControl.exe` | .NET, điều khiển từ xa qua ngrok (theo HDSD) |
| `Data\DataAccount.ini` | danh sách tài khoản, mỗi dòng `stt\|tài khoản\|server\|ghi chú\|mật khẩu mã hóa (hex)` |
| `Data\Logins\<tk>_sv<n>` | thời điểm đăng nhập lần cuối (ms) của từng tài khoản |
| `Data\port.ini` = `17072` | cổng TCP manager mở; client bấm phím **P** để kết nối vào manager |
| `Data\size.ini` = `480\|320\|0` | cỡ cửa sổ game |
| `Data\anti_cmd.ini`, `char_id_exclusions.ini`, `clan_id_exclusions.ini`, `danh_sach_khong_che.ini` | bỏ qua câu chat, loại trừ nhân vật/bang khi auto, danh sách ID điều khiển |
| `CaptureScreen\<tên nhân vật>\DP*.png` | ảnh chụp màn hình theo nhân vật (phím W) |

- Đã giải ngược được script AutoManager (52.567 dòng, công cụ C# tự viết theo cách của AutoIt-Ripper: giải mã LAME seed `0x18EE`, bỏ 16 byte sau dấu `AU3!EA06`, giải nén JB, nhánh độ dài 296 đọc 8 bit cộng 255). Nhưng code đã bị **làm rối**: mỗi chuỗi do một hàm riêng có luồng điều khiển xáo trộn sinh ra, nên không đọc được tên nút hay giao thức. Chỉ thấy: 1 ListView tài khoản, 6 nút, 5 ô nhập, 1 combo, khung đăng nhập key (ô mật khẩu), dùng TCP, `WinMove`/`WinSetTitle`/`WinActive` để sắp xếp cửa sổ.
- HDSD (Google Docs) chỉ nói phía client: phím tắt, lệnh chat, `delayX` (nghỉ X ms khi **nhận lệnh dùng kỹ năng từ auto manager**), kết nối nhiều máy qua `ngrok tcp 17072`.
- Kết luận: AutoManager = danh sách tài khoản + mở/sắp xếp cửa sổ + kênh TCP để client của họ nhận lệnh (đánh đồng loạt). Kênh TCP cần client của họ nên **không chép được**; phần quản lý tài khoản và cửa sổ thì tự làm được cho client `nr-long`.

## 2. Đã dò: client nr-long đăng nhập thế nào

- Dữ liệu (RMS) nằm ở `%USERPROFILE%\AppData\LocalLow\DefaultCompany\DragonBoy\`, **dùng chung cho mọi cửa sổ**. File chuỗi có 2 byte độ dài (big-endian) rồi tới nội dung: `acc`, `pass`; `check` (1 byte, nhớ mật khẩu); `accManager` = danh sách tài khoản của mod, dạng `tk$mk|tk$mk|...`.
- `LoginScr..ctor`, `LoginScr.setUserPass` và **`LoginScr.doLogin` (Game1 `0x3B84B0`) đều đọc lại `acc`/`pass` từ RMS** mỗi lần đăng nhập. Vì vậy cách "ghi acc/pass rồi mở thêm cửa sổ" chỉ đúng lúc mở; khi rớt mạng (bảo trì 4h30) mọi cửa sổ tự đăng nhập lại sẽ cùng vào tài khoản ghi sau cùng.
- Mod có sẵn `ModFunc.accounts` (đọc `accManager` trong `LoadAcc`), `AddAccount`, `ModFunc.AutoLogin()` (`0x3D44E0`: nếu `autoLogin.accAutoLogin` có tên thì tìm trong danh sách, ghi `acc`/`pass` vào RMS rồi `doLogin`), ô tích "Tự Động Đăng Nhập" (`isAutoLogin`, static `+68h`, **mặc định tắt, không lưu RMS**).
- Thư mục RMS = `LocalLow\<companyName>\<productName>`, hai tên này nằm trong `DragonBoy_Data\globalgamemanagers` (`DefaultCompany` offset 1176, `DragonBoy` offset 1196) và `app.info`.
- Server không giới hạn số kết nối cùng IP (`AntiLogin.canLogin` luôn true), chỉ giới hạn tổng `Manager.MAX_PLAYER`.

## 3. Cách làm đề xuất

### 3.1 Mỗi tài khoản một "slot" client (không phải sửa mã game)
- Slot = thư mục `F:\nro-long-manager\slots\<số>\` có `DragonBoy.exe`, `GameAssembly.dll`, `UnityPlayer.dll`, `DragonBoy_Data\...` là **hard link** tới client gốc (`F:\nr-long` / `D:\nr-long`, đặt trong cấu hình). Chỉ `globalgamemanagers` và `app.info` là bản chép, đổi `DefaultCompany` thành `NROSLOT0000001` (giữ đúng 14 ký tự) → slot có thư mục RMS riêng `LocalLow\NROSLOT0000001\DragonBoy\`.
- Kết quả: mỗi cửa sổ nhớ tài khoản riêng, rớt mạng tự đăng nhập lại đúng tài khoản; tốn thêm ổ đĩa gần như bằng 0.
- Trước khi mở, manager chép các file RMS của client gốc sang thư mục RMS của slot (server, cache ảnh/dữ liệu, ô tích) rồi ghi đè `acc`, `pass`, `check`.
- Client gốc được cập nhật (`cap-nhat-client.bat`) thì hard link có thể bị đứt; manager so ngày sửa file và tự tạo lại slot trước khi mở.

### 3.2 Tự bấm đăng nhập
- `isAutoLogin` mặc định tắt. Đề xuất: manager giữ một bản `GameAssembly.dll` riêng cho các slot (bản chép của client gốc, vá `isAutoLogin` = 1 trong `ModFunc..cctor`), client gốc người chơi tải về **không đổi**. Offset sẽ dò khi làm (cách giống `patch-mac-dinh.ps1`).

### 3.3 Chương trình
- C# WinForms, biên dịch bằng `csc.exe` có sẵn trong Windows (`C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe`), không cần cài gì. `build.bat` ra `NroManager.exe`.
- Cấu trúc:
  ```
  F:\nro-long-manager\
    src\*.cs, build.bat, README.md
    config.ini        đường dẫn client gốc, cỡ cửa sổ, số cột, giây chờ giữa 2 lần mở  (mỗi máy một bản)
    accounts.txt      tk|mk|nhóm|ghi chú   (mật khẩu mã hóa DPAPI, chỉ máy đó đọc được; gitignore)
    slots\            (gitignore)
  ```

### 3.4 Chức năng

**Giai đoạn 1 (bản dùng được)**
1. Bảng tài khoản: STT, tài khoản, nhóm, ghi chú, trạng thái cửa sổ (chưa mở / đang mở / đang chạy / đã tắt), PID. Thêm, sửa, xóa; nhập hàng loạt từ file txt `tk|mk|ghi chú` hoặc từ `accManager` của client gốc.
2. Mở cửa sổ đã chọn / mở tất cả / mở theo nhóm: chạy lần lượt, cách nhau N giây (mặc định 5) cho đỡ nặng máy. Chạy với tham số Unity `-screen-width W -screen-height H -screen-fullscreen 0`.
3. Đặt tiêu đề cửa sổ = tên tài khoản (`SetWindowText`) để biết cửa sổ nào là ai.
4. Xếp cửa sổ thành lưới theo số cột; đưa cửa sổ lên trước khi bấm đúp vào dòng; thu nhỏ / hiện tất cả.
5. Đóng cửa sổ đã chọn / đóng tất cả.
6. ~~Tự mở lại cửa sổ bị tắt~~: đã làm rồi bỏ (4/11/2026, user không cần).

**Giai đoạn 2**
7. Thông tin nhân vật đọc từ DB (`account` + `player`): tên nhân vật, hành tinh, sức mạnh, vàng/ngọc/thỏi vàng, đang online hay không (`last_time_login` > `last_time_logout`). Cách lấy: xem mục 4.
8. Hẹn giờ mở/đóng theo nhóm; chụp màn hình từng cửa sổ vào `CaptureScreen\<tài khoản>\`.
9. Đồng bộ danh sách tài khoản vào `accManager` của các slot để dùng menu đổi tài khoản có sẵn trong mod.

**Giai đoạn 3 (thử nghiệm, chưa chắc làm được)**
10. Gửi phím / câu chat (lệnh mod như `ak`, `k 5`) tới nhiều cửa sổ cùng lúc. Unity có thể không nhận phím gửi vào cửa sổ không được chọn; phải thử mới biết.

**Không làm**: kênh TCP điều khiển như AutoMax (đánh đồng loạt, combo), AutoControl/ngrok: cần thêm mạng vào client, khối lượng lớn.

## 4. Cần chốt
1. **Công nghệ**: C# WinForms biên dịch bằng `csc.exe` có sẵn (đề xuất) hay Java Swing (dùng chung JDK của server)?
2. **Tự đăng nhập**: vá `isAutoLogin` chỉ trong bản `GameAssembly.dll` của slot (đề xuất), hay vá luôn client gốc để mọi người chơi đều mặc định bật?
3. **Thông tin nhân vật (giai đoạn 2)**: (a) thêm trang PHP nhỏ trong `web\` (port 8080, đã có kết nối DB) trả JSON, có khóa bí mật; (b) manager kết nối thẳng MySQL (phải tải thêm `MySql.Data.dll`); (c) bỏ qua.
4. **Git**: `F:\nro-long-manager` thành repo riêng (private, như `nro-long`) để đồng bộ nhà/công ty, hay đặt thành thư mục con `manager\` trong repo `nro-long`? `accounts.txt` và `slots\` luôn gitignore.
5. **Mật khẩu**: mã hóa DPAPI (file tài khoản chỉ dùng được trên máy đã tạo, mỗi máy nhập riêng; đề xuất) hay lưu chữ thường như cột `account.password` trong DB (chép được giữa 2 máy)?
6. Có cần giai đoạn 3 (gửi phím/chat cho nhiều cửa sổ) không?

## 5. Bước 0: thử khả thi trước khi code (khoảng 30 phút)
1. Tạo tay 1 slot bằng hard link, đổi company name trong `globalgamemanagers` + `app.info`, chạy cùng lúc với client gốc: kiểm tra có thư mục `LocalLow\NROSLOT0000001\DragonBoy\` mới, 2 cửa sổ chạy song song, mỗi cửa sổ nhớ tài khoản riêng.
2. Thử tham số `-screen-width/-screen-height/-screen-fullscreen 0`.
3. Tắt server bằng `bt`, xem 2 cửa sổ có tự đăng nhập lại đúng tài khoản không (khi đã bật ô "Tự Động Đăng Nhập" bằng tay).

Bước 0 hỏng ở điểm 1 thì chuyển sang phương án dự phòng: vá client đọc `acc`/`pass` từ biến môi trường (`System.Environment.GetEnvironmentVariable` còn trong GameAssembly, RVA `0x91C3F0`) do manager đặt riêng cho từng cửa sổ.

## 6. Tab Control (gửi lệnh vào các cửa sổ game) — **đã chốt 4/11/2026, đã làm**

Chốt: (1) chỉ cách A (gửi phím), **không thêm DB/không sửa server**; (2) ai dùng manager cũng dùng được hết; (3) danh sách tích riêng trong tab Control, mặc định tích mọi cửa sổ vừa bật; (4) thêm khung "Phím tùy chỉnh" như ảnh AutoMax (nhập rồi Thêm nút, mặc định F J K L). Vì không có server làm hộ nên bỏ các nút AutoMax không có tương ứng trong mod: Auto vào khu / Khu tìm kiếm / Vào vị trí, Dùng itemID, Dịch tới CharID, Bom boss, Capsule Goback, Ngọc Rồng Đen. Có thêm 2 cách gửi (nền / bật cửa sổ lên) vì chưa thử được Unity có nhận phím gửi nền không. Hướng dẫn: [manager/README.md](manager/README.md). Bảng dưới là phương án ban đầu để tham khảo.

Giao diện đã dựng theo ảnh "Control Manager" của AutoMax (tab 2 trong `NroManager.exe`), các nút đang khóa. Client `nr-long` không có kênh nhận lệnh như AutoMax (họ thêm socket vào client), nên phải chọn cách gửi lệnh:

| Cách | Làm gì | Ưu | Nhược |
|---|---|---|---|
| **A. Gửi phím vào cửa sổ** (`PostMessage` `WM_KEYDOWN`/`WM_CHAR` tới cửa sổ Unity) | Bấm phím số chọn kỹ năng, mở ô chat gõ lệnh mod có sẵn (`k <khu>`, `ak`, `ts`, `ahs`...) | Không sửa client, không sửa server; dùng lại phím/lệnh mod có sẵn | **Chưa biết Unity có nhận phím gửi vào cửa sổ không được chọn không** (phải thử trước); gõ chat chậm, không biết lệnh có chạy không |
| **B. Server làm hộ** (manager ghi lệnh vào bảng DB mới `manager_lenh`, server đọc mỗi giây, như `giftcode_reload_request`) | Đổi khu, dịch tới map ID / CharID / boss, hồi sinh, về nhà, dùng item theo ID, chạy lệnh chat, ngắt kết nối | Chắc chắn chạy, biết kết quả, không phụ thuộc client | Phải sửa + build server; không bấm được kỹ năng hay bật auto phía client (`ak`, `ts`) |
| C. Vá client thêm socket như AutoMax | Mọi thứ | Mạnh nhất | Vá GameAssembly bằng mã máy, khối lượng rất lớn; **không đề xuất** |

**Đề xuất: B + A.** Nút nào server làm được thì đi đường B (chắc chắn), còn Kỹ năng 1–10 và các lệnh auto phía client (`ak`, `ts`, `ahs`) đi đường A sau khi thử được gửi phím. Bảng nút:

| Nút trên tab Control | Đường | Ghi chú |
|---|---|---|
| Kỹ năng 1–10 | A | phím số |
| Khu 0–10, OK (nhập số) | B (`ChangeMapService` đổi khu) hoặc A (`k <số>`) | |
| Auto vào khu / Dừng vào khu, Khu tìm kiếm, Vào vị trí, Đổi khu | B | server thử lần lượt các khu trong danh sách đến khi vào được |
| Nhập itemID → Dùng | B (`UseItem` món đầu tiên có id đó trong túi) | |
| Hồi sinh tại chỗ / Về nhà (Die) | B | |
| Capsule / Capsule Goback | B (mở menu capsule) | cần dò thêm |
| Trở đến Boss / Dịch đến mục tiêu / Nhập CharID | B (dịch tới boss gần nhất / nhân vật theo id) | |
| Bom Boss, Hồi Skill | B | Hồi skill: server có lệnh admin `hs`; mở cho manager thì **chỉ dùng cho nhân vật của manager trên máy chủ nhà** |
| Nhập map ID | B (`m<id>` là lệnh admin) | như trên |
| Nhập mã lệnh (chat) | A (lệnh mod) hoặc B (lệnh server) | |
| Disconnect All | B (server ngắt phiên) hoặc đóng cửa sổ | |
| Ngọc Rồng Đen (ảnh AutoMax) | — | server long chưa rõ có NRĐ, chưa làm |

Cần chốt:
1. Chọn B + A như trên, hay chỉ B (bỏ nút kỹ năng), hay chỉ A?
2. Các thao tác kiểu admin (dịch map tùy ý, hồi skill, dịch tới boss) qua manager: có giới hạn cho tài khoản admin / máy chủ nhà không, hay ai chạy manager cũng dùng được? (Manager chạy trên máy người chơi thì bảng DB phải qua server, không cho ghi thẳng DB.)
3. Chọn cửa sổ nhận lệnh: tích chọn trong danh sách ở tab 1, hay thêm danh sách tích riêng trong tab Control?
