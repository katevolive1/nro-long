# Danh sách server lấy hẳn từ server gửi (Config.properties), bỏ nút "DragonBoy", "0" và nút trống.
# Gốc: ServerListScreen..cctor bật isMultiSever (static +50h) = 1 (Game1 0x47D222, Game2 0x24AA62: C6 41 50 01).
#   Khi bật, Controller.messageNotLogin (-29 sub 2) nối thẳng ListIP ("DragonBoy:<ip nhập>:<port>:0,0,0") với chuỗi server gửi
#   không có dấu phẩy -> GetServerList ra server "0" lỗi và 2 server không tên. LoadIP cũng đọc ListIP thay vì NRlink2.
# Sửa: isMultiSever = 0 -> client dùng chuỗi server gửi, GetServerList lưu vào NRlink2, lần mở sau LoadIP đọc lại NRlink2.
#   Lần đầu (chưa có NRlink2) client vẫn hỏi IP/PORT như cũ để kết nối, vào được rồi mới nhận danh sách.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-danh-sach-server.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$patches = @(
    @{ Off = 0x47D222 - 0x1800; Old = 'C6 41 50 01'; New = 'C6 41 50 00' },
    @{ Off = 0x24AA62 - 0x1800; Old = 'C6 41 50 01'; New = 'C6 41 50 00' }
)

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($q in $patches) {
    if (-not ((Same $b $q.Off (Hex $q.Old)) -or (Same $b $q.Off (Hex $q.New)))) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $q.Off); exit 1 }
}
$changed = 0
foreach ($q in $patches) { $n = Hex $q.New; if (-not (Same $b $q.Off $n)) { [Array]::Copy($n, 0, $b, $q.Off, $n.Length); $changed++ } }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-danh-sach-server")) { Copy-Item $Dll "$Dll.truoc-danh-sach-server" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
