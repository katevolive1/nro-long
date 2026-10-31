# Khung mục tiêu giữa trên màn hình (click vào boss/người): chữ đỏ, "Tên" rồi "HP/HP tối đa" (có dấu chấm nghìn),
# thay cho chữ xanh lá (mFont.tahoma_7b_green2 +80h) chỉ hiện HP hiện tại.
# GameScr.paintInfoBar (Game1 RVA 0x372F20), nhánh charFocus ([myCharz+2C8h]):
#   0x3736C2 (dòng tên) và 0x373781 (dòng HP): font [mFont+80h] -> [mFont+50h] (tahoma_7b_red).
#   0x3737A8..0x3737B4 (movsd xmm0,[rax+0D0h]; jmp 0x373625) -> jmp cave: chuỗi = getMoneys(cHP) + "/" + getMoneys(cHPFull) (cHPFull [Char+108h]),
#   gán r14 rồi nhảy 0x37364B (đoạn gốc test rbx / vẽ dòng HP căn giữa).
# Cave ở thân Game2.ModFunc.UpdateKey không ai gọi (RVA 0x59C000..), vùng trống tới 0x59C3A0 (xem CLIENT-UNITY.md).
# Không đụng nhánh mục tiêu là quái / NPC và dòng tên + vàng của bản thân (vẫn xanh lá).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-khung-muc-tieu.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Rel([long]$from, [long]$to) { return ,[BitConverter]::GetBytes([int]($to - $from)) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$site = 0x3737A8; $cave = 0x59C000
$getMoneys = 0x3F5280; $concat3 = 0x786510; $slash = 0xCACAF8; $back = 0x37364B

# cave (mỗi lệnh ghi kèm địa chỉ cuối lệnh để tính rel32)
$c = New-Object System.Collections.ArrayList
function Emit([byte[]]$x) { [void]$script:c.AddRange($x) }
function Pos { return $script:cave + $script:c.Count }
Emit (Hex '48 89 44 24 38')                                   # mov [rsp+38h],rax   (charFocus)
Emit (Hex 'F2 0F 10 80 D0 00 00 00')                          # movsd xmm0,[rax+0D0h]  cHP
Emit (Hex '33 D2')                                            # xor edx,edx
Emit (Hex 'E8'); Emit (Rel ((Pos) + 4) $getMoneys)            # call getMoneys
Emit (Hex '4C 8B F0')                                         # mov r14,rax
Emit (Hex '48 8B 44 24 38')                                   # mov rax,[rsp+38h]
Emit (Hex 'F2 0F 10 80 08 01 00 00')                          # movsd xmm0,[rax+108h]  cHPFull
Emit (Hex '33 D2')                                            # xor edx,edx
Emit (Hex 'E8'); Emit (Rel ((Pos) + 4) $getMoneys)            # call getMoneys
Emit (Hex '4C 8B C0')                                         # mov r8,rax
Emit (Hex '49 8B CE')                                         # mov rcx,r14
Emit (Hex '48 8B 15'); Emit (Rel ((Pos) + 4) $slash)          # mov rdx,["/"]
Emit (Hex '45 33 C9')                                         # xor r9d,r9d
Emit (Hex 'E8'); Emit (Rel ((Pos) + 4) $concat3)              # call String.Concat(a,b,c)
Emit (Hex '4C 8B F0')                                         # mov r14,rax
Emit (Hex 'E9'); Emit (Rel ((Pos) + 4) $back)                 # jmp 0x37364B
$caveBytes = [byte[]]$c.ToArray()

$patches = @(
    @{ Off = 0x3736C5 - 0x1800; Old = (Hex '80'); New = (Hex '50') },
    @{ Off = 0x373784 - 0x1800; Old = (Hex '80'); New = (Hex '50') },
    @{ Off = $site - 0x1800; Old = (Hex 'F2 0F 10 80 D0 00 00 00 E9 70 FE FF FF'); New = [byte[]]((Hex 'E9') + (Rel ($site + 5) $cave) + (Hex '90 90 90 90 90 90 90 90')) },
    @{ Off = $cave - 0x1800; Old = $null; New = $caveBytes }
)

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($q in $patches) {
    if (-not (Same $b $q.Off $q.New) -and $q.Old -ne $null -and -not (Same $b $q.Off $q.Old)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $q.Off); exit 1 }
}
$changed = 0
foreach ($q in $patches) { if (-not (Same $b $q.Off $q.New)) { [Array]::Copy($q.New, 0, $b, $q.Off, $q.New.Length); $changed++ } }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-khung-muc-tieu")) { Copy-Item $Dll "$Dll.truoc-khung-muc-tieu" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
