# Ctrl+V dán chữ vào ô nhập đang chọn (khung chat...) (chỉ Game1).
#   Main.checkInput (Game1 0x3BE830): phím nhấn -> Event.keyCode -> MyKeyMap.map -> ebx -> GameCanvas.keyPressedz (0x3BED19).
#   Hook tại 0x3BECE1 (mov rax,[GameMidlet_TypeInfo], 7 byte): ebx = 'v'/'V' và đang giữ Ctrl (KeyCode 306/305,
#   Input.GetKeyInt 0xA27F40) thì lấy clipboard bằng il2cpp_resolve_icall("UnityEngine.GUIUtility::get_systemCopyBuffer")
#   (hàm C# bị strip nhưng UnityPlayer vẫn đăng ký icall), rồi gọi TField.keyPressed (0x4D4940) cho từng ký tự >= 0x20
#   vào TField.currentTField (static +88h) nếu isFocus (+10h). Xong nhảy 0x3BED1E (bỏ keyPressedz 'v').
# Cave: thân Game2.Main.checkInput (RVA 0x5758C0, 0x6D0 byte, Game2 không chạy lúc runtime).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-dan-chu.ps1 "F:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }
$T = 0x1800   # offset file = RVA - 0x1800 (section il2cpp)

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

# RVA của hàm xuất il2cpp_resolve_icall (đọc bảng export PE32+)
function ExportRva([byte[]]$b, [string]$name) {
    $pe = [BitConverter]::ToInt32($b, 0x3C); $nsec = [BitConverter]::ToUInt16($b, $pe + 6)
    $optSize = [BitConverter]::ToUInt16($b, $pe + 20); $opt = $pe + 24; $secTbl = $opt + $optSize
    function ToOff([long]$rva) {
        for ($i = 0; $i -lt $nsec; $i++) {
            $s = $secTbl + 40 * $i
            $va = [BitConverter]::ToUInt32($b, $s + 12); $vs = [BitConverter]::ToUInt32($b, $s + 8); $raw = [BitConverter]::ToUInt32($b, $s + 20)
            if ($rva -ge $va -and $rva -lt $va + [Math]::Max($vs, [BitConverter]::ToUInt32($b, $s + 16))) { return $rva - $va + $raw }
        }
        throw 'RVA ngoai section'
    }
    $exp = ToOff ([BitConverter]::ToUInt32($b, $opt + 0x70))
    $n = [BitConverter]::ToUInt32($b, $exp + 24)
    $funcs = ToOff ([BitConverter]::ToUInt32($b, $exp + 28)); $names = ToOff ([BitConverter]::ToUInt32($b, $exp + 32)); $ords = ToOff ([BitConverter]::ToUInt32($b, $exp + 36))
    $want = [Text.Encoding]::ASCII.GetBytes($name + [char]0)
    for ($i = 0; $i -lt $n; $i++) {
        $p = ToOff ([BitConverter]::ToUInt32($b, $names + 4 * $i))
        if (Same $b $p $want) { return [BitConverter]::ToUInt32($b, $funcs + 4 * [BitConverter]::ToUInt16($b, $ords + 2 * $i)) }
    }
    throw "Khong tim thay export $name"
}

$b = [IO.File]::ReadAllBytes($Dll)
$resolve = ExportRva $b 'il2cpp_resolve_icall'

$cave = 0x5758C0
$site = 0x3BECE1; $cont = 0x3BECE8; $skip = 0x3BED1E
$gameMidletTI = 0xCA7598; $tfieldTI = 0xC96338
$getKeyInt = 0xA27F40; $keyPressed = 0x4D4940; $initLazy = 0x99030; $classInit = 0x992E0

$code = Build $cave @(
    (Hex '83 FB 76'), (Hex '74'), @('r8', 'chk'),                       # 'v'
    (Hex '83 FB 56'), (Hex '74'), @('r8', 'chk'),                       # 'V'
    @('lbl', 'orig'),                                                   # lệnh gốc rồi về 0x3BECE8
    (Hex '48 8B 05'), @('r32', $gameMidletTI), (Hex 'E9'), @('r32', $cont),
    @('lbl', 'chk'),
    (Hex 'B9 32 01 00 00'), (Hex '33 D2'), (Hex 'E8'), @('r32', $getKeyInt), (Hex '84 C0'), (Hex '75'), @('r8', 'paste'),   # LeftControl
    (Hex 'B9 31 01 00 00'), (Hex '33 D2'), (Hex 'E8'), @('r32', $getKeyInt), (Hex '84 C0'), (Hex '74'), @('r8', 'orig'),    # RightControl
    @('lbl', 'paste'),
    (Hex '53'), (Hex '56'), (Hex '57'), (Hex '48 83 EC 28'),
    (Hex '48 8D 0D'), @('r32', $tfieldTI), (Hex 'E8'), @('r32', $initLazy),
    (Hex '48 8B 0D'), @('r32', $tfieldTI), (Hex '83 B9 E0 00 00 00 00'), (Hex '75'), @('r8', 'ok1'),
    (Hex 'E8'), @('r32', $classInit), (Hex '48 8B 0D'), @('r32', $tfieldTI),
    @('lbl', 'ok1'),
    (Hex '48 8B 81 B8 00 00 00'), (Hex '48 8B B0 88 00 00 00'),          # rsi = TField.currentTField
    (Hex '48 85 F6'), (Hex '74'), @('r8', 'out'),
    (Hex '80 7E 10 00'), (Hex '74'), @('r8', 'out'),                    # isFocus
    (Hex '48 8D 0D'), @('r32', 'str'), (Hex 'E8'), @('r32', $resolve),  # il2cpp_resolve_icall
    (Hex '48 85 C0'), (Hex '74'), @('r8', 'out'),
    (Hex 'FF D0'), (Hex '48 85 C0'), (Hex '74'), @('r8', 'out'),        # rax = clipboard (Il2CppString)
    (Hex '48 8B F8'), (Hex '33 DB'),
    @('lbl', 'loop'),
    (Hex '3B 5F 10'), (Hex '7D'), @('r8', 'out'),                       # i < length
    (Hex '0F B7 54 5F 14'), (Hex '83 FA 20'), (Hex '72'), @('r8', 'next'),
    (Hex '48 8B CE'), (Hex '45 33 C0'), (Hex 'E8'), @('r32', $keyPressed),
    @('lbl', 'next'), (Hex 'FF C3'), (Hex 'EB'), @('r8', 'loop'),
    @('lbl', 'out'),
    (Hex '48 83 C4 28'), (Hex '5F'), (Hex '5E'), (Hex '5B'), (Hex 'E9'), @('r32', $skip),
    @('lbl', 'str'), ([Text.Encoding]::ASCII.GetBytes("UnityEngine.GUIUtility::get_systemCopyBuffer" + [char]0))
)
if ($code.Length -gt 0x200) { throw 'Ma qua dai' }
$hook = [byte[]](@(0xE9) + [BitConverter]::GetBytes([int]($cave - ($site + 5))) + @(0x90, 0x90))

$sections = @(
    @{ Off = $cave - $T; Old = (Hex '40 53 48 83 EC 60 80 3D'); New = $code },
    @{ Off = $site - $T; Old = (Hex '48 8B 05 B0 88 8E 00'); New = $hook }
)
$changed = 0
foreach ($p in $sections) {
    if (Same $b $p.Off $p.New) { continue }
    if (-not (Same $b $p.Off $p.Old)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $p.Off); exit 1 }
    [Array]::Copy($p.New, 0, $b, $p.Off, $p.New.Length); $changed++
}
if ($changed -eq 0) { Write-Host 'Dan chu: da sua truoc do.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-dan-chu")) { Copy-Item $Dll "$Dll.truoc-dan-chu" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Dan chu: da sua $changed cho (il2cpp_resolve_icall RVA 0x$('{0:X}' -f $resolve))."
