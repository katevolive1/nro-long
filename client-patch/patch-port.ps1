# Đổi port mặc định 14445 -> 14446 (GameMidlet.PORT) và bỏ dòng "Mod INT free by Srcnrofree.online"
# trong khung nhập IP/PORT. Sửa GameAssembly.dll và global-metadata.dat.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch-port.ps1 "D:\nr-long"
param([Parameter(Mandatory = $true)][string]$ClientDir)

$dll = Join-Path $ClientDir 'GameAssembly.dll'
$meta = Get-ChildItem $ClientDir -Recurse -Filter global-metadata.dat | Select-Object -First 1 -ExpandProperty FullName
if (-not (Test-Path $dll) -or -not $meta) { Write-Host 'Khong tim thay GameAssembly.dll hoac global-metadata.dat.'; exit 1 }

# 1. GameMidlet..cctor: mov dword ptr [rcx+8],386Dh (C7 41 08 6D 38 00 00) ở Game1 và Game2
$b = [IO.File]::ReadAllBytes($dll)
$portOffsets = @(0x3A4329, 0x55B929)   # offset file của byte thấp hằng số
$dllChanged = $false
foreach ($o in $portOffsets) {
    if ($b[$o - 3] -ne 0xC7 -or $b[$o - 2] -ne 0x41 -or $b[$o - 1] -ne 0x08 -or $b[$o + 1] -ne 0x38) {
        Write-Host ('Byte port tai 0x{0:X} khong dung. Dung lai.' -f $o); exit 1
    }
    if ($b[$o] -eq 0x6D) { $b[$o] = 0x6E; $dllChanged = $true }
}

# 2. Chuỗi trong khung nhập IP/PORT (bảng string literal của metadata v31)
$u = [Text.Encoding]::UTF8
$old = $u.GetBytes("Nhập IP và PORT`nIP Game: mặc định = IP VPS`nPORT Game: mặc định = 14445`nMod INT free by Srcnrofree.online")
$new = $u.GetBytes("Nhập IP và PORT`nIP Game: mặc định = IP VPS`nPORT Game: mặc định = 14446")
$m = [IO.File]::ReadAllBytes($meta)
$tblOff = [BitConverter]::ToInt32($m, 8); $tblSize = [BitConverter]::ToInt32($m, 12)
$dataOff = [BitConverter]::ToInt32($m, 16)
$metaChanged = $false
for ($e = $tblOff; $e -lt $tblOff + $tblSize; $e += 8) {
    $len = [BitConverter]::ToInt32($m, $e); $idx = [BitConverter]::ToInt32($m, $e + 4)
    if ($len -ne $old.Length -and $len -ne $new.Length) { continue }
    $p = $dataOff + $idx; $same = $true
    for ($i = 0; $i -lt $new.Length - 1; $i++) { if ($m[$p + $i] -ne $old[$i] -and $i -lt 60) { $same = $false; break } }
    if (-not $same) { continue }
    if ($len -eq $new.Length) { break }   # đã sửa rồi
    [Array]::Copy($new, 0, $m, $p, $new.Length)
    [Array]::Copy([BitConverter]::GetBytes([int]$new.Length), 0, $m, $e, 4)
    $metaChanged = $true; break
}
if (-not $metaChanged -and $e -ge $tblOff + $tblSize) { Write-Host 'Khong tim thay chuoi khung nhap IP/PORT. Dung lai.'; exit 1 }

if ($dllChanged) {
    if (-not (Test-Path "$dll.truoc-port")) { Copy-Item $dll "$dll.truoc-port" }
    [IO.File]::WriteAllBytes($dll, $b)
}
if ($metaChanged) {
    if (-not (Test-Path "$meta.truoc-port")) { Copy-Item $meta "$meta.truoc-port" }
    [IO.File]::WriteAllBytes($meta, $m)
}
Write-Host "Xong. Port mac dinh: $(if ($dllChanged) {'da doi 14446'} else {'da la 14446'}); chuoi: $(if ($metaChanged) {'da sua'} else {'da sua tu truoc'})."
