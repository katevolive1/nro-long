# Phím Q (chỉ Game1): bay tới boss gần nhất trong map đang đứng và focus vào boss đó.
#   Boss lọc giống ModFunc.AutoFocusBoss: charID < 0, cTypePk == 5, tên không bắt đầu bằng "Đ". Gần nhất theo |dx| + |dy|.
#   Bay bằng ModFunc.MoveTo(boss.cx, boss.cy) như các phím mod khác (đổi vị trí + Service.charMove).
# Bảng phím ModFunc.UpdateKey (Game1 0x3E4B00): switch (key - 'a'), bảng nhảy RVA 0x3E5098, mục 'q' (16) trỏ về default 0x3E5083.
# Mã mới đặt ở thân Game2.ModFunc.UpdateKey (RVA 0x59BDA0, 0x600 byte, chỉ Game2.GameScr.updateKey gọi nên không chạy).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-phim-q.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$b = [IO.File]::ReadAllBytes($Dll)
$code = Hex '48 8D 0D 29 94 70 00 E8 84 D2 AF FF 48 8D 0D AD B8 70 00 E8 78 D2 AF FF 48 8B 0D 11 94 70 00 83 B9 E0 00 00 00 00 75 05 E8 13 D5 AF FF 31 C9 E8 DC D3 D1 FF 48 85 C0 0F 84 32 01 00 00 48 89 44 24 48 48 8D 0D A7 E8 70 00 E8 42 D2 AF FF 31 FF 48 C7 44 24 50 00 00 00 00 C7 44 24 58 FF FF FF 7F 48 8B 05 58 B8 70 00 83 B8 E0 00 00 00 00 75 0F 48 89 C1 E8 C7 D4 AF FF 48 8B 05 40 B8 70 00 48 8B 80 B8 00 00 00 48 8B 88 F0 00 00 00 48 85 C9 0F 84 AA 00 00 00 48 89 4C 24 20 31 D2 E8 1D 2F C2 FF 39 C7 0F 8D 96 00 00 00 48 8B 4C 24 20 89 FA 45 31 C0 E8 56 2C C2 FF FF C7 48 85 C0 74 A0 83 B8 90 00 00 00 00 7D 97 80 B8 95 02 00 00 05 75 8E 48 8B 88 90 01 00 00 48 85 C9 74 82 48 89 44 24 28 48 8B 15 05 E8 70 00 45 31 C0 E8 6D 2C 1F 00 84 C0 0F 85 66 FF FF FF 48 8B 44 24 28 48 8B 4C 24 48 8B 50 6C 2B 51 6C 41 89 D0 F7 DA 41 0F 4C D0 44 8B 40 70 44 2B 41 70 45 89 C1 41 F7 D8 45 0F 4C C1 44 01 C2 3B 54 24 58 0F 8D 2E FF FF FF 89 54 24 58 48 89 44 24 50 E9 20 FF FF FF 48 8B 54 24 50 48 85 D2 74 24 48 8B 4C 24 48 45 31 C0 E8 E8 1E D1 FF 48 8B 44 24 50 8B 50 6C 44 8B 40 70 45 31 C9 48 89 D9 E8 C1 F6 E3 FF E9 BF 90 E4 FF'
$sections = @(
    # Mã phím Q đè lên đầu thân Game2.ModFunc.UpdateKey (kiểm tra 16 byte đầu hàm gốc)
    @{ Off = 0x59BDA0 - 0x1800; Old = (Hex '48 89 5C 24 08 57 48 83 EC 30 80 3D 1D B1 75 00'); New = $code },
    # Bảng nhảy mục 'q': 0x3E5083 (không làm gì) -> 0x59BDA0
    @{ Off = 0x3E50D8 - 0x1800; Old = (Hex '83 50 3E 00'); New = (Hex 'A0 BD 59 00') }
)

$changed = 0
foreach ($p in $sections) {
    if (Same $b $p.Off $p.New) { continue }
    if (-not (Same $b $p.Off $p.Old)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $p.Off); exit 1 }
}
foreach ($p in $sections) {
    if (Same $b $p.Off $p.New) { continue }
    [Array]::Copy($p.New, 0, $b, $p.Off, $p.New.Length); $changed++
}
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-phim-q")) { Copy-Item $Dll "$Dll.truoc-phim-q" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
