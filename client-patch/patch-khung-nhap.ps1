# Khung nhập của server (ClientInput, vd "Bạn muốn bán bao nhiêu [Thỏi vàng]") vẽ trên các khung cửa hàng/hành trang.
# Gốc: ClientInput là màn hình (mScreen) nên vẽ trước Panel.paint, bị 2 khung đè. Sửa (chỉ Game1, runtime dùng Game1):
#   1. ClientInput.paint: vẽ xong cảnh game (GameScr.paint) thì trả về luôn (RVA 0x4E5AF1).
#   2. Hàm mới "vẽ hộp nhập" (cave B, .text): dựng lại khung stack như ClientInput.paint rồi nhảy vào phần vẽ hộp (0x4E5AFB),
#      phần này tự kết thúc bằng mScreen.paint (nút Đóng/OK).
#   3. GameCanvas.paint tại 0x39F9D8 (sau Panel + ô chat, trước InfoDlg/Menu): nếu currentScreen là ClientInput thì gọi cave B.
# Cave nằm ở phần dư cuối section .text (RVA 0x17D378..0x17D400), script nới VirtualSize của .text.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-khung-nhap.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'   # lỗi ghi file (vd game đang mở) thì dừng, không báo "Da sua"

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Rel([long]$from, [long]$to) { return ,[BitConverter]::GetBytes([int]($to - $from)) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$IL = 0x1800    # il2cpp: offset = RVA - 0x1800
$TX = 0xC00     # .text:  offset = RVA - 0xC00
$caveB = 0x17D378; $caveC = 0x17D3B8
$tiGameCanvas = 0xCA74F8; $tiClientInput = 0xCA5528; $tiPopUp = 0xCABE38; $tiRes = 0xCACB28

# Cave B: hộp nhập (rcx = ClientInput, rdx = g)
$b1 = Hex '57 41 56 48 83 EC 58 4C 8B F2 48 8B F9 48 89 5C 24 70 48 89 AC 24 80 00 00 00 48 89 B4 24 88 00 00 00 4C 89 64 24 50 4C 89 6C 24 48 4C 89 7C 24 40'
$p = $caveB + $b1.Length
$b2 = [byte[]]((Hex '48 8B 0D') + (Rel ($p + 7) $tiPopUp))          # mov rcx,[PopUp_TypeInfo]
$b3 = Hex '8B 77 38'                                                  # mov esi,[rdi+38h]
$p2 = $p + $b2.Length + $b3.Length
$b4 = [byte[]]((Hex 'E9') + (Rel ($p2 + 5) 0x4E5AFB))                 # jmp vào phần vẽ hộp
$caveBBytes = [byte[]]($b1 + $b2 + $b3 + $b4)

# Cave C: chèn vào GameCanvas.paint
$c = New-Object System.Collections.Generic.List[byte]
function Add([byte[]]$x) { $c.AddRange($x) }
Add ((Hex '48 8B 05') + (Rel ($caveC + 7) $tiGameCanvas))             # mov rax,[GameCanvas_TypeInfo]
Add (Hex '48 8B 80 B8 00 00 00')                                      # mov rax,[rax+0B8h]
Add (Hex '48 8B 88 C8 00 00 00')                                      # mov rcx,[rax+0C8h]  currentScreen
Add (Hex '48 85 C9 74 1D')                                            # test rcx,rcx ; je done (+29)
Add (Hex '48 8B 01')                                                  # mov rax,[rcx]
Add ((Hex '48 3B 05') + (Rel ($caveC + $c.Count + 7) $tiClientInput)) # cmp rax,[ClientInput_TypeInfo]
Add (Hex '75 11')                                                     # jne done (+17)
Add (Hex '48 8B 57 10 48 83 EC 20')                                   # mov rdx,[rdi+10h] ; sub rsp,20h
Add ((Hex 'E8') + (Rel ($caveC + $c.Count + 5) $caveB))               # call cave B
Add (Hex '48 83 C4 20')                                               # add rsp,20h
# done:
Add (Hex '48 8B 5F 10')                                               # mov rbx,[rdi+10h]   (lệnh gốc)
Add ((Hex '48 8B 0D') + (Rel ($caveC + $c.Count + 7) $tiRes))         # mov rcx,[Res_TypeInfo] (lệnh gốc)
Add ((Hex 'E9') + (Rel ($caveC + $c.Count + 5) 0x39F9E3))             # jmp về
$caveCBytes = $c.ToArray()
if ($caveC + $caveCBytes.Length -gt 0x17D400 -or $caveB + $caveBBytes.Length -gt $caveC) { Write-Host 'Cave khong du cho.'; exit 1 }

$patches = @(
    @{ Off = 0x4E5AF1 - $IL; Old = (Hex '48 8B 0D 40 63 7C 00 8B'); New = (Hex '48 83 C4 58 41 5E 5F C3') },
    @{ Off = 0x39F9D8 - $IL; Old = (Hex '48 8B 5F 10 48 8B 0D 45 D1 90 00'); New = [byte[]]((Hex 'E9') + (Rel (0x39F9D8 + 5) $caveC) + (Hex '90 90 90 90 90 90')) },
    @{ Off = $caveB - $TX; Old = [byte[]](,0 * $caveBBytes.Length); New = $caveBBytes },
    @{ Off = $caveC - $TX; Old = [byte[]](,0 * $caveCBytes.Length); New = $caveCBytes }
)

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($q in $patches) {
    if (-not (Same $b $q.Off $q.New) -and -not (Same $b $q.Off $q.Old)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $q.Off); exit 1 }
}
$changed = 0
foreach ($q in $patches) { if (-not (Same $b $q.Off $q.New)) { [Array]::Copy($q.New, 0, $b, $q.Off, $q.New.Length); $changed++ } }
# .text VirtualSize = SizeOfRawData để vùng cave được nạp
$pe = [BitConverter]::ToInt32($b, 0x3C); $sec = $pe + 24 + [BitConverter]::ToUInt16($b, $pe + 20)
if ([Text.Encoding]::ASCII.GetString($b, $sec, 5) -ne '.text') { Write-Host 'Khong thay section .text.'; exit 1 }
$raw = [BitConverter]::ToUInt32($b, $sec + 16)
if ([BitConverter]::ToUInt32($b, $sec + 8) -lt $raw) { [Array]::Copy([BitConverter]::GetBytes([uint32]$raw), 0, $b, $sec + 8, 4); $changed++ }
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-khung-nhap")) { Copy-Item $Dll "$Dll.truoc-khung-nhap" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
