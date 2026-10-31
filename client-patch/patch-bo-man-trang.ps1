# Bỏ màn trắng khi bị Thái Dương Hạ San (GameScr.isFreez, Controller.onMessage 0x2F491A bật cờ).
# GameScr.paint (Game1) đoạn 0x377664..0x3776C6: setColor(0xFFFFFF) rồi fillRect toàn màn mỗi khung hình khi bộ đếm [GameScr+15Ch] > 50.
# Sửa: NOP lệnh call setColor (0x377678) và call fillRect (0x3776C1); bộ đếm, cờ isFreez và mọi logic khác giữ nguyên.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-bo-man-trang.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$nop = Hex '0F 1F 44 00 00'   # nop dword [rax+rax+0] (5 byte)
$patches = @(
    @{ Off = 0x377678 - 0x1800; Old = (Hex 'E8 B3 B6 05 00'); New = $nop },
    @{ Off = 0x3776C1 - 0x1800; Old = (Hex 'E8 AA AB 05 00'); New = $nop }
)

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($q in $patches) {
    if (-not (Same $b $q.Off $q.New) -and -not (Same $b $q.Off $q.Old)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $q.Off); exit 1 }
}
$changed = 0
foreach ($q in $patches) { if (-not (Same $b $q.Off $q.New)) { [Array]::Copy($q.New, 0, $b, $q.Off, $q.New.Length); $changed++ } }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-bo-man-trang")) { Copy-Item $Dll "$Dll.truoc-bo-man-trang" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
