# Số thỏi vàng ở thanh dưới khung (Panel.paintBottomMoneyInfo) = tổng mọi chồng thỏi vàng (457) trong hành trang.
# Gốc: lấy số lượng chồng 457 đầu tiên rồi dừng, nên chồng khóa giao dịch + chồng giao dịch được chỉ hiện 1 chồng.
# Viết lại vòng lặp tại chỗ (Game1 RVA 0x429ED4..0x429F31, runtime dùng Game1): cộng dồn rồi gọi NinjaUtil.getMoneys.
# Vào vòng lặp: rdx = &arrItemBag[0], r10d = độ dài, r11d = 457; ra: rsi = chuỗi hiển thị ("" nếu không có).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-thoi-vang.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'   # lỗi ghi file (vd game đang mở) thì dừng, không báo "Da sua"

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Rel([long]$from, [long]$to) { return ,[BitConverter]::GetBytes([int]($to - $from)) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$S = 0x429ED4; $E = 0x429F31; $off = $S - 0x1800
$code = [byte[]](
    (Hex '31 C0 31 C9') +                       # xor eax,eax (tổng) ; xor ecx,ecx (i)
    (Hex '41 3B CA 7D 24') +                    # loop: cmp ecx,r10d ; jge end
    (Hex '4C 8B 04 CA FF C1 4D 85 C0 74 F0') +  # mov r8,[rdx+rcx*8] ; inc ecx ; test r8,r8 ; je loop
    (Hex '49 8B 70 18 48 85 F6 74 E7') +        # mov rsi,[r8+18h] (template) ; test ; je loop
    (Hex '66 44 39 5E 10 75 E0') +              # cmp [rsi+10h],r11w (id == 457) ; jne loop
    (Hex '4D 63 40 38 4C 01 C0 EB D7') +        # movsxd r8,[r8+38h] (quantity) ; add rax,r8 ; jmp loop
    (Hex '48 8B 35') + (Rel ($S + 52) 0xCA8030) + # end: mov rsi,[""]
    (Hex '48 85 C0 7E 24') +                    # test rax,rax ; jle 0x429F31
    (Hex 'F2 48 0F 2A C0 33 D2 E8') + (Rel ($S + 69) 0x3F5280) + # cvtsi2sd xmm0,rax ; xor edx,edx ; call NinjaUtil.getMoneys
    (Hex '48 8B F0 EB 13'))                     # mov rsi,rax ; jmp 0x429F31
$new = New-Object byte[] ($E - $S)
for ($i = 0; $i -lt $new.Length; $i++) { $new[$i] = 0x90 }
[Array]::Copy($code, $new, $code.Length)
# 4 lệnh đầu của vòng lặp gốc để chắc đúng chỗ
$old = Hex '41 3B CA 7D 51 41 3B C2 0F 83 86 04 00 00 48 8B 0A'

$b = [IO.File]::ReadAllBytes($Dll)
if (Same $b $off $new) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Same $b $off $old)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $off); exit 1 }
[Array]::Copy($new, 0, $b, $off, $new.Length)
if (-not (Test-Path "$Dll.truoc-thoi-vang")) { Copy-Item $Dll "$Dll.truoc-thoi-vang" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
