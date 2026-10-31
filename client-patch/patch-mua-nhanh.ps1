# Mua số lượng ("Nhập số lượng mua") gửi 1 gói kèm số lượng thay vì lặp N gói, chỉ Game1.
#   Gốc: Panel.onChatFromMe → ModFunc.AutoBuyItem (0x3D3E10) mở thread chạy <AutoBuyItem>b__0 (0x3F9C00):
#   for (i < count [rbx+18h]) { Service.buyItem(type [rbx+10h], id [rbx+14h], 0); Thread.Sleep(200); } → 100 món = 20 giây.
#   Service.buyItem (0x4886D0, gói 6) tự ghi thêm short số lượng nếu > 1; server (Controller case 6) đọc số lượng.
#   Patch 0x3F9C60–0x3F9C8B: gọi buyItem 1 lần với r9d = count rồi thoát luôn (epilogue + ret).
#   Không nhảy tới đoạn báo "Đã mua xong" (0x3F9C8B, InfoMe.addInfo): đoạn đó chạy trên luồng nền, đo chữ bằng
#   GUIStyle.CalcSize của Unity ngoài luồng chính → lúc được lúc crash (31/10/2026, mua 5 món ở Santa). Server đã báo "Mua thành công xN".
#   Bản trước của script (EB 10 = jmp 0x3F9C8B) cũng được nhận và nâng lên.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-mua-nhanh.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)
$ErrorActionPreference = 'Stop'

function Hex([string]$s) { return ,[byte[]]($s -split ' ' | ForEach-Object { [Convert]::ToByte($_, 16) }) }
function Same($b, $off, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($b[$off + $i] -ne $x[$i]) { return $false } }; $true }

$b = [IO.File]::ReadAllBytes($Dll)
$sections = @(
    @{ Off = 0x3F9C60 - 0x1800;
        Old = (Hex '44 8B 43 14 45 33 C9 0F B6 53 10 48 8B C8 48 89 74 24 20 E8 58 EA 08 00 33 D2 B9 C8 00 00 00 E8 6C 1E 55 00 FF C7 3B 7B 18 7C C5');
        Old2 = (Hex '44 8B 43 14 44 8B 4B 18 0F B6 53 10 48 8B C8 48 89 74 24 20 E8 57 EA 08 00 EB 10 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90');
        # sau call buyItem: mov rbx,[rsp+40h]; mov rsi,[rsp+48h]; add rsp,30h; pop rdi; ret
        New = (Hex '44 8B 43 14 44 8B 4B 18 0F B6 53 10 48 8B C8 48 89 74 24 20 E8 57 EA 08 00 48 8B 5C 24 40 48 8B 74 24 48 48 83 C4 30 5F C3 90 90') }
)

$changed = 0
foreach ($p in $sections) {
    if (Same $b $p.Off $p.New) { continue }
    if (-not (Same $b $p.Off $p.Old) -and -not (Same $b $p.Off $p.Old2)) { Write-Host ('Byte tai offset 0x{0:X} khong dung. Dung lai.' -f $p.Off); exit 1 }
}
foreach ($p in $sections) {
    if (Same $b $p.Off $p.New) { continue }
    [Array]::Copy($p.New, 0, $b, $p.Off, $p.New.Length); $changed++
}
if ($changed -eq 0) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.truoc-mua-nhanh")) { Copy-Item $Dll "$Dll.truoc-mua-nhanh" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
