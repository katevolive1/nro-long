# Né Boss và Tàn sát Boss ở tab BOSS của menu mod (phím X), kèm lệnh chat neboss / tsboss; bỏ nút "Hướng Dẫn Xài Mod" (chỉ Game1).
#   Tàn sát Boss: cờ PickMob static +16h. Bật thì PickMobController.Update vào thẳng nhánh tàn sát người, mục tiêu chỉ là boss
#     (charID < 0, cTypePk == 5, tên không bắt đầu "Đệ", còn máu), ưu tiên boss đang trỏ (charFocus). Bật thì tự tắt tàn sát quái/người và Né Boss.
#   Né Boss: cờ PickMob static +17h. Mỗi khung ModFunc.Update kiểm tra vCharInMap, thấy boss thì gửi đổi khu (khu kế tiếp, tránh khu hiện tại),
#     chờ đủ 5,2 giây giữa 2 lần (server chặn đổi khu 5 giây). Bật thì tự tắt Tàn sát Boss. Thời gian/khu lần cuối lưu ở .bss của hàm Game2.Mob (không chạy).
#   Id lệnh mới trong ModFunc.perform: 0x3D tsBoss, 0x3E neBoss. Chữ tạo bằng il2cpp_string_new (không sửa global-metadata).
# Mã mới đặt ở thân Game2.ModFunc.perform (RVA 0x5A0EC0, 10304 byte, chỉ hàm Game2 không chạy gọi tới).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-ne-tan-sat-boss.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }
function Jmp([long]$from, [long]$to, [byte]$op) { $r = [BitConverter]::GetBytes([int]($to - ($from + 5))); return ,[byte[]](@($op) + $r) }
function Nops([int]$n) { if ($n -le 0) { return ,[byte[]]@() }; return ,[byte[]](@(0x90) * $n) }

$b = [IO.File]::ReadAllBytes($Dll)
$cave = @{}
$cave['IsBoss'] = 0x5A0EC0
$cave['CanTs'] = 0x5A0F20
$cave['NeBossTick'] = 0x5A0F50
$cave['UpdHook'] = 0x5A10B0
$cave['PerformHook'] = 0x5A10C0
$cave['TabCave'] = 0x5A11F0
$cave['ChatHook'] = 0x5A12F0
$cave['PickCave'] = 0x5A1370

# ---- mã mới (caves) ----
$new = @(
    @{ Off = 0x5A0EC0 - 0x1800; New = (Hex '48 85 C9 74 53 83 B9 90 00 00 00 00 7D 4A 80 B9 95 02 00 00 05 75 41 48 8B 81 90 01 00 00 48 85 C0 74 35 83 78 10 02 7C 1C 44 0F B7 50 14 41 81 FA 10 01 00 00 75 0E 44 0F B7 50 16 41 81 FA C7 1E 00 00 74 13 0F 57 C0 66 0F 2F 81 D0 00 00 00 73 06 B8 01 00 00 00 C3 31 C0 C3') },   # IsBoss
    @{ Off = 0x5A0F20 - 0x1800; New = (Hex '48 8B 05 29 AB 70 00 48 8B 80 B8 00 00 00 80 78 16 00 74 12 49 89 C9 48 89 D1 E8 81 FF FF FF 4C 89 C9 84 C0 74 05 E9 75 79 D1 FF 31 C0 C3') },   # CanTs
    @{ Off = 0x5A0F50 - 0x1800; New = (Hex '53 56 57 48 83 EC 20 48 8B 05 F2 AA 70 00 48 3D 00 00 10 00 0F 82 30 01 00 00 83 B8 E0 00 00 00 00 0F 84 23 01 00 00 48 8B 80 B8 00 00 00 48 85 C0 0F 84 13 01 00 00 80 78 17 00 0F 84 09 01 00 00 31 C9 E8 18 82 D1 FF 48 85 C0 0F 84 F9 00 00 00 48 8B 05 B8 66 70 00 48 3D 00 00 10 00 0F 82 E6 00 00 00 48 8B 80 B8 00 00 00 48 85 C0 0F 84 D6 00 00 00 48 8B 98 F0 00 00 00 48 85 DB 0F 84 C6 00 00 00 31 FF 48 89 D9 31 D2 E8 80 DD C1 FF 39 C7 0F 8D B2 00 00 00 48 89 D9 89 FA 45 31 C0 E8 BB DA C1 FF FF C7 48 89 C1 E8 C1 FE FF FF 84 C0 74 D3 31 C9 E8 96 1B E6 FF 48 8B 0D 9F 5E 75 00 48 89 C2 48 29 CA 48 81 FA 50 14 00 00 72 7A 48 89 05 89 5E 75 00 31 C9 E8 B2 4F DC FF 48 85 C0 74 67 48 8B 48 70 48 85 C9 74 5E 8B 71 18 83 FE 02 7C 56 48 8B 05 6D 5A 6F 00 48 8B 80 B8 00 00 00 8B 90 84 00 00 00 0F B6 05 59 5E 75 00 FF C0 39 F0 72 02 31 C0 39 D0 75 08 FF C0 39 F0 72 02 31 C0 88 05 3F 5E 75 00 89 C3 31 C9 E8 CE AF EE FF 48 85 C0 74 13 48 89 C1 89 DA 41 B8 FF FF FF FF 45 31 C9 E8 46 F8 EE FF 48 83 C4 20 5F 5E 5B C3') },   # NeBossTick
    @{ Off = 0x5A10B0 - 0x1800; New = (Hex 'E8 9B FE FF FF 31 D2 48 89 D9 E9 88 51 E4 FF') },   # UpdHook
    @{ Off = 0x5A10C0 - 0x1800; New = (Hex '83 FF 3D 74 17 83 FF 3E 0F 84 96 00 00 00 83 FF 3C 0F 8E B6 9C E4 FF E9 CC 8F E4 FF 48 8B 05 6D A9 70 00 83 B8 E0 00 00 00 00 75 0F 48 89 C1 E8 EC 81 AF FF 48 8B 05 55 A9 70 00 48 8B 80 B8 00 00 00 0F B6 48 16 83 F1 01 88 48 16 84 C9 74 0C C6 40 10 00 C6 40 11 00 C6 40 17 00 48 8D 0D 16 1C 00 00 48 8D 15 F8 1B 00 00 80 78 16 00 48 0F 45 CA E8 79 9C B2 FF 48 89 C2 48 8B 05 1F 65 70 00 48 8B 80 B8 00 00 00 48 8B 88 C8 02 00 00 48 85 C9 74 0B 45 31 C0 45 31 C9 E8 71 B8 E0 FF E9 1F A3 E4 FF 48 8B 05 E5 A8 70 00 83 B8 E0 00 00 00 00 75 0F 48 89 C1 E8 64 81 AF FF 48 8B 05 CD A8 70 00 48 8B 80 B8 00 00 00 0F B6 48 17 83 F1 01 88 48 17 84 C9 74 04 C6 40 16 00 48 8D 0D 6E 1B 00 00 48 8D 15 56 1B 00 00 80 78 17 00 48 0F 45 CA E8 F9 9B B2 FF 48 89 C2 48 8B 05 9F 64 70 00 48 8B 80 B8 00 00 00 48 8B 88 C8 02 00 00 48 85 C9 74 0B 45 31 C0 45 31 C9 E8 F1 B7 E0 FF E9 9F A2 E4 FF') },   # PerformHook
    @{ Off = 0x5A11F0 - 0x1800; New = (Hex '41 B8 34 00 00 00 48 89 FA 45 31 C9 48 89 C1 48 89 C3 E8 59 7E D6 FF 45 31 C0 48 89 DA 48 89 F1 E8 3B D8 C1 FF 48 8B 05 34 A8 70 00 83 B8 E0 00 00 00 00 75 0F 48 89 C1 E8 B3 80 AF FF 48 8B 05 1C A8 70 00 48 8B 80 B8 00 00 00 48 8D 0D F7 1A 00 00 48 8D 15 D9 1A 00 00 80 78 16 00 48 0F 45 CA E8 5A 9B B2 FF 48 89 C7 48 8B 0D E8 43 70 00 E8 8B 7F AF FF 45 31 C9 41 B8 3D 00 00 00 48 89 FA 48 89 C1 48 89 C3 E8 E4 7D D6 FF 45 31 C0 48 89 DA 48 89 F1 E8 C6 D7 C1 FF 48 8B 05 BF A7 70 00 83 B8 E0 00 00 00 00 75 0F 48 89 C1 E8 3E 80 AF FF 48 8B 05 A7 A7 70 00 48 8B 80 B8 00 00 00 48 8D 0D 5A 1A 00 00 48 8D 15 42 1A 00 00 80 78 17 00 48 0F 45 CA E8 E5 9A B2 FF 48 89 C7 48 8B 0D 73 43 70 00 E8 16 7F AF FF 41 B8 3E 00 00 00 48 89 FA E9 CF AB E4 FF') },   # TabCave
    @{ Off = 0x5A12F0 - 0x1800; New = (Hex '48 8D 0D 59 1A 00 00 E8 B4 9A B2 FF 48 89 C2 48 89 D9 45 31 C0 E8 26 76 1E 00 84 C0 74 07 BA 3D 00 00 00 EB 23 48 8D 0D 3B 1A 00 00 E8 8F 9A B2 FF 48 89 C2 48 89 D9 45 31 C0 E8 01 76 1E 00 84 C0 74 20 BA 3E 00 00 00 48 89 F9 45 31 C0 45 31 C9 E8 DA 88 E4 FF B0 01 48 8B 5C 24 30 48 83 C4 20 5F C3 31 D2 C7 44 24 48 00 00 00 00 48 89 D9 E9 7C 43 E3 FF') },   # ChatHook
    @{ Off = 0x5A1370 - 0x1800; New = (Hex '44 38 61 16 74 05 E9 EE CA F2 FF 44 38 61 10 0F 85 14 D0 F2 FF E9 B6 CA F2 FF') },   # PickCave
    @{ Off = 0x5A2D00 - 0x1800; New = (Hex '4E C3 A9 20 42 6F 73 73 20 5B 42 E1 BA AD 74 5D 00 4E C3 A9 20 42 6F 73 73 20 5B 54 E1 BA AF 74 5D 00 54 C3 A0 6E 20 73 C3 A1 74 20 42 6F 73 73 20 5B 42 E1 BA AD 74 5D 00 54 C3 A0 6E 20 73 C3 A1 74 20 42 6F 73 73 20 5B 54 E1 BA AF 74 5D 00 74 73 62 6F 73 73 00 6E 65 62 6F 73 73 00') }   # chữ UTF-8
)

# ---- hook trong Game1 (RVA, byte gốc, byte mới) ----
$hooks = @(
    # ModFunc.Update sau khối khởi tạo: gọi NeBossTick
    @{ Rva = 0x3E6242; Old = (Hex '33 D2 48 8B CB'); New = (Jmp 0x3E6242 $cave['UpdHook'] 0xE9) },
    # ModFunc.perform: id 0x3D / 0x3E
    @{ Rva = 0x3EA09F; Old = (Hex '83 FF 3C 0F 8E E5 0C 00 00'); New = ((Jmp 0x3EA09F $cave['PerformHook'] 0xE9) + (Nops 4)) },
    # Tab BOSS: thêm 2 nút sau Focus BOSS
    @{ Rva = 0x3EB036; Old = (Hex '41 B8 34 00 00 00 48 8B D7 E9 73 0E 00 00'); New = ((Jmp 0x3EB036 $cave['TabCave'] 0xE9) + (Nops 9)) },
    # ModFunc.Chat: lệnh neboss / tsboss
    @{ Rva = 0x3D56D4; Old = (Hex '33 D2 C7 44 24 48 00 00 00 00 48 8B CB'); New = ((Jmp 0x3D56D4 $cave['ChatHook'] 0xE9) + (Nops 8)) },
    # PickMobController.Update: tsBoss vào thẳng nhánh tàn sát người
    @{ Rva = 0x4CDE36; Old = (Hex '44 38 61 10 0F 85 59 05 00 00'); New = ((Jmp 0x4CDE36 $cave['PickCave'] 0xE9) + (Nops 5)) },
    # Lọc mục tiêu tàn sát người (trong Update và IsCharTanSat) đổi sang CanTs
    @{ Rva = 0x4CE046; Old = (Hex 'E8 75 A8 DE FF'); New = (Jmp 0x4CE046 $cave['CanTs'] 0xE8) },
    @{ Rva = 0x4CCEA4; Old = (Hex 'E9 17 BA DE FF'); New = (Jmp 0x4CCEA4 $cave['CanTs'] 0xE9) },
    # ModFunc.OpenMenu: bỏ nút "Hướng Dẫn Xài Mod" (nhảy qua khối tạo nút, tới 0x3DBB8E)
    @{ Rva = 0x3DBB59; Old = (Hex '48 8B'); New = (Hex 'EB 33') }
)

$changed = 0
foreach ($p in $hooks) {
    $off = $p.Rva - 0x1800
    if (Same $b $off $p.New) { continue }
    if (-not (Same $b $off $p.Old)) { Write-Host ('Byte tai RVA 0x{0:X} khong dung (khong phai ban goc, cung khong phai ban da sua). Dung lai.' -f $p.Rva); exit 1 }
}
foreach ($p in $new) { if (-not (Same $b $p.Off $p.New)) { $changed++ } }
foreach ($p in $hooks) { if (-not (Same $b ($p.Rva - 0x1800) $p.New)) { $changed++ } }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }

if (-not (Test-Path "$Dll.truoc-ne-tan-sat-boss")) { Copy-Item $Dll "$Dll.truoc-ne-tan-sat-boss" }
foreach ($p in $new) { $x = [byte[]]$p.New; [Array]::Copy($x, 0, $b, $p.Off, $x.Length) }
foreach ($p in $hooks) { $x = [byte[]]$p.New; [Array]::Copy($x, 0, $b, $p.Rva - 0x1800, $x.Length) }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
