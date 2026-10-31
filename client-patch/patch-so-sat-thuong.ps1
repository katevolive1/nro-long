# So sat thuong / hoi mau bay len (chu "-123456" / "+123456") co dau cham phan cach hang nghin (chi Game1, runtime dung Game1).
# Goc: chuoi = "-" (hoac "+") + System.Double.ToString(&so) (0x8B95F0, rcx = con tro toi double, rdx = 0) roi GameScr.startFlyText (0x381E00).
# Sua: cave 0x59C120 (than Game2.ModFunc.UpdateKey, khong chay): movsd xmm0,[rcx]; xor edx,edx; jmp NinjaUtil.getMoneysPower (0x3F50A0,
#   nhom 3 so bang dau cham, ham client dung cho HP). 11 lenh call Double.ToString truoc startFlyText (Char.doInjure, Char.update,
#   Controller.onMessage, Controller.messageSubCommand) doi dich sang cave. Cac cho khac dung Double.ToString khong bi anh huong.
# Cach dung: powershell -ExecutionPolicy Bypass -File patch-so-sat-thuong.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }
function CallBytes([long]$rva, [long]$target) { $r = [BitConverter]::GetBytes([int]($target - ($rva + 5))); return ,[byte[]](@(0xE8) + $r) }

$CAVE = 0x59C120
$TOSTRING = 0x8B95F0
$sites = @(0x2B5EF5, 0x2D0103, 0x2D021E, 0x2FFF75, 0x30332A, 0x3033BA, 0x303DEE, 0x303E89, 0x316BB6, 0x316E88, 0x317106)

$jmpRel = [BitConverter]::GetBytes([int](0x3F50A0 - ($CAVE + 11)))
$caveNew = [byte[]](@(0xF2, 0x0F, 0x10, 0x01, 0x31, 0xD2, 0xE9) + $jmpRel)
$patches = @(@{ Off = $CAVE - 0x1800; Old = (Hex '0F 84 0A 02 00 00 33 D2 48 8B C8'); New = $caveNew })
foreach ($s in $sites) { $patches += @{ Off = $s - 0x1800; Old = (CallBytes $s $TOSTRING); New = (CallBytes $s $CAVE) } }

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($q in $patches) {
    if (-not ((Same $b $q.Off $q.New) -or (Same $b $q.Off $q.Old))) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $q.Off); exit 1 }
}
$changed = 0
foreach ($q in $patches) { if (-not (Same $b $q.Off $q.New)) { [Array]::Copy($q.New, 0, $b, $q.Off, $q.New.Length); $changed++ } }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-so-sat-thuong")) { Copy-Item $Dll "$Dll.truoc-so-sat-thuong" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
