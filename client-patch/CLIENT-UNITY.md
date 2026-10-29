# Ghi chú client Unity (PC, IL2CPP)

Đọc file này trước khi đụng vào client, khỏi dò lại từ đầu.

## Thư mục và bản
| Thư mục | Bản | MD5 `GameAssembly.dll` |
|---|---|---|
| `D:\nr` | int (gốc) | `984E6FD75A748B1158C2330DD863BA8C` |
| `D:\nr-long` | long + tên map K(khu) | `37BA093DA6982640A5180E1844B9972D` (chỉ long: `BC2BD49AE412E904FF835FE83DFD40AC`) |
| `D:\nr-long-exe` | int (user chép nhầm, chưa patch) | như bản gốc |

- File tải trên web: `C:\xampp\htdocs\download\NRO.rar` (int), `NRO-long.rar` (long, nén từ `D:\nr-long`). Web 8080 trỏ bản int, web 8081 trỏ bản long.
- APK (`NRO.apk`) vẫn là int, chưa patch (lib ARM, metadata khác bản PC). iOS chỉ là link TestFlight của người khác, không sửa được.

## Dump
- Il2CppDumper (metadata v31), dump từ `D:\nr\GameAssembly.dll`, nằm ở `D:\nr\dump`:
  - `dump.cs`: khai báo class/hàm kèm `RVA` và `Offset`.
  - `script.json`: `ScriptMethod` (Address = RVA, Name = `Game1.Class$$Method`).
  - `stringliteral.json`: chuỗi trong code và địa chỉ ô chứa chuỗi (RVA).
- Đổi RVA sang offset trong file với `.text`: **offset = RVA − 0x1800**.
- Mọi class game có **2 bản sao: `Game1.*` và `Game2.*`**. Sửa gì cũng phải sửa cả hai.

## Công cụ: `tools/xref.cs`
```powershell
Add-Type -Path D:\AILinhTinh\nro-long\client-patch\tools\xref.cs
# Hàm nào dùng chuỗi/ô dữ liệu này (địa chỉ lấy từ stringliteral.json)
[Xref]::Find('D:\nr\GameAssembly.dll','D:\nr\dump\script.json',[long[]]@(0xC991E8))
# Liệt kê lệnh call và chuỗi được nạp trong một khoảng RVA (vd từ đầu hàm tới hàm kế tiếp)
[Xref]::Calls('D:\nr\GameAssembly.dll','D:\nr\dump\script.json','D:\nr\dump\stringliteral.json',0x3E0550,0x3E0C40)
```
Cách tìm nhanh một chữ hiện trên màn hình: tìm chuỗi trong `stringliteral.json` → lấy `address` → `Find` ra tên hàm → `Calls` để xem thứ tự vẽ.

## Công cụ: `tools/dis.cs` (dịch ngược, cần Iced)
Máy không có Python/objdump. Tải Iced 1.21.0 từ NuGet (`https://api.nuget.org/v3-flatcontainer/iced/1.21.0/iced.1.21.0.nupkg`, giải nén `lib/netstandard2.0/Iced.dll`) vào thư mục tạm, rồi:
```powershell
Add-Type -Path <thư mục>\Iced.dll
Add-Type -Path D:\AILinhTinh\nro-long\client-patch\tools\dis.cs -ReferencedAssemblies <thư mục>\Iced.dll,netstandard
[Dis]::Run('D:\nr-long\GameAssembly.dll','D:\nr\dump\script.json',0x3E0838,0x3E0AA0)   # có chú thích tên hàm/chuỗi/TypeInfo
```
Ghi chú IL2CPP: chuỗi literal khởi tạo lười ở đầu mỗi hàm bằng `lea rcx,[ô chuỗi]; call 0x99030`; dùng chuỗi ở hàm khác thì phải tự gọi `0x99030` trước. Static field: `mov rcx,[X_TypeInfo]; mov rcx,[rcx+0B8h]` rồi cộng offset trong `dump.cs`. Hàm IL2CPP nhận thêm `MethodInfo*` cuối (đặt 0). Trong `ModFunc.Paint`, `r13` luôn = 0.
- Section `il2cpp` (code game): VA `0x17E000`, raw `0x17C800` (cũng là offset = RVA − 0x1800). Vùng trống cuối section: RVA `0xA52C3E`–`0xA52E00`; đã dùng `0xA52C40`–`0xA52D8F`.
- Hàm hay dùng: `Int32.ToString` `0x8C99F0`, `String.Concat(s,s)` `0x786730`, `String.Concat(s,s,s,s)` `0x785FB0`, `Char.myCharz` (Game1) `0x2B91B0`, `mFont.drawStringBorder` (Game1) `0x3CAEB0`.
- Ô chuỗi có sẵn: `" "` `0xCA8F30`, `"K"` `0xCA54C8`, `"("` `0xCAB660`, `")"` `0xCABC28`, `" ("` `0xCA9138`.

## Đã sửa
- **HP/KI kiểu long**: `myReader.readIntToLongDQT()` đọc 4 byte nếu `ModFunc.isReadInt` (static, ô `0x12`) = true, 8 byte nếu cả `isReadInt` lẫn `isReadDouble` (`0x13`) = false. `ModFunc..cctor` gán `isReadInt = true` bằng lệnh `C6 41 12 01`; đổi byte cuối thành `00` ở offset **`0x3E6298`** (Game1) và **`0x59D538`** (Game2). Script: `patch.ps1`. Hàm đọc này có 64 chỗ gọi; danh sách gói tin server phải `writeLong` ghi ở `nro-long\CLAUDE.md`.
- **Tên map + K(khu)** (`patch-khu-map.ps1`): dòng `"Khu: " + TileMap.zoneID` (ngay trên dòng tọa độ) thành `TileMap.mapName + " K(" + zoneID + ")"`. Hook `jmp` tại RVA `0x3E094C` (Game1) / `0x597BEC` (Game2), phần còn lại tới `0x3E0973` / `0x597C13` thành NOP; mã mới ở `0xA52C40` / `0xA52CF0` (2 lần `Concat4`), xong `jmp` về. Script cũng nới VirtualSize của section `il2cpp` bằng RawSize. Sao lưu: `GameAssembly.dll.truoc-khu-map`.
- **[id] vật phẩm**: làm ở server, không sửa client (`ItemData.nameWithId`, `DataGame.vsItem` = 10 để client tải lại tên).

## Bản đồ đã dò
### `ModFunc.Paint(mGraphics g)`: chữ dưới thanh máu
- Game1: RVA `0x3E0550` (offset `0x3DED50`). Game2: RVA `0x5977F0` (offset `0x595FF0`).
- Thứ tự vẽ: Vàng (`NinjaUtil.getMoneys`) → Ngọc → `"Khu: " + số khu` → **`"X: " + Char.myCharz().cx + " - Y: " + Char.myCharz().cy`** → Số sao (`"Số Sao : "`, `"Số Sao Cần Đập : "`, `"Chưa Có"`).
- Dòng tọa độ (Game1): ghép chuỗi ở RVA `0x3E09E6`–`0x3E0A36`, vẽ bằng `mFont.drawStringBorder` ở RVA `0x3E0A82` (offset `0x3DF282`). Game2: quanh RVA `0x597C86`–`0x597CD6`.
- Ô chứa chuỗi: `"X: "` `0xC9AC48`, `" - Y: "` `0xCA9250`, `"Khu: "` được nạp ở RVA `0x3E0964`.

### `ModFunc.perform`
- Dùng chuỗi `"Tọa độ X: "` (ô `0xC991E8`) ở RVA `0x3E9F59`, `0x3EB248` (Game1); `0x5A11F9`, `0x5A24E8` (Game2). Không phải dòng dưới thanh máu, có lẽ là thông báo khi bấm mục trong menu mod.
