# Tự đánh (lệnh chat `ak`) vẫn đánh khi đang mở hành trang / khung khác.
# Gốc: ModFunc.AutoAttack (Game1 0x3D3B30) bỏ qua khi Skill.paintCanNotUseSkill (+50h) của myskill đang bật (0x3D3C39).
#   Cờ này chỉ được tắt trong Skill.paint (0x498F38: now - lastTimeUseThisSkill(+30h) >= coolDown(+28h)), mà Skill.paint
#   chỉ chạy từ GameScr.paintSelectedSkill - hàm này không vẽ khi đang mở khung (GameCanvas+108h, ChatPopup...).
#   => đánh 1 đòn xong cờ bật mãi, tự đánh dừng tới khi đóng khung.
# Sửa: hook 0x3D3C39 -> cave 0x58AE50 (thân Game2.ModFunc.AutoAttack, chỉ Game2.ModFunc.Update gọi nên không chạy):
#   cờ đang bật thì tự kiểm tra hết hồi chiêu giống Skill.paint, hết thì tắt cờ và đánh tiếp, chưa hết thì bỏ qua như cũ.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-ak-hanh-trang.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }
function Rel([long]$from, [long]$to) { return (([BitConverter]::GetBytes([int]($to - $from))) | ForEach-Object { $_.ToString('X2') }) -join ' ' }

$hook = 0x3D3C39; $cave = 0x58AE50
$ok = 0x3D3C43          # tiếp tục AutoAttack (đã qua kiểm tra cờ)
$skip = 0x3D3DEF        # thoát AutoAttack
$now = 0x402BA0         # mSystem.currentTimeMillis

$caveCode = @(
    '80 78 50 00',                              # cmp byte [rax+50h],0   (rax = myskill)
    '74 1F',                                    # je ok
    '48 89 C6',                                 # mov rsi,rax            (rsi đã lưu ở đầu hàm)
    '33 C9',                                    # xor ecx,ecx
    ('E8 ' + (Rel ($cave + 0x10) $now)),        # call currentTimeMillis
    '48 2B 46 30',                              # sub rax,[rsi+30h]      lastTimeUseThisSkill
    '48 63 4E 28',                              # movsxd rcx,dword [rsi+28h]  coolDown
    '48 3B C1',                                 # cmp rax,rcx
    ('0F 8C ' + (Rel ($cave + 0x21) $skip)),    # jl skip
    'C6 46 50 00',                              # mov byte [rsi+50h],0
    ('E9 ' + (Rel ($cave + 0x2A) $ok))          # ok: jmp 0x3D3C43
) -join ' '

$patches = @(
    @{ Off = $cave - 0x1800; Old = '48 89 5C 24 18 57 48 83 EC 20 80 3D 79 C0 76 00 00 48 8B F9 75 37 48 8D 0D 8B A3 71 00 E8 BE E1 B0 FF 48 8D 0D 0F C8 71 00 E8'; New = $caveCode },
    @{ Off = $hook - 0x1800; Old = '80 78 50 00 0F 85 AC 01 00 00'; New = ('E9 ' + (Rel ($hook + 5) $cave) + ' 0F 1F 44 00 00') }
)

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($q in $patches) {
    if ((Hex $q.Old).Length -ne (Hex $q.New).Length) { Write-Host 'Do dai ma khong khop.'; exit 1 }
    if (-not ((Same $b $q.Off (Hex $q.Old)) -or (Same $b $q.Off (Hex $q.New)))) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $q.Off); exit 1 }
}
$changed = 0
foreach ($q in $patches) { $n = Hex $q.New; if (-not (Same $b $q.Off $n)) { [Array]::Copy($n, 0, $b, $q.Off, $n.Length); $changed++ } }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-ak-hanh-trang")) { Copy-Item $Dll "$Dll.truoc-ak-hanh-trang" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
