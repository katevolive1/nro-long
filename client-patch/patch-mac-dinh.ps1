# Đặt mặc định các ô tích trong menu mod (ModFunc) khi mở game:
#   Hiện ID Item/NPC, Cập Nhật Khu, Kẻ đường tới BOSS (chỉ Game1): luôn bật lúc mở game (client không lưu các mục này).
#   Gõ Tiếng Việt: luôn tắt lúc mở game (bản cũ của script bật, chạy lại thì tắt về như gốc).
#   Tự Động Hồi Sinh: bật nếu chưa từng tắt (đọc RMS "autoWakeUp", chưa có thì coi là bật).
# Các mục khác đã sẵn đúng: FPS Cao, Nhân Vật Trong Khu, Hành Trang Lưới bật; còn lại tắt.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-mac-dinh.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'   # lỗi ghi file (vd game đang mở) thì dừng, không báo "Da sua"

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$b = [IO.File]::ReadAllBytes($Dll)
$sections = @()
# Game1, Game2 (ModFunc của Game2 lệch đúng 0x1B72A0 so với Game1). Offset file = RVA - 0x1800.
foreach ($g in @(@{ D = 0; Cave = 0xA52D90; Line = $true }, @{ D = 0x1B72A0; Cave = 0xA52DB0; Line = $false })) {
    $d = $g.D
    # 1. ModFunc..cctor: isVietnamese (static +17h) giữ = 0 (gốc là 0; bản script cũ đã đổi thành 1 thì đổi lại)
    $sections += @{ Off = 0x3E7AEF + $d - 0x1800; Old = (Hex 'C6 41 17 01'); New = (Hex 'C6 41 17 00') }
    # 2. ModFunc..cctor: rcx vẫn là vùng static, bỏ 2 lệnh nạp lại rcx để có chỗ ghi isShowID (static +0EEh) = 1
    $o = 0x3E7AF3 + $d - 0x1800
    $sections += @{ Off = $o; Old = [byte[]]($b[$o..($o + 6)] + (Hex '48 8B 88 B8 00 00 00 C6 41 18 00'));
        New = (Hex 'C6 41 18 00 C6 81 EE 00 00 00 01 0F 1F 80 00 00 00 00') }
    # 3. ModFunc.LoadGame: autoWakeUp = loadRMSInt("autoWakeUp") == 1  ->  != 0 (chưa lưu = -1 = bật)
    $sections += @{ Off = 0x3DA64D + $d - 0x1800; Old = (Hex '83 F8 01 0F 94 C0'); New = (Hex '83 F8 00 0F 95 C0') }
    # 4. ModFunc..ctor: mov byte [rdi+0D0h],1 -> jmp cave; cave ghi thêm isUpdateZones (+0D2h) = 1
    #    (Game1 ghi thêm lineToBoss +0C0h = 1, cave Game1 dài 26 byte, Game2 giữ 19 byte) rồi quay về
    $site = 0x3E90EF + $d
    $jmp = [BitConverter]::GetBytes([int]($g.Cave - ($site + 5)))
    $sections += @{ Off = $site - 0x1800; Old = (Hex 'C6 87 D0 00 00 00 01'); New = [byte[]]((Hex 'E9') + $jmp + (Hex '90 90')) }
    $back19 = [BitConverter]::GetBytes([int](($site + 7) - ($g.Cave + 19)))
    $cave19 = [byte[]]((Hex 'C6 87 D0 00 00 00 01 C6 87 D2 00 00 00 01 E9') + $back19)
    if ($g.Line) {
        $back26 = [BitConverter]::GetBytes([int](($site + 7) - ($g.Cave + 26)))
        $sections += @{ Off = $g.Cave - 0x1800; Old = [byte[]](,0 * 26); Old2 = [byte[]]($cave19 + [byte[]](,0 * 7));
            New = [byte[]]((Hex 'C6 87 D0 00 00 00 01 C6 87 D2 00 00 00 01 C6 87 C0 00 00 00 01 E9') + $back26) }
    } else {
        $sections += @{ Off = $g.Cave - 0x1800; Old = [byte[]](,0 * 19); New = $cave19 }
    }
}

$changed = 0
foreach ($p in $sections) {
    if (Same $b $p.Off $p.New) { continue }
    if (-not (Same $b $p.Off $p.Old) -and -not ($p.Old2 -and (Same $b $p.Off $p.Old2))) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $p.Off); exit 1 }
}
foreach ($p in $sections) {
    if (Same $b $p.Off $p.New) { continue }
    [Array]::Copy($p.New, 0, $b, $p.Off, $p.New.Length); $changed++
}
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-mac-dinh")) { Copy-Item $Dll "$Dll.truoc-mac-dinh" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
