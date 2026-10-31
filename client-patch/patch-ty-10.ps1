# So duoi 10 ty hien day du co dau cham (2.000.000.000), tu 10 ty tro len moi hien "X Ty" (chi Game1, runtime dung Game1).
# NinjaUtil.getMoneys(double) (Game1 0x3F5280) dung chung cho: chu ten/HP muc tieu (GameScr.paintInfoBar), danh sach nhan vat
#   trong khu (ModFunc.PaintCharInMap), HP/HP toi da giua man hinh (ModFunc.PaintListInfo), va cac khung khac (vang, so luong...).
# Goc: isReadInt = false thi so voi xmm6 = 1e9 (o 0xA53B80): nho hon -> getMoneysPower (0x3F50A0, nhom 3 so bang dau cham),
#   con lai chia 1e9 them chu "Ty". xmm6 con dung lam so chia nen khong doi o hang so, chi doi phep so sanh.
# Sua: 0x3F5383 (comisd xmm6,xmm0; ja 0x3F55C0) -> jmp cave 0x59C100 (than Game2.ModFunc.UpdateKey, khong chay):
#   comisd xmm0,[1e10]; jb 0x3F55C0; jmp 0x3F538D; hang so 1e10 o 0x59C118.
# Cach dung: powershell -ExecutionPolicy Bypass -File patch-ty-10.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$patches = @(
    @{ Off = 0x59C100 - 0x1800; Olds = @('D2 48 8B C8 E8 37 1E CE FF B0 01 48 8B 5C 24 40 48 83 C4 30 5F C3 33 C9 E8 F3 11 CE FF 48 85 C0');
       New = '66 0F 2F 05 10 00 00 00 0F 82 B2 94 E5 FF E9 7A 92 E5 FF CC CC CC CC CC 00 00 00 20 5F A0 02 42' },
    @{ Off = 0x3F5383 - 0x1800; Olds = @('66 0F 2F F0 0F 87 33 02 00 00'); New = 'E9 78 6D 1A 00 90 90 90 90 90' }
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
if (-not (Test-Path "$Dll.truoc-ty-10")) { Copy-Item $Dll "$Dll.truoc-ty-10" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
