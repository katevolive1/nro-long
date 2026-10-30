# Auto Item (chỉ Game1):
#  1. ModFunc.Update (Game1 0x3E61C0) gọi UseItemAuto chỉ khi đã qua 1000ms (cmp rax,3E8h tại 0x3E6799), cùng lúc với
#     Service.openUIZone ("Cập Nhật Khu"). Đổi: UseItemAuto mỗi 100ms; openUIZone chỉ khi (now % 1000) < 100 (~1 lần/giây).
#     Hook jmp tại 0x3E678F, mã ở cave, xong nhảy về 0x3E67D5.
#  2. (Bỏ 31/10/2026) Phím P dừng auto: mod đã có sẵn, UseItemAuto dừng khi click chuột (GameCanvas.isPointerClick +49h
#     và isPointerJustRelease +4Ah). Bản trước trỏ mục 'p' của bảng nhảy ModFunc.UpdateKey (0x3E5098) sang 0x59DFE0;
#     script này trả mục 'p' về default 0x3E5083 (mã ở 0x59DFE0 để lại, không ai gọi).
#  3. Chuỗi " vào Auto Item" (thông báo khi thêm item) trong global-metadata.dat -> " (click:dừng)" (tối đa 15 byte như
#     chuỗi gốc; bản trước là " (P: dừng)").
#  4. UseItemAuto gửi Service.useItem(0, where=1, index=FindItemIndex(id), template=-1): server dùng món ở ô đó, dữ liệu client
#     chậm thì có thể dùng nhầm món khác. Đổi (hook 0x3E7022): còn <= 1 cái thì dừng auto (nhảy 0x3E6E5B: xóa danh sách +
#     "Đã dừng auto sử dụng Item"); không thì gửi where=9, index=-1, template=id để server tìm theo mã (UseItem.doItem,
#     server cũng từ chối where=9 khi còn <= 1 cái).
# Cave: thân Game2.ModFunc.UseItemAuto (RVA 0x59DF60, Game2 không chạy lúc runtime).
# Bản cũ của script này chỉ đổi Task.Delay 0xC8 -> 0x64 (không phải chỗ làm chậm); nếu đã áp thì trả lại 0xC8.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-auto-item.ps1 "F:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }
$T = 0x1800   # offset file = RVA - 0x1800

# Assembler nhỏ: phần tử là mảng byte, @('r32', đích RVA hoặc nhãn), @('r8', nhãn) hoặc @('lbl', nhãn)
function Build([long]$org, $items) {
    $labels = @{}; $pc = $org
    foreach ($it in $items) {
        if ($it -is [byte[]]) { $pc += $it.Length }
        elseif ($it[0] -eq 'lbl') { $labels[$it[1]] = $pc }
        elseif ($it[0] -eq 'r32') { $pc += 4 } else { $pc += 1 }
    }
    $out = New-Object System.Collections.Generic.List[byte]; $pc = $org
    foreach ($it in $items) {
        if ($it -is [byte[]]) { $out.AddRange($it); $pc += $it.Length }
        elseif ($it[0] -eq 'lbl') { }
        elseif ($it[0] -eq 'r32') {
            $t = $it[1]; if ($t -is [string]) { $t = $labels[$t] }
            $out.AddRange([BitConverter]::GetBytes([int]($t - ($pc + 4)))); $pc += 4
        } else {
            $d = $labels[$it[1]] - ($pc + 1)
            if ($d -lt -128 -or $d -gt 127) { throw "rel8 xa: $($it[1])" }
            $out.Add([byte]($d -band 0xFF)); $pc += 1
        }
    }
    return ,$out.ToArray()
}

$ms = 50      # khoảng cách giữa 2 lượt AutoItem (ms), tối đa 127
$cave = 0x59DF60
$useItemAuto = 0x3E6CC0; $serviceGI = 0x48C050; $openUIZone = 0x48FC10; $back = 0x3E67D5
$initLazy = 0x99030; $addInfo = 0x3AC9D0; $retTrue = 0x3E5076; $default = 0x3E5083
$modFuncTI = 0xCAA740; $gameScrTI = 0xCA7660; $strDung = 0xCAABE0

# 1. Hẹn giờ trong ModFunc.Update (rbx = this, rbp = now, sil = 0)
$codeA = Build $cave @(
    (Hex '48 8B C5'), (Hex '48 2B 83 D8 00 00 00'), ([byte[]](0x48, 0x83, 0xF8, $ms)),   # rax = now - last; < $ms thì bỏ qua
    (Hex '0F 8C'), @('r32', 'done'),
    (Hex '33 D2'), (Hex '48 8B CB'), (Hex 'E8'), @('r32', $useItemAuto),
    (Hex '40 38 B3 D2 00 00 00'), (Hex '74'), @('r8', 'set'),                 # "Cập Nhật Khu" tắt
    (Hex '48 8B C5'), (Hex '33 D2'), (Hex 'B9 E8 03 00 00'), (Hex '48 F7 F1'),  # rdx = now % 1000
    ([byte[]](0x48, 0x83, 0xFA, $ms)), (Hex '73'), @('r8', 'set'),
    (Hex '33 C9'), (Hex 'E8'), @('r32', $serviceGI), (Hex '48 85 C0'), (Hex '74'), @('r8', 'set'),
    (Hex '33 D2'), (Hex '48 8B C8'), (Hex 'E8'), @('r32', $openUIZone),
    @('lbl', 'set'), (Hex '48 89 AB D8 00 00 00'),
    @('lbl', 'done'), (Hex 'E9'), @('r32', $back)
)
# 2. Phím P (rbx = this ModFunc, kết thúc ở đoạn trả true của UpdateKey)
$caveP = $cave + 0x80
$codeP = Build $caveP @(
    (Hex '48 8D 0D'), @('r32', $modFuncTI), (Hex 'E8'), @('r32', $initLazy),
    (Hex '48 8D 0D'), @('r32', $gameScrTI), (Hex 'E8'), @('r32', $initLazy),
    (Hex '48 8D 0D'), @('r32', $strDung), (Hex 'E8'), @('r32', $initLazy),
    (Hex '48 8B 05'), @('r32', $modFuncTI), (Hex '48 8B 80 B8 00 00 00'),
    (Hex '80 B8 98 00 00 00 00'), (Hex '0F 84'), @('r32', $default),           # auto không chạy: phím p như cũ
    (Hex 'C6 80 98 00 00 00 00'),                                               # startAutoItem = false
    (Hex '48 8B 4B 70'), (Hex '48 85 C9'), (Hex '74'), @('r8', 'msg'),
    (Hex 'FF 41 1C'), (Hex 'C7 41 18 00 00 00 00'),                             # xóa danh sách (như UseItemAuto)
    @('lbl', 'msg'),
    (Hex '48 8B 05'), @('r32', $gameScrTI), (Hex '48 8B 80 B8 00 00 00'), (Hex '48 8B 88 C8 02 00 00'),
    (Hex '48 85 C9'), (Hex '74'), @('r8', 'out'),
    (Hex '45 33 C9'), (Hex '45 33 C0'), (Hex '48 8B 15'), @('r32', $strDung), (Hex 'E8'), @('r32', $addInfo),
    @('lbl', 'out'), (Hex 'E9'), @('r32', $retTrue)
)
# 4. Dùng từng món trong UseItemAuto (rdi = món trong danh sách, [rdi+18h]+10h = mã; r15 = this; r14 = Service; r12 = 0)
$caveC = $cave + 0x1A0
$codeC = Build $caveC @(
    (Hex '48 8B 4F 18'), (Hex '48 85 C9'), (Hex '0F 84'), @('r32', 0x3E71FF),
    (Hex '0F BF 51 10'), (Hex '45 33 C0'), (Hex '49 8B CF'), (Hex 'E8'), @('r32', 0x3D8B00),   # FindItemIndex(mã)
    (Hex '3C FF'), (Hex '0F 84'), @('r32', 0x3E7063),                                         # không có: bỏ qua món này
    (Hex '0F BE C0'), (Hex '89 44 24 28'),
    (Hex '33 C9'), (Hex 'E8'), @('r32', 0x2B91B0),                                            # Char.myCharz()
    (Hex '48 85 C0'), (Hex '74'), @('r8', 'send'),
    (Hex '48 8B 80 50 02 00 00'), (Hex '48 85 C0'), (Hex '74'), @('r8', 'send'),              # arrItemBag
    (Hex '48 63 4C 24 28'), (Hex '3B 48 18'), (Hex '73'), @('r8', 'send'),
    (Hex '48 8B 44 C8 20'), (Hex '48 85 C0'), (Hex '74'), @('r8', 'send'),
    (Hex '83 78 38 01'), (Hex '0F 8E'), @('r32', 0x3E6E5B),                                   # quantity <= 1: dừng auto
    @('lbl', 'send'),
    (Hex '48 8B 4F 18'), (Hex '0F BF 41 10'), (Hex '66 89 44 24 20'), (Hex '4C 89 64 24 28'), # template = mã
    (Hex '4D 85 F6'), (Hex '0F 84'), @('r32', 0x3E71FA),
    (Hex '41 B1 FF'), (Hex '41 B0 09'), (Hex 'E9'), @('r32', 0x3E7059)                        # index -1, where 9 -> useItem
)
if ($codeA.Length -gt 0x80 -or $codeP.Length -gt 0x120 -or $codeC.Length -gt 0x100) { throw 'Ma qua dai' }
$hook = [byte[]](@(0xE9) + [BitConverter]::GetBytes([int]($cave - (0x3E678F + 5))))
$hookC = [byte[]](@(0xE9) + [BitConverter]::GetBytes([int]($caveC - (0x3E7022 + 5))))

$sections = @(
    @{ Off = $cave - $T;  Old = $null; New = $codeA },
    @{ Off = $caveC - $T; Old = $null; New = $codeC },
    @{ Off = 0x3E678F - $T; Old = (Hex '48 8B C5 48 2B 83'); New = $hook },
    # mục 'p': trả về default (bản trước trỏ sang $caveP)
    @{ Off = 0x3E5098 + 4 * 15 - $T; Old = [BitConverter]::GetBytes([int]$caveP); New = [BitConverter]::GetBytes([int]$default) },
    @{ Off = 0x3E7022 - $T; Old = (Hex '48 8B 4F 18 48 85 C9'); New = $hookC }
)

$b = [IO.File]::ReadAllBytes($Dll)
# Cave phải là thân gốc của Game2.ModFunc.UseItemAuto hoặc mã của script này (bản trước)
if (-not ((Same $b ($cave - $T) (Hex '48 89 5C 24 10 48 89 74 24 20')) -or (Same $b ($cave - $T) (Hex '48 8B C5 48 2B 83 D8 00 00 00')))) {
    Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f ($cave - $T)); exit 1
}
$changed = 0
$delayOff = 0x3E7121 - $T
if ($b[$delayOff - 1] -eq 0xB9 -and $b[$delayOff] -eq 0x64) { $b[$delayOff] = 0xC8; $changed++ }
foreach ($p in $sections) {
    if (Same $b $p.Off $p.New) { continue }
    if ($p.Old -ne $null -and -not (Same $b $p.Off $p.Old)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $p.Off); exit 1 }
    [Array]::Copy($p.New, 0, $b, $p.Off, $p.New.Length); $changed++
}

# 3. Chuỗi gợi ý trong global-metadata.dat (bảng string literal metadata v31, như patch-port.ps1)
$meta = Join-Path (Split-Path $Dll) 'DragonBoy_Data\il2cpp_data\Metadata\global-metadata.dat'
$u = [Text.Encoding]::UTF8
$old = $u.GetBytes(' vào Auto Item'); $new = $u.GetBytes(' (click:dừng)'); $prev = $u.GetBytes(' (P: dừng)')
if ($new.Length -gt $old.Length) { throw 'Chuoi moi dai hon chuoi goc' }
$m = [IO.File]::ReadAllBytes($meta)
$tblOff = [BitConverter]::ToInt32($m, 8); $tblSize = [BitConverter]::ToInt32($m, 12); $dataOff = [BitConverter]::ToInt32($m, 16)
$metaChanged = 0; $found = 0
for ($e = $tblOff; $e -lt $tblOff + $tblSize; $e += 8) {
    $len = [BitConverter]::ToInt32($m, $e); $p = $dataOff + [BitConverter]::ToInt32($m, $e + 4)
    if ($len -eq $new.Length -and (Same $m $p $new)) { $found++; continue }
    $isOld = ($len -eq $old.Length -and (Same $m $p $old)); $isPrev = ($len -eq $prev.Length -and (Same $m $p $prev))
    if (-not ($isOld -or $isPrev)) { continue }
    [Array]::Copy($new, 0, $m, $p, $new.Length)
    [Array]::Copy([BitConverter]::GetBytes([int]$new.Length), 0, $m, $e, 4)
    $metaChanged++; $found++
}
if ($found -eq 0) { Write-Host 'Khong tim thay chuoi " vao Auto Item". Dung lai.'; exit 1 }

if ($changed -gt 0) {
    if (-not (Test-Path "$Dll.truoc-auto-item")) { Copy-Item $Dll "$Dll.truoc-auto-item" }
    [IO.File]::WriteAllBytes($Dll, $b)
}
if ($metaChanged -gt 0) {
    if (-not (Test-Path "$meta.truoc-auto-item")) { Copy-Item $meta "$meta.truoc-auto-item" }
    [IO.File]::WriteAllBytes($meta, $m)
}
if ($changed -eq 0 -and $metaChanged -eq 0) { Write-Host 'Auto Item: da sua truoc do.' }
else { Write-Host "Auto Item: da sua $changed cho trong DLL, $metaChanged chuoi trong metadata." }
