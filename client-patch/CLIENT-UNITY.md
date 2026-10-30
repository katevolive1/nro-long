# Ghi chú client Unity (PC, IL2CPP)

Đọc file này trước khi đụng vào client, khỏi dò lại từ đầu.

## Thư mục và bản
| Thư mục | Bản | MD5 `GameAssembly.dll` |
|---|---|---|
| `D:\nr-dump\goc` | chỉ giữ `GameAssembly.dll` + `global-metadata.dat` gốc của client int (bản int đã xóa 29/10/2026); chép đè vào client rồi chạy lại mọi script patch là ra bản long | `984E6FD75A748B1158C2330DD863BA8C` |
| `D:\nr-long` (client duy nhất) | long đầy đủ + tên map K(khu) + port 14446 + ô tích mặc định (`patch-mac-dinh.ps1`) + khung nhập trên cùng (`patch-khung-nhap.ps1`) + tổng thỏi vàng (`patch-thoi-vang.ps1`) + thông báo boss lúc vào game (`patch-thong-bao-boss.ps1`) + phím Q bay tới boss (`patch-phim-q.ps1`) + giữ cửa hàng khi server mở form nhập (`patch-giu-cua-hang.ps1`) | `1760598AF3BC5F074DDC905F1B1FBF6F` |

`BC2BD49AE412E904FF835FE83DFD40AC` là bản long **lỗi** cũ (chưa sửa `ReadParamDQT`), nằm trong `NRO-long.rar` cũ: vào game bị đọc lệch gói có đồ.

- File tải trên web: `web\download\NRO-long.rar` trong repo (gitignore, nén từ `D:\nr-long`), web 8080. Cập nhật client: chạy `cap-nhat-client.bat` (chạy mọi script patch rồi nén lại rar; link tải tự đổi `?v=` theo `filemtime`).
- Chưa có APK bản long (APK int cũ đã xóa). iOS chỉ là link TestFlight của người khác, không sửa được.

## Dump
- Il2CppDumper (metadata v31), dump từ `GameAssembly.dll` gốc (`D:\nr-dump\goc`), nằm ở `D:\nr-dump` (ngoài repo, máy khác phải chép theo). RVA giống hệt bản long đã patch:
  - `dump.cs`: khai báo class/hàm kèm `RVA` và `Offset`.
  - `script.json`: `ScriptMethod` (Address = RVA, Name = `Game1.Class$$Method`).
  - `stringliteral.json`: chuỗi trong code và địa chỉ ô chứa chuỗi (RVA).
- Đổi RVA sang offset trong file với `.text`: **offset = RVA − 0x1800**.
- Mọi class game có **2 bản sao: `Game1.*` và `Game2.*`**. Sửa gì cũng phải sửa cả hai.

## Công cụ: `tools/xref.cs`
```powershell
Add-Type -Path D:\AILinhTinh\nro-long\client-patch\tools\xref.cs
# Hàm nào dùng chuỗi/ô dữ liệu này (địa chỉ lấy từ stringliteral.json)
[Xref]::Find('D:\nr-long\GameAssembly.dll','D:\nr-dump\script.json',[long[]]@(0xC991E8))
# Liệt kê lệnh call và chuỗi được nạp trong một khoảng RVA (vd từ đầu hàm tới hàm kế tiếp)
[Xref]::Calls('D:\nr-long\GameAssembly.dll','D:\nr-dump\script.json','D:\nr-dump\stringliteral.json',0x3E0550,0x3E0C40)
```
Cách tìm nhanh một chữ hiện trên màn hình: tìm chuỗi trong `stringliteral.json` → lấy `address` → `Find` ra tên hàm → `Calls` để xem thứ tự vẽ.

## Công cụ: `tools/dis.cs` (dịch ngược, cần Iced)
Máy không có Python/objdump. Tải Iced 1.21.0 từ NuGet (`https://api.nuget.org/v3-flatcontainer/iced/1.21.0/iced.1.21.0.nupkg`, giải nén `lib/netstandard2.0/Iced.dll`) vào thư mục tạm, rồi:
```powershell
Add-Type -Path <thư mục>\Iced.dll
Add-Type -Path D:\AILinhTinh\nro-long\client-patch\tools\dis.cs -ReferencedAssemblies <thư mục>\Iced.dll,netstandard
[Dis]::Run('D:\nr-long\GameAssembly.dll','D:\nr-dump\script.json',0x3E0838,0x3E0AA0)   # có chú thích tên hàm/chuỗi/TypeInfo
```
Ghi chú IL2CPP: chuỗi literal khởi tạo lười ở đầu mỗi hàm bằng `lea rcx,[ô chuỗi]; call 0x99030`; dùng chuỗi ở hàm khác thì phải tự gọi `0x99030` trước. Static field: `mov rcx,[X_TypeInfo]; mov rcx,[rcx+0B8h]` rồi cộng offset trong `dump.cs`. Hàm IL2CPP nhận thêm `MethodInfo*` cuối (đặt 0). Trong `ModFunc.Paint`, `r13` luôn = 0.
- Section `il2cpp` (code game): VA `0x17E000`, raw `0x17C800` (cũng là offset = RVA − 0x1800). Vùng trống cuối section: RVA `0xA52C3E`–`0xA52E00`; đã dùng `0xA52C40`–`0xA52DC2`.
- Hàm hay dùng: `Int32.ToString` `0x8C99F0`, `String.Concat(s,s)` `0x786730`, `String.Concat(s,s,s,s)` `0x785FB0`, `Char.myCharz` (Game1) `0x2B91B0`, `mFont.drawStringBorder` (Game1) `0x3CAEB0`.
- Ô chuỗi có sẵn: `" "` `0xCA8F30`, `"K"` `0xCA54C8`, `"("` `0xCAB660`, `")"` `0xCABC28`, `" ("` `0xCA9138`.

## Đã sửa
- **HP/KI kiểu long**: `myReader.readIntToLongDQT()` đọc 4 byte nếu `ModFunc.isReadInt` (static, ô `0x12`) = true, 8 byte nếu cả `isReadInt` lẫn `isReadDouble` (`0x13`) = false. `ModFunc..cctor` gán `isReadInt = true` bằng lệnh `C6 41 12 01`; đổi byte cuối thành `00` ở offset **`0x3E6298`** (Game1) và **`0x59D538`** (Game2). Script: `patch.ps1`. Hàm đọc này có 64 chỗ gọi; danh sách gói tin server phải `writeLong` ghi ở `nro-long\CLAUDE.md`.
  - **Cờ `isReadInt` còn đổi hành vi các hàm khác của `myReader`** (quét mọi chỗ đọc `ModFunc` static `+12h/+13h`): `ReadParamDQT` (param option: true → 2 byte, false → **4 byte**), `DefShotToLong` (true → short, false → long; Game1 không ai gọi), `readByteToInt` (true → sbyte, false → int; không ai gọi). Server gửi param option bằng `writeShort` nên `patch.ps1` đổi `jne`→`jmp` trong `ReadParamDQT` (RVA `0x4043E6` Game1 / `0x1D0D16` Game2, `75 3C`→`EB 3C`) để luôn đọc 2 byte. `readShortOptionTemp` dùng cờ khác (`+128h`), không bị ảnh hưởng.
  - Runtime dùng **Game1** (log Unity ghi `Game1.Controller...`). Log client: `%USERPROFILE%\AppData\LocalLow\DefaultCompany\DragonBoy\Player.log`; cache dữ liệu (RMS) cũng ở thư mục đó, dùng chung cho mọi client.
- **Tên map + K(khu)** (`patch-khu-map.ps1`): dòng `"Khu: " + TileMap.zoneID` (ngay trên dòng tọa độ) thành `TileMap.mapName + " K(" + zoneID + ")"`. Hook `jmp` tại RVA `0x3E094C` (Game1) / `0x597BEC` (Game2), phần còn lại tới `0x3E0973` / `0x597C13` thành NOP; mã mới ở `0xA52C40` / `0xA52CF0` (2 lần `Concat4`), xong `jmp` về. Script cũng nới VirtualSize của section `il2cpp` bằng RawSize. Sao lưu: `GameAssembly.dll.truoc-khu-map`.
- **Port mặc định 14446 + bỏ dòng "Mod INT free by Srcnrofree.online"** (`patch-port.ps1 <thư mục client>`): `GameMidlet..cctor` gán `GameMidlet.PORT` (static `+0x8`) bằng `C7 41 08 6D 38 00 00`; đổi `6D`→`6E` ở offset file `0x3A4329` (Game1) / `0x55B929` (Game2). Chuỗi khung nhập IP/PORT (ô `0xCA8AE0`, dùng trong `ServerListScreen.ShowInputServer`) sửa trực tiếp trong `global-metadata.dat`: bảng string literal v31 ở header `+8` (offset bảng), `+12` (size), `+16` (offset data); mỗi mục `{int len, int dataIndex}` → ghi chuỗi mới ngắn hơn đè lên và giảm `len`. Script .ps1 có chuỗi tiếng Việt phải lưu UTF-8 **có BOM** (PowerShell 5.1). Sao lưu: `*.truoc-port`.
- **[id] vật phẩm**: đã bỏ (vsItem 14) vì client có sẵn ô "Hiện ID Item/NPC" (`ModFunc.isShowID`).
  - Gói `-28` sub 8 (`Controller.loadItemNew`): loại 1 = danh sách đầu, lưu `NRitem1`; loại 2 = phần còn lại, **ghi đè** `NRitem2`, rồi đọc dart/effect/arrow/skill và gọi `Service.clientOk`. Nên chỉ được gửi **đúng 1 gói loại 1 + 1 gói loại 2**, mỗi gói ≤ 65535 byte (độ dài ghi 2 byte). Chia nhiều gói loại 2 thì cache chỉ còn gói cuối, lần sau vào game bị treo ở "Xin chờ".

## Bản đồ đã dò
### `ModFunc.Paint(mGraphics g)`: chữ dưới thanh máu
- Game1: RVA `0x3E0550` (offset `0x3DED50`). Game2: RVA `0x5977F0` (offset `0x595FF0`).
- Thứ tự vẽ: Vàng (`NinjaUtil.getMoneys`) → Ngọc → `"Khu: " + số khu` → **`"X: " + Char.myCharz().cx + " - Y: " + Char.myCharz().cy`** → Số sao (`"Số Sao : "`, `"Số Sao Cần Đập : "`, `"Chưa Có"`).
- Dòng tọa độ (Game1): ghép chuỗi ở RVA `0x3E09E6`–`0x3E0A36`, vẽ bằng `mFont.drawStringBorder` ở RVA `0x3E0A82` (offset `0x3DF282`). Game2: quanh RVA `0x597C86`–`0x597CD6`.
- Ô chứa chuỗi: `"X: "` `0xC9AC48`, `" - Y: "` `0xCA9250`, `"Khu: "` được nạp ở RVA `0x3E0964`.

### `ModFunc.perform`
- Dùng chuỗi `"Tọa độ X: "` (ô `0xC991E8`) ở RVA `0x3E9F59`, `0x3EB248` (Game1); `0x5A11F9`, `0x5A24E8` (Game2). Không phải dòng dưới thanh máu, có lẽ là thông báo khi bấm mục trong menu mod.

### Ô tích menu mod (`ModFunc`, nút menu → Chức năng / Tự động / Hiển thị / Cài đặt)
| Ô | Field | Lưu RMS? | Mặc định |
|---|---|---|---|
| FPS Cao | `isHighFps` (+162h) | `isHighFps`, `!= 0` | bật |
| Cập Nhật Khu | `isUpdateZones` (+0D2h) | không | bật (patch) |
| Nhân Vật Trong Khu | `showCharsInMap` (+0D0h) | không | bật |
| Thông Tin Bản Thân | `showInfoMe` (+150h) | không | tắt |
| Tự Động Pha Lê Hóa / VQMM | `isAutoPhaLe` (+38h) / `isAutoVQMM` (+39h) | không | tắt |
| Tự Động Hồi Sinh | `autoWakeUp` (+29h) | `autoWakeUp`, `!= 0` (patch, gốc `== 1`) | bật |
| Tự Động Đăng Nhập | static `isAutoLogin` (+68h) | | tắt |
| Ẩn Player | static `AnPlayer` (+0EDh) | `anplayer`, `== 1` | tắt |
| Hiện ID Item/NPC | static `isShowID` (+0EEh) | chỉ ghi `showid`, không đọc | bật (patch) |
| Hiện Hành Trang Lưới | static `isInventory` (+0E8h) | `LoadGame` luôn gán 1 | bật |
| Giảm Dung Lượng | static `GiamDungLuong` (+0ECh) | `background`, `== 1` | tắt |
| Gõ Tiếng Việt | static `isVietnamese` (+17h) | không | tắt (gốc; bản patch cũ bật, nay đổi lại) |
| Kẻ đường tới BOSS | `lineToBoss` (+0C0h), vẽ trong `ModFunc.Paint` `0x3E1489` | không | bật (patch, chỉ Game1) |
| Tự focus boss | `focusBoss` (+0C1h), dùng trong `ModFunc.Update` | không | tắt |

`Rms.loadRMSInt` trả `-1` khi chưa có. Field instance nằm trên `ModFunc` (đặt trong `.ctor` `0x3E8FB0`), static đặt trong `.cctor` `0x3E76C0`, đọc RMS trong `LoadGame` `0x3DA260`. Game2 = Game1 + `0x1B72A0` (riêng `ModFunc`). Script: `patch-mac-dinh.ps1` (cctor: `+17h`=1 và ghi thêm `+0EEh`=1 vào chỗ 2 lệnh nạp lại rcx; LoadGame `cmp eax,1/sete` → `cmp eax,0/setne`; ctor `mov [rdi+0D0h],1` → jmp cave `0xA52D90`/`0xA52DB0` ghi thêm `+0D2h`=1, cave Game1 ghi thêm `+0C0h`=1 nên dài 26 byte tới `0xA52DAA`). Sao lưu: `*.truoc-mac-dinh`.

### Phím tắt mod (`ModFunc.UpdateKey`, Game1 `0x3E4B00`) và phím Q (`patch-phim-q.ps1`, chỉ Game1)
- `switch (key - 'a')`, 24 mục a..x, bảng nhảy RVA `0x3E5098` (mỗi mục 4 byte = RVA đích), mục trống trỏ `0x3E5083` (trả false). Đoạn thoát chung trả true: `0x3E4FD3` (`mov al,1` rồi epilogue). Lúc nhảy vào mục: `rbx` = ModFunc, khung `push rdi; sub rsp,30h` (dùng được `[rsp+20h..2Fh]` và ô home `[rsp+48h..5Fh]`).
- Phím đang dùng: a c d e f g h j k l m n q s t u w x. Còn trống: b i o p r v.
- Q: mã đặt ở thân `Game2.ModFunc.UpdateKey` (RVA `0x59BDA0`, 0x600 byte; chỉ `Game2.GameScr.updateKey` gọi nên không chạy) dài 372 byte. Duyệt `GameScr.vCharInMap` (static `+0F0h`), lọc giống `AutoFocusBoss` (`0x3D4280`: `charID` +90h < 0, `cTypePk` +295h == 5, `cName` +190h không bắt đầu bằng "Đ"), chọn |dx|+|dy| nhỏ nhất (`cx` +6Ch, `cy` +70h) → `Char.FocusManualTo` `0x2ADDE0` → `ModFunc.MoveTo(x, y)` `0x3DB5D0` (đặt vị trí + `Service.charMove`). Mã sinh bằng Iced Assembler; lệnh tương đối RIP dựng bằng `Instruction.Create(code, reg, ref new MemoryOperand(Register.RIP, đích))` vì `AssemblerRegisters` không có `rip`.
- Thân hàm Game2 không gọi tới là chỗ trống lớn khi cave cuối section đã hết; kiểm tra không có lệnh `call`/`jmp` nào từ Game1 trỏ vào trước khi dùng. Thân `Game2.ModFunc.UpdateKey` đã dùng: `0x59BDA0`–`0x59BF14` (Q), `0x59BF20`–`0x59BF51`, `0x59BF60`–`0x59BF96` (giữ cửa hàng); còn trống tới `0x59C3A0`.

### Giữ khung cửa hàng khi server mở form nhập (`patch-giu-cua-hang.ps1`, chỉ Game1)
- Mua số lượng: client tự mở `Panel.OpenShopBuyQuantityInput` (`0x40AF..`, chuỗi "Nhập số lượng mua"), ô nhập là `chatTField` nằm trong khung, nhập xong `Panel.onChatFromMe` gửi mua → khung không đóng.
- Form của server (gói `-125`, vd bán thỏi vàng `Input.createFormBanSLL`): `Controller2.readMessage` → `ClientInput.init` + `switchToMe` (màn hình riêng). Bấm vào ô nhập = bấm ngoài khung → `Panel.updateKey` nhánh `0x463BB8`–`0x463C13` (`isPointerJustRelease` và không `isPointer(x,y,w,h)` và `[+259h]`=0) gọi `Panel.hide`.
- `GameCanvas.update` (`0x3A3D10`): luôn gọi `currentScreen.update` (slot 7, `+1A8h`); `Panel.updateKey` (`0x4638C0`) khi khung mở; `currentScreen.updateKey` (slot 8, `+1B8h`, `0x3A5066`) chỉ khi `panel.isShow` (`+10h`) = 0 và không có `ChatPopup`. Phím gõ: `keyPressedz` → `mapKeyPress` → `currentScreen.keyPress` không phụ thuộc khung.
- Patch: đầu `Panel.updateKey` nhảy cave `0x59BF20`: `GameCanvas.currentScreen` (static `+0C8h`) có lớp == `ClientInput_TypeInfo` (`0xCA5528`) thì `ret`. `0x3A4FFF` (`cmp [panel+10h],0; jne 3A5079`) nhảy cave `0x59BF60`: khung mở mà currentScreen là ClientInput thì vẫn tới `0x3A504F` gọi `updateKey`.
- `mScreen` slot: 4 `switchToMe` (`+178h`), 5 `unLoad` (`+188h`), 6 `keyPress`, 7 `update`, 8 `updateKey`, 9 `paint`. `Panel.hide` `0x425180`, `hideNow` `0x424D00`.

### Hành trang nhảy lên đầu khi cất đồ vào rương (đã sửa ở server)
- Nguyên nhân: `InventoryService.sendItemBox` luôn gửi kèm `-35` loại 1 (`openBox`) → client `Panel.setTypeBox` + `show` dựng lại khung, cuộn về đầu. Khi cất/lấy đồ (rương đang mở) gọi `sendItemBox(player, false)` để chỉ gửi dữ liệu. Lấy đồ ra vẫn phải gửi `-35` loại 0, không thì rương còn hiện món đã lấy.
- Cất hết 1 món: món cuối hành trang chuyển vào ô trống rồi gửi cả hành trang (`-36` loại 0, client không đụng tới khung); cất một phần: `-36` loại 2 (`sendItemBagSlot`: index + số lượng, 0 = xóa ô).
- **Đừng NOP lệnh reset cuộn trong `Panel.setTabInventory`** (Game1 `0x4559E0`, nhánh lưới `mov [rbx+30h],rax` ở RVA `0x455AFA`, Game2 `0x222DEA`): đã thử, làm phần lưới bên dưới ẩn chậm khi bấm X (hiệu ứng đóng `Panel.hide` → `moveCamera` trượt `cmx`), nên đã hoàn tác.

### Khung nhập của server bị khung cửa hàng/hành trang đè (`patch-khung-nhap.ps1`, chỉ Game1)
- `GameCanvas.paint` (Game1 `0x39F4D0`): `currentScreen.paint` (`0x39F67B`) → `Panel.paint` ×2 → `ChatTextField.paint` → `0x39F9D8` → `InfoDlg.paint` → `Menu.paintMenu`… `g` = `[rdi+10h]`, `r15` = 0, static `currentScreen` = `+0C8h`, `panel` `+0D8h`, `panel2` `+0E0h`. Nhánh không vẽ khung nhảy thẳng tới `0x39F9D8`.
- `ClientInput` (Game1 namespace `Game1.Assets.src.g`, TypeInfo `0xCA5528`) là `mScreen`; `paint` `0x4E5A40`: `GameScr.paint` (`call r9` `0x4E5AEE`) → hộp `PopUp.paintPopUp` + tiêu đề + `TField.paint` → tail `mScreen.paint` (nút Đóng/OK).
- Patch: `0x4E5AF1` trả về ngay sau `GameScr.paint`; cave B (.text `0x17D378`) dựng lại frame rồi nhảy `0x4E5AFB` để vẽ hộp; cave C (.text `0x17D3B8`) móc ở `0x39F9D8`: nếu `[currentScreen] == ClientInput_TypeInfo` thì gọi cave B. Phần dư cuối `.text` (RVA `0x17D374`–`0x17D400`, offset = RVA − `0xC00`) giờ đã dùng hết; script nới VirtualSize `.text`.

### Số thỏi vàng ở thanh dưới khung (`patch-thoi-vang.ps1`, chỉ Game1)
- `Panel.paintBottomMoneyInfo` Game1 `0x429C10`: vòng lặp `0x429ED4`–`0x429F31` tìm món 457 (`1C9h`, so `template+10h`) đầu tiên trong `arrItemBag` rồi lấy `quantity` (`item+38h`) → `NinjaUtil.getMoneys(double)` `0x3F5280` → `rsi`. Patch viết lại tại chỗ để cộng mọi chồng 457 (chồng khóa giao dịch và chồng giao dịch được có option khác nhau nên server không gộp).

### Thông báo boss lúc vào game không chạy chữ (`patch-thong-bao-boss.ps1`, chỉ Game1)
- Gói 93 → `GameScr.chatVip` Game1 `0x35F400`: đoạn `0x35F468`–`0x35F567` là chữ chạy dưới màn hình (khởi động khi `[rdi+2A4h]`=0, thêm vào vector static `+580h`), sau đó gọi `BossCustom.addBoss` `0x4E45E0` (tab Thông báo của mod, `Panel.setTabInfoBoss`/`setTabBossNotification`) và `ShowBoss.HandleChatVip` `0x4CFD10` (khung góc phải).
- Mod chỉ nhận câu `BOSS <tên> vừa xuất hiện tại <tên map>` (`getBossXuatHien` cắt chữ đầu tới dấu cách, thay " vừa xuất hiện tại " bằng `|`, tách tên/map; mapId tra `TileMap.mapNames`, giờ xuất hiện = lúc nhận). Câu giết: `<người>: Đã tiêu diệt được <boss> mọi người đều ngưỡng mộ.`
- Patch: `0x35F468` → `jmp` cave `0xA52DC8`; chuỗi có ký tự đầu `\t` (`[rbx+14h]`=9) thì nhảy thẳng `0x35F568`. Server gửi `\t` + câu xuất hiện cho người vừa đăng nhập (`BossManager.sendBossAlive`).
