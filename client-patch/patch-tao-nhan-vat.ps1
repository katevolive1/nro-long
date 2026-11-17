# Sửa màn tạo nhân vật hiện áo/quần cấp 1 như trong game (Trái Đất, Namek, Xayda).
# Giá trị khởi tạo của CreateCharScr.defaultBody và CreateCharScr.defaultLeg nằm trong global-metadata.dat (<PrivateImplementationDetails>):
# - defaultBody tại 0x16CCA0: cũ (157, 149, 151) -> mới (14, 10, 16)
# - defaultLeg tại 0x16D2D8: cũ (158, 150, 152) -> mới (15, 11, 17)
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-tao-nhan-vat.ps1 "D:\nr-long"
param([Parameter(Mandatory = $true)][string]$ClientDir)
$ErrorActionPreference = 'Stop'

$meta = Get-ChildItem $ClientDir -Recurse -Filter global-metadata.dat | Select-Object -First 1 -ExpandProperty FullName
if (-not $meta) { Write-Host 'Khong tim thay global-metadata.dat.'; exit 1 }

$m = [IO.File]::ReadAllBytes($meta)
if ($m.Length -lt (0x16D2D8 + 12)) { Write-Host 'File global-metadata.dat qua nho hoac khong hop le.'; exit 1 }

$bodyOld = @(157, 149, 151)
$bodyNew = @(14, 10, 16)
$legOld  = @(158, 150, 152)
$legNew  = @(15, 11, 17)

$bodyCur = @([BitConverter]::ToInt32($m, 0x16CCA0), [BitConverter]::ToInt32($m, 0x16CCA4), [BitConverter]::ToInt32($m, 0x16CCA8))
$legCur  = @([BitConverter]::ToInt32($m, 0x16D2D8), [BitConverter]::ToInt32($m, 0x16D2DC), [BitConverter]::ToInt32($m, 0x16D2E0))

function SameInts([int[]]$a, [int[]]$b) {
    if ($a.Length -ne $b.Length) { return $false }
    for ($i = 0; $i -lt $a.Length; $i++) {
        if ($a[$i] -ne $b[$i]) { return $false }
    }
    return $true
}

$isNew = (SameInts $bodyCur $bodyNew) -and (SameInts $legCur $legNew)
$isOld = (SameInts $bodyCur $bodyOld) -and (SameInts $legCur $legOld)

if ($isNew) {
    Write-Host 'Da sua tu truoc, khong can sua.'
    exit 0
}

if ($isOld) {
    if (-not (Test-Path "$meta.truoc-tao-nhan-vat")) {
        Copy-Item $meta "$meta.truoc-tao-nhan-vat"
    }
    for ($i = 0; $i -lt 3; $i++) {
        [Array]::Copy([BitConverter]::GetBytes([int]$bodyNew[$i]), 0, $m, 0x16CCA0 + ($i * 4), 4)
        [Array]::Copy([BitConverter]::GetBytes([int]$legNew[$i]), 0, $m, 0x16D2D8 + ($i * 4), 4)
    }
    [IO.File]::WriteAllBytes($meta, $m)
    Write-Host 'Da sua ao quan tao nhan vat.'
    exit 0
}

Write-Host ("Gia tri khong dung. defaultBody: [{0}], defaultLeg: [{1}]. Dung lai." -f ($bodyCur -join ', '), ($legCur -join ', '))
exit 1
