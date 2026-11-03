# Kế hoạch: nro-long-manager (quản lý nhiều tài khoản, mở nhiều cửa sổ game)

Trạng thái: **chờ duyệt** (lập 3/11/2026). Code sẽ nằm ở `F:\nro-long-manager`.

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
6. Tự mở lại: cửa sổ bị tắt hay crash thì mở lại sau N giây (bật/tắt được).

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
