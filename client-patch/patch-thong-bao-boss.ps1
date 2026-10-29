# Thông báo boss gửi lúc vào game (server thêm "\t" ở đầu câu) chỉ vào danh sách boss của mod, không chạy chữ dưới màn hình.
# GameScr.chatVip (Game1 RVA 0x35F400, runtime dùng Game1): chữ chạy dưới màn hình = đoạn 0x35F468..0x35F567,
# sau đó mới gọi BossCustom.addBoss (tab Thông báo) và ShowBoss.HandleChatVip (khung góc phải). Hai hàm này tự Trim nên "\t" không ảnh hưởng.
# Sửa: 0x35F468 (cmp byte [rdi+2A4h],0) -> jmp cave; cave: chuỗi bắt đầu bằng '\t' thì nhảy tới 0x35F568, không thì làm lệnh gốc rồi quay về.
# Cave ở vùng trống cuối section il2cpp: RVA 0xA52DC8..0xA52DE4.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-thong-bao-boss.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'   # lỗi ghi file (vd game đang mở) thì dừng, không báo "Da sua"

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Rel([long]$from, [long]$to) { return ,[BitConverter]::GetBytes([int]($to - $from)) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$site = 0x35F468; $cave = 0xA52DC8
$caveBytes = [byte[]](
    (Hex '48 85 DB 74 0B') +                        # test rbx,rbx ; je goc
    (Hex '66 83 7B 14 09') +                        # cmp word [rbx+14h],9   (ký tự đầu = '\t')
    (Hex '0F 84') + (Rel ($cave + 16) 0x35F568) +   # je bỏ qua chữ chạy -> addBoss
    (Hex '80 BF A4 02 00 00 00') +                  # goc: cmp byte [rdi+2A4h],0 (lệnh gốc)
    (Hex 'E9') + (Rel ($cave + 28) 0x35F46F))       # jmp về
$patches = @(
    @{ Off = $site - 0x1800; Old = (Hex '80 BF A4 02 00 00 00'); New = [byte[]]((Hex 'E9') + (Rel ($site + 5) $cave) + (Hex '90 90')) },
    @{ Off = $cave - 0x1800; Old = [byte[]](,0 * $caveBytes.Length); New = $caveBytes }
)

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($q in $patches) {
    if (-not (Same $b $q.Off $q.New) -and -not (Same $b $q.Off $q.Old)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $q.Off); exit 1 }
}
$changed = 0
foreach ($q in $patches) { if (-not (Same $b $q.Off $q.New)) { [Array]::Copy($q.New, 0, $b, $q.Off, $q.New.Length); $changed++ } }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-thong-bao-boss")) { Copy-Item $Dll "$Dll.truoc-thong-bao-boss" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
