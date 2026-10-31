# Thay thanh máu xanh bo góc giữa trên màn hình khi click vào đệ/boss/người (mod ModFunc.PaintListInfo, Game1 0x3DDDA0)
# bằng 2 dòng chữ đỏ viền (mFont+50h, drawStringBorder): "Tên" rồi "HP/HP tối đa" (có dấu chấm nghìn).
# Đoạn gốc 0x3DDEF6..0x3DE0D1: 3 lần fillRect bo góc (khung 0x808080, nền 0x2B2B2B, thanh xanh/vàng/đỏ) + chữ HP trắng.
# Viết đè code mới từ 0x3DDEF6, cuối cùng jmp 0x3DE0D1 (ebx = 57h, vẽ các dòng trạng thái Bị choáng, Bị TDHS... giữ nguyên).
# Đầu vào: ebx = GameCanvas.w/2, rdi = charFocus, rsi = g; code phía sau cần r15 = 0.
# Bản cũ của script này (chỉ bỏ thanh: 45 33 FF E9 D3 01 00 00) cũng được nhận và nâng lên bản mới.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-bo-thanh-muc-tieu.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$site = 0x3DDEF6; $end = 0x3DE0D1
$fontTI = 0xC97BA8; $initClass = 0x992E0; $drawBorder = 0x3CAEB0
$getMoneys = 0x3F5280; $concat3 = 0x786510; $slash = 0xCACAF8

$c = New-Object System.Collections.ArrayList
function Emit([byte[]]$x) { [void]$script:c.AddRange($x) }
function Pos { return $script:site + $script:c.Count }
function Rel32([long]$target) { return ,[BitConverter]::GetBytes([int]($target - ((Pos) + 4))) }   # gọi ngay sau opcode
function Call([long]$t) { Emit (Hex 'E8'); Emit (Rel32 $t) }
function LoadFontStatics {                                     # rax = mFont statics, rcx = font đỏ (+50h)
    Emit (Hex '48 8B 0D'); Emit (Rel32 $fontTI)                # mov rcx,[mFont_TypeInfo]
    Emit (Hex '48 8B 81 B8 00 00 00')                          # mov rax,[rcx+0B8h]
    Emit (Hex '48 8B 48 50')                                   # mov rcx,[rax+50h]  tahoma đỏ
}
function DrawLine([byte]$y) {                                  # r8 = chuỗi đã nạp
    LoadFontStatics
    Emit (Hex '8B 50 08'); Emit (Hex '89 54 24 28')            # [rsp+28h] = canh giữa ([statics+8])
    Emit (Hex '48 8B 90 D8 00 00 00'); Emit (Hex '48 89 54 24 30')  # [rsp+30h] = font viền ([statics+0D8h])
    Emit (Hex '4C 89 7C 24 38')                                # [rsp+38h] = 0
    Emit (Hex 'C7 44 24 20'); Emit ([byte[]]@($y, 0, 0, 0))   # [rsp+20h] = y
    Emit (Hex '44 8D 4B 01')                                   # lea r9d,[rbx+1]  x
    Emit (Hex '48 8B D6')                                      # mov rdx,rsi  g
    Call $drawBorder
}

Emit (Hex '45 33 FF')                                          # xor r15d,r15d
Emit (Hex '48 8B 0D'); Emit (Rel32 $fontTI)                    # mov rcx,[mFont_TypeInfo]
Emit (Hex '83 B9 E0 00 00 00 00')                              # cmp dword [rcx+0E0h],0
Emit (Hex '75 05'); Call $initClass                            # jne +5 ; call khởi tạo static
# Dòng 1: tên
Emit (Hex '4C 8B 87 90 01 00 00')                              # mov r8,[rdi+190h]  cName
DrawLine 0x43
# Dòng 2: getMoneys(cHP) + "/" + getMoneys(cHPFull)
Emit (Hex 'F2 0F 10 87 D0 00 00 00'); Emit (Hex '33 D2'); Call $getMoneys   # cHP
Emit (Hex '48 8B E8')                                          # mov rbp,rax
Emit (Hex 'F2 0F 10 87 08 01 00 00'); Emit (Hex '33 D2'); Call $getMoneys   # cHPFull
Emit (Hex '4C 8B C0')                                          # mov r8,rax
Emit (Hex '48 8B 15'); Emit (Rel32 $slash)                     # mov rdx,["/"]
Emit (Hex '48 8B CD'); Emit (Hex '45 33 C9'); Call $concat3    # Concat(rbp, "/", r8)
Emit (Hex '4C 8B C0')                                          # mov r8,rax
DrawLine 0x4D
Emit (Hex 'E9'); Emit (Rel32 $end)                             # jmp 0x3DE0D1
$new = [byte[]]$c.ToArray()
if ($site + $new.Length -gt $end) { Write-Host 'Code moi qua dai. Dung lai.'; exit 1 }

$off = $site - 0x1800
$b = [IO.File]::ReadAllBytes($Dll)
if (Same $b $off $new) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Same $b $off (Hex '45 33 C0 BA 80 80 80 00')) -and -not (Same $b $off (Hex '45 33 FF E9 D3 01 00 00'))) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $off); exit 1 }
if (-not (Test-Path "$Dll.truoc-bo-thanh-muc-tieu")) { Copy-Item $Dll "$Dll.truoc-bo-thanh-muc-tieu" }
[Array]::Copy($new, 0, $b, $off, $new.Length)
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host ("Da sua ({0} byte). MD5 moi: {1}" -f $new.Length, (Get-FileHash $Dll -Algorithm MD5).Hash)
