# Ghi chú client Unity (PC, IL2CPP)

Đọc file này trước khi đụng vào client, khỏi dò lại từ đầu.

## Thư mục và bản
| Thư mục | Bản | MD5 `GameAssembly.dll` |
|---|---|---|
| `D:\nr-dump\goc` | chỉ giữ `GameAssembly.dll` + `global-metadata.dat` gốc của client int (bản int đã xóa 29/10/2026); chép đè vào client rồi chạy lại mọi script patch là ra bản long | `984E6FD75A748B1158C2330DD863BA8C` |
| `D:\nr-long` (client duy nhất) | long đầy đủ + tên map K(khu) + port 14446 + ô tích mặc định (`patch-mac-dinh.ps1`) + khung nhập trên cùng (`patch-khung-nhap.ps1`) + tổng thỏi vàng (`patch-thoi-vang.ps1`) + thông báo boss lúc vào game (`patch-thong-bao-boss.ps1`) + phím Q bay tới boss (`patch-phim-q.ps1`) + giữ cửa hàng khi server mở form nhập (`patch-giu-cua-hang.ps1`) + mua số lượng 1 gói (`patch-mua-nhanh.ps1`) | `3D784B7207D16EE718D70F0326255857` |

`BC2BD49AE412E904FF835FE83DFD40AC` là bản long **lỗi** cũ (chưa sửa `ReadParamDQT`), nằm trong `NRO-long.rar` cũ: vào game bị đọc lệch gói có đồ.

- File tải trên web: `web\download\NRO-long.rar` trong repo (gitignore, nén từ `D:\nr-long`), web 8080. Cập nhật client: chạy `cap-nhat-client.bat` (chạy mọi script patch rồi nén lại rar; link tải tự đổi `?v=` theo `filemtime`).
- Chưa có APK bản long (APK int cũ đã xóa). iOS chỉ là link TestFlight của người khác, không sửa được.

## Dump
- Il2CppDumper (metadata v31), dump từ `GameAssembly.dll` gốc (`D:\nr-dump\goc`), nằm ở `D:\nr-dump` (ngoài repo, máy khác phải chép theo; máy nhà để ở `F:\nro-dump\nr-dump`, client máy nhà `F:\nr-long`). RVA giống hệt bản long đã patch:
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

Danh sách hàm sắp theo địa chỉ (tìm hàm chứa một RVA, lấy điểm cuối hàm = địa chỉ hàm kế tiếp), Git Bash:
```bash
grep -A1 '"Address"' /d/nr-dump/script.json | paste - - - | sed -E 's/.*"Address": ([0-9]+),.*"Name": "([^"]+)".*/\1 \2/' | sort -n -u > funcs.txt
```
Tìm ai gọi hàm X: quét cả section `il2cpp` (offset `0x17C800`–`0xA51600`) tìm byte `E8`/`E9` có `rva + 5 + rel32 == X` (PowerShell vòng lặp trên `ReadAllBytes`, ~1 phút). Hàm ảo (gọi qua `call rax` với `[vtable+178h+16*(slot-4)]`) không tìm được kiểu này; slot xem `dump.cs`.

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
### Khung đệ tử và nâng tiềm năng (Game1, không cần patch, server xử lý)
- `Panel.doFirePet` (`0x41D2C0`) gọi `Service.petInfo` (`0x48FED0`, gửi `-107`) rồi `setTypePetMain` (`0x459BA0`) + `show`. `doFirePetMain` (`0x41CD70`) chia tab theo `[panel+0C4h]`: 0 đồ đệ mặc, 1 `DoFirePetSkill` (`0x4065A0`, tab "Thông Tin": dòng HP/KI/SĐ/Giáp/Chí mạng gốc + kỹ năng), 2 `doFirePetStatus`, 3 `doFireInventory`. Dòng chọn = `[panel+238h]`.
- `DoFirePetSkill` tạo menu với lệnh 9000/9005/9006/9007 (`0x2328`, `0x232D`–`0x232F`) kèm `bool` đóng gói = **1 (forPet)**; `Panel.perform` (`0x450A20`) gọi `Service.upPotential(forPet, [panel+238h], 1/10/100)` (`0x494190`): gói `-30`, sub = `16 + 2*forPet` (**16 sư phụ, 18 đệ tử**), `writeByte(loại)`, `writeShort(số điểm)`. `ModFunc.DoAutoIncreasePoint` (`0x3D6F..`) cũng gọi hàm này. Server xử lý sub 18 trong `Controller.messageSubCommand` (từ 30/10/2026).
- `Controller.onMessage` Game1 `0x2E7C10` (Game2 `0x322790`), nhánh `-107`: loại 0/1 gán `Char.havePet` (`+400h`; `havePet2` `+401h` ở `0x2FC737`); loại 2 (`0x2E8BC5`–`0x2E991D`) `InfoDlg.hide` rồi chỉ đọc dữ liệu vào `Char.myPetz()` (`cTiemNang` `+128h`, chép hpFull/mpFull/dame/def/crit sang `+5C0h`/`+5C8h`/`+5B8h`/`+5D0h`/`+5D8h` cho tab Thông Tin), **không mở khung**. Nên server gửi lại `-107` loại 2 bất cứ lúc nào thì khung đang mở tự cập nhật.
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

### Mua số lượng gửi 1 gói (`patch-mua-nhanh.ps1`, chỉ Game1)
- `Panel.onChatFromMe` (`0x427690`) → `ModFunc.AutoBuyItem` (`0x3D3E10`, bản 2 `0x3D3F20` type 3) tạo thread `<AutoBuyItem>b__0` (`0x3F9C00`): gốc lặp `count` (`[rbx+18h]`) lần `Service.buyItem(type [+10h], id [+14h], 0)` + `Thread.Sleep(200)`, xong báo "Đã mua xong N". `Service.buyItem` (`0x4886D0`, gói 6: sbyte type, short id, short số lượng nếu > 1).
- Patch `0x3F9C60`–`0x3F9C8B`: `mov r9d,[rbx+18h]`, gọi `buyItem` 1 lần rồi `jmp 0x3F9C8B`. Server: `Controller` case 6 đọc short số lượng nếu còn ≥ 2 byte → `ShopService.takeItem(..., quantity)` → `buyItemQuantity` (tối đa 1000/lần; món thường trừ tiền N lần, gửi hành trang 1 lần; tab đặc biệt gọi `buyItem` N lần).
- Vòng lặp khác của mod có `Thread.Sleep` (chưa sửa): `ModFunc.BanVang` (dùng thỏi vàng, 500ms), `GameScr.RemoveAllItem` (300ms), `ModFunc.CollectAllThuongDe` (openMenu/confirm/buy, 2 giây), `AutoPhaLe`, `CrackBallScr.AutoCrackBall`, `DoAutoNoitai`, `DoAutoIncreasePoint`, `DoFilter`. `Thread.Sleep` = `0x94BAF0`.

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

### Auto Item (`patch-auto-item.ps1`, chỉ Game1)
- `ModFunc.Update` (Game1 `0x3E61C0`): khi không ở map offline, nếu `now - [this+0D8h] >= 1000` (`cmp rax,3E8h` tại `0x3E6799`) thì gọi `UseItemAuto`, rồi nếu `[this+0D2h]` (Cập Nhật Khu) bật thì `Service.openUIZone`, rồi ghi `[this+0D8h] = now`. Đây là chỗ làm AutoItem chỉ chạy 1 lần/giây.
- `ModFunc.UseItemAuto` (Game1 `0x3E6CC0`): danh sách `[this+70h]` (`List<ItemAuto>`) có món và `startAutoItem` (static `+98h`) bật thì dùng từng món một lượt; GameCanvas static `+49h` và `+4Ah` cùng bật thì xóa danh sách + "Đã dừng auto sử dụng Item" (chuỗi `0xCAABE0`). Danh sách trống hoặc auto tắt thì `Task.Delay(200).ContinueWith(...)` (`0x3E7120`, không ảnh hưởng tốc độ).
- `AddOrRemoveAutoItem` (Game1 `0x3D3170`) thông báo `"Đã thêm " + tên + " vào Auto Item"` (chuỗi `0xCAA4E0`) / `"Đã xóa " + tên + " khỏi Auto Item"`.
- Patch: hook `jmp` tại `0x3E678F` → cave `0x59DF60` (thân `Game2.ModFunc.UseItemAuto`, `0x59DF60`–`0x59E4B0`): `UseItemAuto` mỗi 100ms, `openUIZone` chỉ khi `now % 1000 < 100`, về `0x3E67D5`. Phím P: mục 'p' (thứ 15) của bảng nhảy `UpdateKey` `0x3E5098` → `0x59DFE0`: auto đang bật thì tắt, xóa danh sách, hiện câu dừng, trả true (`0x3E5076`); không thì về default `0x3E5083`. Metadata: " vào Auto Item" → " (P: dừng)". Sao lưu `*.truoc-auto-item`.
- Bản 31/10/2026: khoảng cách `$ms` = 50ms (cả cửa sổ `now % 1000 < $ms` cho openUIZone). Hook `0x3E7022` → cave `0x59E100`: `FindItemIndex` (`0x3D8B00`) không thấy thì bỏ qua (`0x3E7063`); `Char.myCharz().arrItemBag[index].quantity` (`Item.quantity` `+38h`, `Item.template` `+18h`) <= 1 thì nhảy `0x3E6E5B` (xóa danh sách + câu dừng + thoát hàm); không thì `Service.useItem(0, where=9, index=-1, template=mã)` (client chỉ ghi `template` khi `index == -1`, `0x4950BA`). Server: `UseItem.doItem` nhánh index -1, `WHERE_AUTO_ITEM` = 9.
- Bỏ phím P (31/10/2026): mod có sẵn cách dừng AutoItem: `UseItemAuto` thấy `GameCanvas.isPointerClick` (static `+49h`) và `isPointerJustRelease` (`+4Ah`) cùng bật (vừa click chuột xong) thì xóa danh sách + "Đã dừng auto sử dụng Item". Lúc chạy 1 lần/giây phải click đúp mới dễ trúng; 50ms thì 1 click thường đủ. Mục 'p' trả về default `0x3E5083`, mã cũ ở `0x59DFE0` để lại không dùng. Chuỗi gợi ý giờ là " (click:dừng)" (15 byte, tối đa bằng chuỗi gốc " vào Auto Item").

### Hành trang/rương trên 127 ô (`patch-o-ruong.ps1`, chỉ Game1)
- Gói `-30` sub 0 (đăng nhập, `Controller.messageSubCommand` Game1 `0x313EB0`): số ô hành trang đọc ở `0x315067` rồi `movsx edx,al` tại `0x31506C`, rương ở `0x315741`/`0x315746` → có dấu, > 127 thành âm. Patch đổi sang `movzx` (`0F BE D0` → `0F B6 D0`).
- Gói `-36` (hành trang) và `-35` (rương) trong `Controller.onMessage` (`0x2F8261`, `0x2F8C8D`) đã đọc không dấu sẵn. `Char.arrItemBag` `+250h`, `arrItemBox` `+258h`.
- Client gửi số thứ tự ô bằng 1 byte (gói `-40`), server đọc `& 0xFF` (`UseItem.getItem`).

### Ctrl+V dán chữ (`patch-dan-chu.ps1`, chỉ Game1)
- Nhận phím: `Main.OnGUI` (Game1 `0x3BE0C0`) → `Main.checkInput` (`0x3BE830`): `Input.anyKeyDown` + `Event.current.type == 4` (KeyDown) → `Event.keyCode` → `MyKeyMap.map` (`0x3F2580`) → `ebx`; giữ Shift (`Input.GetKeyInt` 303/304, `0xA27F40`) thì `-`→`_`, `2`→`@` → `GameCanvas.keyPressedz(ebx)` (`0x3BED19`). Nhả phím: `keyReleasedz`.
- Ô nhập: `TField` (Game1 TypeInfo `0xC96338`): `isFocus` `+10h`, `text` `+28h`, `caretPos` `+40h`, `maxTextLenght` `+48h`; static `currentTField` `+88h`, `isQwerty` `+54h`. `keyPressed(int)` (`0x4D4940`): `isQwerty` và mã >= 0x20 thì `keyPressedAscii` (`0x4D45A0`, chèn ở con trỏ, kiểm tra độ dài, `processTelex` khi gõ tiếng Việt).
- Clipboard: hàm C# `GUIUtility.systemCopyBuffer` bị strip khỏi GameAssembly, nhưng `UnityPlayer.dll` vẫn đăng ký icall `UnityEngine.GUIUtility::get_systemCopyBuffer`; gọi qua export `il2cpp_resolve_icall` (RVA `0xCA960`, script tự đọc bảng export) rồi gọi con trỏ trả về (không tham số, trả `Il2CppString*`: độ dài `+10h`, ký tự UTF-16 `+14h`).
- Patch: hook `0x3BECE1` → cave `0x5758C0` (thân `Game2.Main.checkInput`, 0x6D0 byte): `ebx` là `v`/`V` và giữ Ctrl (KeyCode 306/305) thì dán từng ký tự >= 0x20 vào `currentTField` đang focus bằng `keyPressed`, rồi nhảy `0x3BED1E` (bỏ `keyPressedz`); không thì chạy lại lệnh gốc và về `0x3BECE8`. Sao lưu `GameAssembly.dll.truoc-dan-chu`.

## Tính năng mod có sẵn (kiểm tra trước khi làm mới)
- Lệnh chat của mod: xem bảng "Lệnh chat của client mod" trong `ID-GAME.md` (`k <khu>`, `s <tốc độ>`, `ak`, `ts`, `ahs`, `vqmm`, `dbx`...).
- Phím tắt `ModFunc.UpdateKey` (Game1 `0x3E4B00`, switch `key - 'a'`, bảng nhảy `0x3E5098`): các chữ có xử lý riêng (mục khác `0x3E5083` = không làm gì); `q` do `patch-phim-q.ps1` thêm.
- AutoItem: nút "Thêm vào/Xoá khỏi AutoItem" trong menu item; **click chuột để dừng** (không cần phím riêng).
- Menu mod (nút menu): Chức năng / Tự động / Hiển thị / Cài đặt, bảng ô tích ở mục "Ô tích menu mod".

## Dò crash client (31/10/2026)
- Log game: `C:\Users\<tên>\AppData\LocalLow\DefaultCompany\DragonBoy\Player.log` (lần chạy trước: `Player-prev.log`); bản chép lúc crash: `%TEMP%\DefaultCompany\DragonBoy\Crashes\Crash_<ngày_giờ>\{Player.log,crash.dmp}`. Windows ghi thêm Application Error (Id 1000) trong Event Viewer. Game cài ở `F:\nr-long` (máy nhà), không phải `D:\nr-long`.
- Crash 12:13: mã `0x80000003` (Unity tự dừng, không phải lỗi bộ nhớ) trong `UnityPlayer.dll`, ngay sau dòng `Graphics device is null.` với stack được: `GUIStyle.CalcSize` ← `mFont.getWidthExactOf` ← `splitFontVector` ← `splitFontArray` ← `Info.getInfo` ← `Info.addInfo` ← `InfoMe.addInfo` ← `ExecutionContext.RunInternal`. Nghĩa là một **luồng nền** (Thread/Task của mod) gọi `InfoMe.addInfo` (hiện thông báo), mà đo chữ bằng `GUIStyle` thì Unity chỉ cho luồng chính. Không có reset GPU trong Event Log. `ArgumentNullException ... shader` ở `mGraphics.CreateLineMaterial` lúc khởi động là lỗi cũ vô hại.
- Luồng nền của mod có gọi thông báo (cần soi khi crash lại): `AutoBuyItem` (`<AutoBuyItem>b__0`, "Đã mua xong N"), `BanVang`, `RemoveAllItem`, `CollectAllThuongDe`, `AutoPhaLe`, `AutoCrackBall`, `DoAutoNoitai`, `DoAutoIncreasePoint`, `DoFilter`, và `Task.Delay(200).ContinueWith` trong `UseItemAuto`.

## Thanh máu (dò 31/10/2026, chưa patch)
- Thư mục icon x4 của user: `F:\AILinhTinh\icons_x4` (14430 file png, tên theo id icon).
- `GameScr.paintHPBar_NEW` (Game1 `0x3716F0`–`0x371B60`): vẽ khung (ảnh static `GameScr+5C0h`) + thanh HP/MP (ảnh `+590h`, `drawRegion` theo `cHP/cHPFull` = `[c+0D0h]/[c+108h]`, MP `[c+0C8h]/[c+110h]`) + tên `[c+190h]` bằng `mFont.drawString`. Chỉ có 1 chỗ gọi: `GameScr.paintInfoBar` (`0x372F20`) tại `0x3733FF`, truyền `Char.myCharz()` → đây là khung **của bản thân** (góc trên trái), không phải khung mục tiêu.
- `Char.PaintCharName_HP_MP_Overhead` (Game1 `0x2AE250`–`0x2AEE70`): tên + thanh HP trên đầu nhân vật/boss, gọi `Char.paintHp` (`0x2BF380`), `mFont.drawStringBorder`, `ModFunc.PaintTicks`.
- Khung mục tiêu giữa trên màn hình = `GameScr.paintInfoBar` (`0x372F20`), không có khung ảnh, chỉ 2 dòng chữ căn giữa (x = `[GameScr+228h]/2`): tên (y+9) và HP (y+22). Font gốc `[mFont static+80h]` = `tahoma_7b_green2` (xanh lá). Nhánh theo `Char.myCharz()`: `+2A8h` quái (HP `getMoneys(mob+50h)`), `+2C0h` NPC, `+2C8h` người/boss (HP `getMoneys(c+0D0h)`), không có mục tiêu thì hiện tên + vàng của mình. Font `mFont` static: `+50h` red, `+60h` white, `+80h` green2, `+0C0h` tahoma_7_green2. `cHP` `Char+0D0h`, `cHPFull` `+108h` (double).
- `patch-khung-muc-tieu.ps1` (31/10/2026, chỉ Game1): nhánh người/boss đổi font `+80h`→`+50h` (đỏ) tại `0x3736C5`, `0x373784`; hook `0x3737A8` → cave `0x59C000` (thân `Game2.ModFunc.UpdateKey`, tới `0x59C07A`): chuỗi HP = `getMoneys(cHP) + "/" + getMoneys(cHPFull)` (`String.Concat` 3 chuỗi `0x786510`, ô "/" `0xCACAF8`), `mov r14,rax`, `jmp 0x37364B`. Quái/NPC và tên + vàng của mình giữ xanh. Sao lưu `*.truoc-khung-muc-tieu`. Đã thêm vào `cap-nhat-client.bat`.
- Màn trắng khi bị choáng: chưa tìm ra. Đã loại: `Char.blindEff` (`+605h`) không có chỗ nào tô trắng cả màn (`Char.update` chỉ thêm ServerEffect 113 mỗi 10 tick). Các chỗ tô trắng toàn màn trong `GameScr.paint`: `0x377670` (isFreez `GameScr+168h`, chớp mỗi 4 tick; `Controller.onMessage` `0x2F491A` bật), `0x37A4E1` và `0x37A6EC` (hợp thể: `gameTick%3==0`), `0x37B3EF` ("x power=", `GameScr+16Ch`). Chưa biết cái nào là cái user thấy khi choáng.
- Màn trắng khi bị Thái Dương Hạ San = `GameScr.paint` Game1 `0x377664`–`0x3776C6`: `setColor(0xFFFFFF)` + `fillRect` toàn màn mỗi khung hình khi bộ đếm `[GameScr+15Ch]` > 50 (cờ `isFreez` `+168h`, `Controller.onMessage` `0x2F491A` bật khi nhận hiệu ứng, `Char.update` tắt). `patch-bo-man-trang.ps1` (31/10/2026): NOP call `setColor` `0x377678` và `fillRect` `0x3776C1`, giữ nguyên logic. Sao lưu `*.truoc-bo-man-trang`. (Các chỗ trắng khác: hợp thể `0x37A4E1`/`0x37A6EC`, "x power" `0x37B3EF` vẫn giữ.)
- **Thanh máu xanh bo góc giữa trên màn hình khi click đệ/boss/người** (hiện chữ `HP/HP tối đa` trong thanh): do mod vẽ trong `ModFunc.PaintListInfo` (Game1 `0x3DDDA0`), **không phải** `paintInfoBar` (hàm đó chỉ vẽ chữ tên/HP mục tiêu ở trên cùng). Điều kiện: `charFocus != null` và `Char.isMeCanAttackOtherPlayer(charFocus)`. `cx = GameCanvas.w/2`; `fillRect` bo góc (Game1 `0x3D1C30`, đối số cuối là bán kính): khung `0x808080` (`cx-4Eh, 43h, 9Ch, 12h, r 0Ch`) → nền `0x2B2B2B` (`cx-4Ch, 45h, 98h, 0Eh, r 0Ah`) → thanh `0xFF00`/`0xFFFF00`/`0xFF0000` theo % máu (`cx-4Bh, 46h, %*k, 0Ch, r 8`) → chữ `getMoneys(cHP)+"/"+getMoneys(cHPFull)` font `mFont+60h` (`drawStringBorder` tại `cx+1, 46h`). Sau đó `ebx = 57h` và vẽ các dòng trạng thái màu đỏ (`mFont+50h`): "Đang khiên năng lượng", "Bị choáng", "Bị thôi miên", "Đang biến khỉ", "Bị TDHS: ", "Bị trói". Code phía sau cần `r15 = 0`, `rdi = charFocus`, `rsi = g`.
  - `patch-bo-thanh-muc-tieu.ps1` (31/10/2026): viết đè từ `0x3DDEF6` (217 byte, còn trống tới `0x3DE0D1`): bỏ khung + thanh + chữ trắng, thay bằng 2 dòng chữ đỏ viền (`mFont+50h`, `drawStringBorder` với `[statics+8]` canh giữa, `[statics+0D8h]` font viền): tên `[charFocus+190h]` ở y `43h`, `getMoneys(cHP)+"/"+getMoneys(cHPFull)` ở y `4Dh`; x = `cx+1`; rồi `jmp 0x3DE0D1` (dòng trạng thái giữ nguyên). Script nhận cả bản gốc lẫn bản đầu chỉ bỏ thanh (`45 33 FF E9 D3 01 00 00`). Sao lưu `*.truoc-bo-thanh-muc-tieu`. Đã thêm vào `cap-nhat-client.bat`.
  - Ghi chú khi dò: Game1 có gọi sang hàm tên `Game2.*` (vd `Game2.mGraphics$$setColor` `0x3D2D30`) do trình biên dịch gộp hàm giống nhau, nên quét lời gọi theo địa chỉ Game1 có thể sót. Cách tìm được chỗ này: quét lệnh `divsd xmm,[reg+108h]` (chia cho `cHPFull`) trên toàn bộ code.
- 31/10/2026: user yêu cầu hoàn tác `patch-khung-muc-tieu.ps1` (chữ đỏ + HP/HP tối đa) để làm lại theo yêu cầu mới. Đã khôi phục byte gốc ở `F:\nr-long\GameAssembly.dll` (font `+80h`, hook `0x3737A8`, cave `0x59C000`), gỡ khỏi `cap-nhat-client.bat`; file script vẫn để trong `client-patch` làm mẫu. Máy khác đã chạy script này thì chép lại `GameAssembly.dll.truoc-khung-muc-tieu` (nhưng bản đó chưa có `patch-bo-man-trang`, chạy lại `cap-nhat-client.bat`).
