# Tự nhặt (mod) ưu tiên món vừa click chuột (chỉ Game1).
#   PickMobController.Update, nhánh tự nhặt (PickMob.IsAutoPickItems bật): trước khi lấy món kế tiếp trong ItemPicks,
#   nếu Char.isManualFocus (static +E4h, FocusManualTo bật khi click tay) và Char.myCharz().itemFocus (+2D0h) còn trong GameScr.vItemMap
#   thì gửi Service.pickItem(itemFocus.itemMapID) trước, tăng ItemMap.countAutoPick (+88h), Wait(500).
#   Thử tối đa 3 lần mỗi món (món của người khác trong 45 giây server bỏ qua), sau đó tự nhặt chạy tiếp như cũ.
# Hook 0x4CDAA5 (mov rax,[rdx+0B8h]; cmp [rax+18h],r12b; je 4CDBE0) -> cave 0x5A13A0 (thân Game2.ModFunc.perform, sau cave của patch-ne-tan-sat-boss).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-click-nhat.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }
function Jmp([long]$from, [long]$to, [byte]$op) { $r = [BitConverter]::GetBytes([int]($to - ($from + 5))); return ,[byte[]](@($op) + $r) }
function Nops([int]$n) { if ($n -le 0) { return ,[byte[]]@() }; return ,[byte[]](@(0x90) * $n) }

$C = 0x5A13A0
$Hook = 0x4CDAA5
$CharTI = 0xCA51D0      # Game1.Char_TypeInfo
$GameScrTI = 0xCA7660   # Game1.GameScr_TypeInfo
$PmcTI = 0xCABAA0       # Game1.Mod.XMAP.PickMobController_TypeInfo
$VecContains = 0x1BEA80 # MyVector.contains
$ServiceGI = 0x48C050   # Game1.Service.gI
$PickItem = 0x4900F0    # Game1.Service.pickItem
$Wait = 0x4CEDB0        # PickMobController.Wait
$EndPick = 0x4CE2C4     # chỗ các nhánh nhặt khác nhảy tới sau Wait
$NotPicking = 0x4CDBE0  # IsPickingItems = false: lập danh sách mới
$Picking = 0x4CDAB6     # IsPickingItems = true: lấy ItemPicks[IndexItemPick]

$code = New-Object System.Collections.Generic.List[byte]
$fix = @()   # nhảy ngắn tới nhãn normal
function EmitB([string]$h) { foreach ($x in (Hex $h)) { $code.Add($x) } }
function EmitR([string]$op, [long]$target) {   # lệnh có rel32 ở cuối (call/jmp/jcc, hoặc [rip+disp32])
    EmitB $op
    $end = $C + $code.Count + 4
    foreach ($x in [BitConverter]::GetBytes([int]($target - $end))) { $code.Add($x) }
}
function EmitJ([string]$op) { EmitB $op; $script:fix += $code.Count; $code.Add(0) }   # jcc rel8 tới normal

# vào cave: rdx = PickMobController_TypeInfo, rdi = Char.myCharz(), r12 = 0
EmitR '48 8B 05' $CharTI          # mov rax,[Char_TypeInfo]
EmitB '48 8B 80 B8 00 00 00'      # mov rax,[rax+0B8h]
EmitB '80 B8 E4 00 00 00 00'      # cmp byte ptr [rax+0E4h],0   (isManualFocus)
EmitJ '74'                        # je normal
EmitB '48 8B 9F D0 02 00 00'      # mov rbx,[rdi+2D0h]          (itemFocus)
EmitB '48 85 DB'                  # test rbx,rbx
EmitJ '74'
EmitB '83 BB 88 00 00 00 03'      # cmp dword ptr [rbx+88h],3   (countAutoPick)
EmitJ '7D'                        # jge normal
EmitR '48 8B 05' $GameScrTI       # mov rax,[GameScr_TypeInfo]
EmitB '48 8B 80 B8 00 00 00'      # mov rax,[rax+0B8h]
EmitB '48 8B 88 F8 00 00 00'      # mov rcx,[rax+0F8h]          (vItemMap)
EmitB '48 85 C9'                  # test rcx,rcx
EmitJ '74'
EmitB '48 89 DA'                  # mov rdx,rbx
EmitB '45 31 C0'                  # xor r8d,r8d
EmitR 'E8' $VecContains           # call MyVector.contains
EmitB '84 C0'                     # test al,al
EmitJ '74'
EmitB '31 C9'                     # xor ecx,ecx
EmitR 'E8' $ServiceGI             # call Service.gI
EmitB '48 85 C0'                  # test rax,rax
EmitJ '74'
EmitB '48 89 C1'                  # mov rcx,rax
EmitB '8B 53 30'                  # mov edx,[rbx+30h]           (itemMapID)
EmitB '45 31 C0'                  # xor r8d,r8d
EmitR 'E8' $PickItem              # call Service.pickItem
EmitB 'FF 83 88 00 00 00'         # inc dword ptr [rbx+88h]
EmitB 'B9 F4 01 00 00'            # mov ecx,1F4h
EmitB '31 D2'                     # xor edx,edx
EmitR 'E8' $Wait                  # call PickMobController.Wait(500)
EmitR 'E9' $EndPick               # jmp 4CE2C4
$normal = $code.Count
EmitR '48 8B 15' $PmcTI           # mov rdx,[PickMobController_TypeInfo]
EmitB '48 8B 82 B8 00 00 00'      # mov rax,[rdx+0B8h]
EmitB '44 38 60 18'               # cmp [rax+18h],r12b          (IsPickingItems)
EmitR '0F 84' $NotPicking         # je 4CDBE0
EmitR 'E9' $Picking               # jmp 4CDAB6
foreach ($p in $fix) { $code[$p] = [byte]($normal - ($p + 1)) }
$cave = [byte[]]$code.ToArray()

$hookOld = Hex '48 8B 82 B8 00 00 00 44 38 60 18 0F 84 2A 01 00 00'
$hookNew = [byte[]]((Jmp $Hook $C 0xE9) + (Nops 12))

$b = [IO.File]::ReadAllBytes($Dll)
$hookOff = $Hook - 0x1800
$caveOff = $C - 0x1800
if ((Same $b $hookOff $hookNew) -and (Same $b $caveOff $cave)) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Same $b $hookOff $hookOld)) { Write-Host ('Byte tai RVA 0x{0:X} khong dung (khong phai ban goc, cung khong phai ban da sua). Dung lai.' -f $Hook); exit 1 }

if (-not (Test-Path "$Dll.truoc-click-nhat")) { Copy-Item $Dll "$Dll.truoc-click-nhat" }
[Array]::Copy($cave, 0, $b, $caveOff, $cave.Length)
[Array]::Copy($hookNew, 0, $b, $hookOff, $hookNew.Length)
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua (cave $($cave.Length) byte). MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
