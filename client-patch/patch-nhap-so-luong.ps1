# Đổi chữ khung nhập số lượng khi mua ở shop: "Nhập số lượng mua" -> "Mua (tối đa 10000)" (server giới hạn 10000 mỗi lần).
# Chuỗi này dùng chung ở Panel.OpenShopBuyQuantityInput, onCancelChat, onChatFromMe (so sánh cùng ô literal) nên đổi nội dung trong
# global-metadata.dat là đủ, không sửa GameAssembly.dll. Bảng string literal v31: header +8 (offset bảng), +12 (size), +16 (offset data),
# mỗi mục {int len, int dataIndex}; ghi chuỗi mới ngắn hơn đè lên rồi giảm len (như patch-port.ps1).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-nhap-so-luong.ps1 "D:\nr-long"
param([Parameter(Mandatory = $true)][string]$ClientDir)
$ErrorActionPreference = 'Stop'

$meta = Get-ChildItem $ClientDir -Recurse -Filter global-metadata.dat | Select-Object -First 1 -ExpandProperty FullName
if (-not $meta) { Write-Host 'Khong tim thay global-metadata.dat.'; exit 1 }

$u = [Text.Encoding]::UTF8
$old = $u.GetBytes('Nhập số lượng mua')
$new = $u.GetBytes('Mua (tối đa 10000)')
if ($new.Length -gt $old.Length) { Write-Host 'Chuoi moi dai hon chuoi cu.'; exit 1 }
$m = [IO.File]::ReadAllBytes($meta)
$tblOff = [BitConverter]::ToInt32($m, 8); $tblSize = [BitConverter]::ToInt32($m, 12); $dataOff = [BitConverter]::ToInt32($m, 16)

function Match($m, $p, [byte[]]$x) { for ($i = 0; $i -lt $x.Length; $i++) { if ($m[$p + $i] -ne $x[$i]) { return $false } }; $true }
$done = $false; $changed = $false
for ($e = $tblOff; $e -lt $tblOff + $tblSize; $e += 8) {
    $len = [BitConverter]::ToInt32($m, $e); $idx = [BitConverter]::ToInt32($m, $e + 4)
    if ($len -eq $new.Length -and (Match $m ($dataOff + $idx) $new)) { $done = $true; break }
    if ($len -eq $old.Length -and (Match $m ($dataOff + $idx) $old)) {
        [Array]::Copy($new, 0, $m, $dataOff + $idx, $new.Length)
        [Array]::Copy([BitConverter]::GetBytes([int]$new.Length), 0, $m, $e, 4)
        $changed = $true; break
    }
}
if ($done) { Write-Host 'Da sua tu truoc, khong can sua.'; exit 0 }
if (-not $changed) { Write-Host 'Khong tim thay chuoi "Nhap so luong mua". Dung lai.'; exit 1 }
if (-not (Test-Path "$meta.truoc-nhap-so-luong")) { Copy-Item $meta "$meta.truoc-nhap-so-luong" }
[IO.File]::WriteAllBytes($meta, $m)
Write-Host 'Da doi chu khung nhap so luong mua.'
