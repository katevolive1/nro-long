# Rương/hành trang trên 127 ô (chỉ Game1): gói -30 sub 0 lúc đăng nhập (Controller.messageSubCommand, Game1 0x313EB0)
#   đọc số ô hành trang/rương bằng readByte rồi movsx (có dấu) -> 128..255 thành số âm, new Item[âm] lỗi khi vào game.
#   Đổi movsx edx,al (0F BE D0) thành movzx edx,al (0F B6 D0) tại RVA 0x31506C (hành trang) và 0x315746 (rương).
#   Gói -36/-35 trong Controller.onMessage đã đọc không dấu (movzx) sẵn.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-o-ruong.ps1 "F:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

$offs = @((0x31506C - 0x1800), (0x315746 - 0x1800))
$b = [IO.File]::ReadAllBytes($Dll)
$changed = 0
foreach ($o in $offs) {
    if ($b[$o] -eq 0x0F -and $b[$o + 1] -eq 0xB6 -and $b[$o + 2] -eq 0xD0) { continue }
    if (-not ($b[$o] -eq 0x0F -and $b[$o + 1] -eq 0xBE -and $b[$o + 2] -eq 0xD0)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $o); exit 1 }
    $b[$o + 1] = 0xB6
    $changed++
}
if ($changed -eq 0) { Write-Host 'O ruong: da sua truoc do.'; exit 0 }
Copy-Item $Dll "$Dll.truoc-o-ruong" -Force
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "O ruong: da sua $changed cho."
