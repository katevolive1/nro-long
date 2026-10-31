# So luong do trong ruong khong con bi nhoe (chi Game1, runtime dung Game1).
# Nguyen nhan: Panel.paintBox (Game1 0x42B550, khung luoi "Hien Hanh Trang Luoi" ModFunc.isInventory) ve so luong bang
#   mFont.drawString(g, st, x, y, align, font2) (Game1 0x3CB560, ban 6 doi so) voi font2 = CHINH font chinh (mFont.tahoma_7_yellow, static +0C8h):
#   ban nay ve them 1 lan "bong" font2 lech 1 pixel truoc khi ve chu -> hai lop chu vang lech nhau nhin nhu bi nhoe.
#   Hanh trang (paintInventory 0x437C70) ve bang ban 5 doi so (Game1 0x3CB1E0) nen ro net.
# Sua: font2 = null (xor r10d,r10d thay mov r10,[rcx+0C8h] o 0x42BBD3, 7 byte) va goi ban 5 doi so (call 0x3CB560 -> 0x3CB1E0 o 0x42BC17).
#   Hai doi so thua o stack ([rsp+30h] = 0, [rsp+38h] = 0) khong anh huong ban 5 doi so.
# Cach dung: powershell -ExecutionPolicy Bypass -File patch-so-luong-ruong.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$patches = @(
    @{ Off = 0x42BBD3 - 0x1800; Olds = @('4C 8B 91 C8 00 00 00'); New = '45 31 D2 90 90 90 90' },
    @{ Off = 0x42BC17 - 0x1800; Olds = @('E8 44 F9 F9 FF'); New = 'E8 C4 F5 F9 FF' }
)

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($q in $patches) {
    $ok = Same $b $q.Off (Hex $q.New)
    foreach ($o in $q.Olds) { if (Same $b $q.Off (Hex $o)) { $ok = $true } }
    if (-not $ok) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $q.Off); exit 1 }
}
$changed = 0
foreach ($q in $patches) { $n = Hex $q.New; if (-not (Same $b $q.Off $n)) { [Array]::Copy($n, 0, $b, $q.Off, $n.Length); $changed++ } }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-so-luong-ruong")) { Copy-Item $Dll "$Dll.truoc-so-luong-ruong" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
