# Giữ khung cửa hàng/hành trang khi server mở form nhập (gói -125, vd bán thỏi vàng "Bạn muốn bán bao nhiêu"), chỉ Game1.
#   Trước: bấm vào ô nhập (nằm ngoài khung) thì Panel.updateKey thấy bấm ra ngoài nên gọi Panel.hide.
#   1. Panel.updateKey (0x4638C0): currentScreen là ClientInput thì return ngay (khung không nhận click, không tự đóng).
#   2. GameCanvas.update (0x3A4FFF): khi panel.isShow thì gốc bỏ qua currentScreen.updateKey; nay nếu currentScreen
#      là ClientInput vẫn gọi (để bấm ô nhập, OK, Đóng được). Phím gõ vốn đã đi thẳng vào currentScreen.keyPress.
# Mã mới đặt trong thân Game2.ModFunc.UpdateKey (không chạy), sau phần của patch-phim-q: 0x59BF20 và 0x59BF60.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-giu-cua-hang.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }
function Jmp([int]$from, [int]$to, [int]$nops) { return ,[byte[]]((Hex 'E9') + [BitConverter]::GetBytes([int]($to - ($from + 5))) + [byte[]](,0x90 * $nops)) }

$b = [IO.File]::ReadAllBytes($Dll)
$caveA = Hex '48 8B 05 D1 B5 70 00 48 8B 80 B8 00 00 00 48 8B 80 C8 00 00 00 48 85 C0 74 0D 48 8B 00 48 3B 05 E4 95 70 00 75 01 C3 57 48 83 EC 40 E9 75 79 EC FF'
$caveB = Hex '80 79 10 00 0F 84 9B 90 E0 FF 49 8B 80 B8 00 00 00 48 8B 80 C8 00 00 00 48 85 C0 0F 84 F8 90 E0 FF 48 8B 00 48 3B 05 9D 95 70 00 0F 85 E8 90 E0 FF E9 B9 90 E0 FF'
$sections = @(
    @{ Off = 0x59BF20 - 0x1800; Old = (Hex 'E8 6B FA FF FF B0 01 48'); New = $caveA },
    @{ Off = 0x59BF60 - 0x1800; Old = (Hex 'E8 FB D8 BE FF 48 85 C0'); New = $caveB },
    # Panel.updateKey: push rdi; sub rsp,40h -> jmp cave A
    @{ Off = 0x4638C0 - 0x1800; Old = (Hex '40 57 48 83 EC 40'); New = (Jmp 0x4638C0 0x59BF20 1) },
    # GameCanvas.update: cmp byte [panel+10h],0; jne 3A5079 -> jmp cave B
    @{ Off = 0x3A4FFF - 0x1800; Old = (Hex '80 79 10 00 75 74'); New = (Jmp 0x3A4FFF 0x59BF60 1) }
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
if (-not (Test-Path "$Dll.truoc-giu-cua-hang")) { Copy-Item $Dll "$Dll.truoc-giu-cua-hang" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
