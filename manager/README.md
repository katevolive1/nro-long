# NRO Long Manager

Quản lý nhiều tài khoản, mở nhiều cửa sổ game `nr-long` cùng lúc (học từ AutoManager của AutoMax, không dùng mã của họ). Kế hoạch và các điểm đã dò: [../KE-HOACH-AUTO-MANAGER.md](../KE-HOACH-AUTO-MANAGER.md).

## Build và chạy
- `manager\build.bat` ra `manager\NroManager.exe` (C# 5, dùng `csc.exe` có sẵn trong Windows, không cần cài gì). Mở `NroManager.exe`.
- Lần đầu: **Cài đặt** → chọn thư mục client gốc (`F:\nr-long` hoặc `D:\nr-long`, tự đoán). Thư mục slot nên cùng ổ đĩa với client gốc (khác ổ thì chép file thay vì hard link, tốn ổ đĩa).

## Cách hoạt động
- Mỗi tài khoản có một **slot** `manager\slots\<id>\`: các file client là hard link tới client gốc, riêng `GameAssembly.dll` (bản chép đã vá tự đăng nhập + nhận phím gửi nền) và `globalgamemanagers` + `app.info` (đổi tên công ty `DefaultCompany` → `NROSLOT0000<id>` cùng độ dài).
- Client lưu dữ liệu ở `%USERPROFILE%\AppData\LocalLow\<công ty>\<sản phẩm>`, nên mỗi slot có thư mục lưu riêng. Manager chép dữ liệu cache từ client gốc sang (bỏ `accManager`, `acc`, `pass`...), rồi ghi `acc`/`pass`/`check` của tài khoản đó trước khi mở.
- Client gốc (người chơi tải về) **không bị vá**. Slot tự dựng lại khi client gốc đổi (so kích thước và ngày sửa của `DragonBoy.exe` và `GameAssembly.dll`) hoặc khi đổi tùy chọn tự đăng nhập.
- Tự đăng nhập: bản vá trong [tools/patch-tu-dang-nhap.ps1](tools/patch-tu-dang-nhap.ps1) (cùng mã trong `src/Core.cs`, `PatchAutoLogin`). Offset theo bản client long hiện tại; client đổi bản mà byte không khớp thì manager báo cảnh báo và không vá.

## Giao diện (2 tab, cửa sổ manager kéo dãn được; cửa sổ game giữ cỡ 1024x600 của client, không đổi)
- **Quản lý tài khoản** (theo bố cục QLTK của AutoMax): danh sách bên trái (STT, tài khoản, máy chủ, nhóm, ghi chú, trạng thái, PID); bên phải khung **Cài Đặt** (tài khoản, mật khẩu, máy chủ, nhóm, ghi chú; Thêm / Lưu / Xóa / Làm mới) và **Chức Năng**:
  - Cấu hình (Mặc định / Giảm dung lượng) và FPS (Thường / Cao): ghi vào RMS `background` / `isHighFps` của slot trước khi mở (= ô "Giảm Dung Lượng" / "FPS Cao" trong menu mod).
  - Máy chủ mỗi tài khoản: ghi RMS `svselect` của slot. Danh sách lấy từ `NRlink2` của client gốc (server gửi, XOR khóa "69"), hiện `1. Home (127.0.0.1:14446)`, `2. sv1 (...)`; để "(như client gốc)" thì giữ lựa chọn của client gốc.
  - Đăng nhập (dòng chọn) / tất cả / theo STT từ..đến / theo nhóm; Đóng / Đóng tất cả; Hiện, Thu nhỏ (đã bỏ Xếp lưới 4/11/2026, user không cần); Nhập file, Nhập từ client, Cài đặt.
- **Control** (`src/Control.cs`): gửi phím vào các cửa sổ game, không sửa client, không thêm DB.
  - Trái: danh sách cửa sổ đang chạy có ô tích (cửa sổ mới bật tự tích, đã tắt thì tự bỏ khỏi danh sách), Chọn hết / Bỏ hết, **Cách gửi phím**: *Nền* (`PostMessage`, không giành chuột) hoặc *Bật cửa sổ lên rồi gõ* (đưa từng cửa sổ lên trước rồi `SendInput` phím thật).
  - Phải: Kỹ năng 1–10 (phím số), Khu vực (gõ chat `k <số>`, phím M), Phím tắt của mod (F bông tai, C capsule, Q bay tới boss, T tàn sát, E tự hồi sinh, N tự nhặt, J/K/L qua map, X menu mod), Lệnh chat (`ak`, `dbx`, `ukhu`, lệnh admin `hs`, `m<id>`, ô nhập chat tự do), **Phím tùy chỉnh** (nhập rồi Thêm nút; mặc định F J K L; chuột phải để xóa; lưu `NutPhim` trong `config.ini`), Hiện / Thu nhỏ / Đóng cửa sổ đã tích.
  - Nội dung nút: 1 ký tự = bấm phím đó; `Enter`, `Esc`, `Space`, `Tab`, `F1`..`F12`, `Up/Down/Left/Right` = phím đặc biệt; còn lại = gõ chat (Enter, nội dung, Enter).
  - Lần thử đầu (4/11/2026) phím không ăn: client chỉ nhận phím khi `Input.anyKeyDown` (chỉ bật với phím thật). Bản vá slot thứ 2 (`PatchKeyInput`, `PatchVersion` 3) bỏ điều kiện này; chưa thử lại. Chế độ "Bật cửa sổ lên" giờ dùng `AttachThreadInput` và ghi log nếu không đưa được cửa sổ lên. Chuỗi Enter → gõ → Enter có mở được ô chat không cũng chưa thử.
- Icon `app.ico` (nền đỏ chữ trắng "hnam") nhúng vào exe; tạo lại bằng `tools\make-icon.ps1`.
- `NroManager.exe --tab 2` mở thẳng tab Control. Lỗi lúc khởi động ghi vào `loi.txt` và hiện hộp thông báo.

## Chức năng khác
Mật khẩu mã hóa DPAPI (chỉ đọc được trên máy tạo ra), nhập hàng loạt từ file (`tk|mk|nhóm|ghi chú`, hoặc `tk$mk`) và từ `accManager` của client gốc, mở cách nhau N giây, đặt tiêu đề cửa sổ `[id] tài khoản`, nhận lại cửa sổ còn chạy khi mở lại manager (`state.ini`).

Đã **bỏ tự mở lại cửa sổ khi bị tắt** (4/11/2026, user yêu cầu; nó còn mở lại slot khi game cũ chưa nhả file, gây lỗi "Access to the path 'baselib.dll' is denied"). Dựng lại slot giờ báo rõ nếu game của slot còn chạy.
- **Không xóa được slot khi slot khác đang chạy**: file slot là hard link, `baselib.dll`/`UnityPlayer.dll`/`DragonBoy.exe` cùng dữ liệu đang được nạp ở cửa sổ khác thì Windows chặn xóa mọi tên của file đó (`Access ... denied`) nhưng cho đổi tên. Manager dời slot cũ sang `slots\_rac\` rồi dọn (`SlotBuilder.DonRac`) khi mở manager / lần dựng sau.

## File theo máy (gitignore)
`accounts.txt` (mật khẩu DPAPI; ghi `raw:<mật khẩu>` để chép sang máy khác, manager tự mã hóa lại khi lưu), `config.ini`, `state.ini`, `slots\`, `NroManager.exe`.

## Công cụ
- `tools/buoc0.ps1`: dựng tay 1 slot thử (không vá).
- `tools/thu-slot.ps1`: dựng slot, mở, chờ, báo còn chạy hay crash (`-CoW 800 -CoH 480` thử đổi cỡ), đóng đúng PID đã mở. Đăng nhập thật kiểm tra bằng `account.last_time_login`.
- `tools/make-icon.ps1`: tạo `app.ico`.
- `tools/thu-phim.ps1`: mở slot, chụp riêng cửa sổ game (`PrintWindow`), gửi phím nền, chụp lại, so `data_location` trong DB (lần thử 4/11/2026 bị đóng cửa sổ giữa chừng nên chưa có kết quả).
