# Tự đăng nhập cho client của slot (chỉ vá bản GameAssembly.dll trong slot, không vá client gốc của người chơi).
# ModFunc.AutoLogin (Game1 RVA 0x3D44E0, gọi mỗi frame từ LoginScr.update / ServerListScreen.update) bỏ qua khi
# ModFunc.autoLogin (static +70h) = null; object này chỉ được tạo khi bấm menu mod nên mặc định không bao giờ tự đăng nhập.
# Sửa: nhánh "autoLogin == null" (0x3D4575, je -> 0x3D4A49) nhảy vào cave tạo sẵn AutoLogin, đặt hasSetUserPass (+20h) = 1
# để bỏ bước tra danh sách tài khoản, dùng thẳng acc/pass trong RMS của slot, rồi quay lại 0x3D457B.
# Cave ở thân Game2.ModFunc.UpdateKey không ai gọi (RVA 0x59C200, vùng trống tới 0x59C3A0, xem client-patch\CLIENT-UNITY.md).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-tu-dang-nhap.ps1 "F:\nro-long-manager\slots\1\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Rel([long]$from, [long]$to) { return ,[BitConverter]::GetBytes([int]($to - $from)) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$site = 0x3D4575; $back = 0x3D457B; $cave = 0x59C200
$objNew = 0x991F0; $ctor = 0x2D2D90; $wbarrier = 0x98390
$tiAutoLogin = 0xCA45E0; $tiModFunc = 0xCAA740

$c = New-Object System.Collections.ArrayList
function Emit([byte[]]$x) { [void]$script:c.AddRange($x) }
function Pos { return $script:cave + $script:c.Count }
Emit (Hex '48 8D 0D'); Emit (Rel ((Pos) + 4) $tiAutoLogin)    # lea rcx,[ô AutoLogin_TypeInfo]
Emit (Hex 'E8'); Emit (Rel ((Pos) + 4) 0x99030)               # call 0x99030: nạp lười TypeInfo (AutoLogin() chưa dùng kiểu này, ô còn là token)
Emit (Hex '48 8B 0D'); Emit (Rel ((Pos) + 4) $tiAutoLogin)    # mov rcx,[AutoLogin_TypeInfo]
Emit (Hex 'E8'); Emit (Rel ((Pos) + 4) $objNew)               # call il2cpp_object_new
Emit (Hex '48 8B D8')                                         # mov rbx,rax
Emit (Hex '48 8B C8')                                         # mov rcx,rax
Emit (Hex '33 D2')                                            # xor edx,edx
Emit (Hex 'E8'); Emit (Rel ((Pos) + 4) $ctor)                 # call AutoLogin..ctor
Emit (Hex 'C6 43 20 01')                                      # mov byte [rbx+20h],1   hasSetUserPass
Emit (Hex '48 8B 0D'); Emit (Rel ((Pos) + 4) $tiModFunc)      # mov rcx,[ModFunc_TypeInfo]
Emit (Hex '48 8B 89 B8 00 00 00')                             # mov rcx,[rcx+0B8h]     static fields
Emit (Hex '48 89 59 70')                                      # mov [rcx+70h],rbx      autoLogin
Emit (Hex '48 8B D3')                                         # mov rdx,rbx
Emit (Hex '48 83 C1 70')                                      # add rcx,70h
Emit (Hex 'E8'); Emit (Rel ((Pos) + 4) $wbarrier)             # call gc_wbarrier_set
Emit (Hex '48 8B 0D'); Emit (Rel ((Pos) + 4) $tiModFunc)      # mov rcx,[ModFunc_TypeInfo]
Emit (Hex 'E9'); Emit (Rel ((Pos) + 4) $back)                 # jmp 0x3D457B
$caveBytes = [byte[]]$c.ToArray()
$jmpBytes = [byte[]]((Hex '0F 84') + (Rel ($site + 6) $cave))  # je near cave

$b = [IO.File]::ReadAllBytes($Dll)
$siteOff = $site - 0x1800; $caveOff = $cave - 0x1800
if (Same $b $siteOff $jmpBytes) { Write-Host 'Da sua tu truoc.'; exit 0 }
if (-not (Same $b $siteOff (Hex '0F 84 CE 04 00 00'))) { Write-Host ('Byte tai 0x{0:X} khong dung (client khac ban?). Dung lai.' -f $site); exit 1 }
for ($i = 0; $i -lt $caveBytes.Length; $i++) { if ($b[$caveOff + $i] -eq 0xCC -and $false) { } }
if ($caveOff + $caveBytes.Length -gt 0x59C3A0 - 0x1800) { Write-Host 'Cave qua dai.'; exit 1 }
[Array]::Copy($caveBytes, 0, $b, $caveOff, $caveBytes.Length)
[Array]::Copy($jmpBytes, 0, $b, $siteOff, 6)
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua tu dang nhap ($($caveBytes.Length) byte cave)."
