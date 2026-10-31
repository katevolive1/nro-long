# Thái Dương Hạ San: chỉ bị choáng (không đi được), màn hình vẫn nhìn bình thường.
# Gốc: Controller.onMessage (Game1 0x2F491A, Game2 0x32F49A) `mov byte [GameScr+168h],1` bật cờ isFreez khi mình trúng chiêu
#   -> GameScr.paint (Game1 0x3775FC..0x3777DE) chớp trắng toàn màn và ở khung chớp `ret` sớm không vẽ map.
#   Lệnh ngay sau đó bật cờ choáng của Char.myCharz() (+330h, thời gian +338h) - phần này giữ nguyên.
# Bản 4 (31/10/2026): trả GameScr.paint về byte gốc (bỏ bản 1/2/3 đã sửa đoạn vẽ) và NOP 2 lệnh bật cờ isFreez.
#   Cờ +169h (chớp khi gọi rồng thần) không đổi.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-bo-man-trang.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$nop5 = '0F 1F 44 00 00'
$nop6 = '66 0F 1F 44 00 00'
$nop7 = '0F 1F 80 00 00 00 00'
# Olds: byte của các bản trước (hoặc byte gốc của chỗ mới sửa)
$patches = @(
    # Trả đoạn vẽ về gốc
    @{ Off = 0x377670 - 0x1800; Olds = @('BA 00 00 00 00'); New = 'BA FF FF FF 00' },
    @{ Off = 0x377678 - 0x1800; Olds = @($nop5); New = 'E8 B3 B6 05 00' },
    @{ Off = 0x3776C1 - 0x1800; Olds = @($nop5); New = 'E8 AA AB 05 00' },
    @{ Off = 0x37765E - 0x1800; Olds = @('E9 1E 01 00 00 90', $nop6); New = '0F 85 1D 01 00 00' },
    @{ Off = 0x3777CA - 0x1800; Olds = @($nop6, 'E9 95 FE FF FF 90'); New = '0F 84 94 FE FF FF' },
    @{ Off = 0x3776CE - 0x1800; Olds = @('0F 8E 1C FF FF FF'); New = '0F 8E C3 FE FF FF' },
    # Không bật cờ isFreez
    @{ Off = 0x2F491A - 0x1800; Olds = @('C6 83 68 01 00 00 01'); New = $nop7 },
    @{ Off = 0x32F49A - 0x1800; Olds = @('C6 83 68 01 00 00 01'); New = $nop7 }
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
if (-not (Test-Path "$Dll.truoc-bo-man-trang")) { Copy-Item $Dll "$Dll.truoc-bo-man-trang" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
