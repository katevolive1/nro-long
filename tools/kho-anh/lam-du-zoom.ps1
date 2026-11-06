# Bù icon thiếu mức zoom trong data/icon (x2, x3, x4) và đồng bộ web/icon với x2.
# Chỉ thêm file còn thiếu, KHÔNG ghi đè file có sẵn. Bỏ qua ảnh giữ chỗ (từ 2x2 trở xuống), không có gì để phóng.
# Thu nhỏ từ x4: rộng/cao x2 = 1/2, x3 = 3/4 (làm tròn). HighQualityBicubic khớp ảnh gốc nhất (đo 6/11/2026).
# Thiếu x4 thì phóng từ x3, kích thước theo x2 nhân 2.
# Xem trước: .\lam-du-zoom.ps1 -Preview      Làm thật: .\lam-du-zoom.ps1
param([switch]$Preview)
Add-Type -AssemblyName System.Drawing
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
$icon = Join-Path $root 'Teamobi2026\data\icon'
$web = Join-Path $root 'web\icon'

function Get-Ids($dir) {
    $set = New-Object 'System.Collections.Generic.HashSet[string]'
    foreach ($f in [IO.Directory]::GetFiles($dir, '*.png')) { [void]$set.Add([IO.Path]::GetFileNameWithoutExtension($f)) }
    return ,$set
}

function Save-Scaled([string]$from, [string]$to, [int]$w, [int]$h) {
    if (Test-Path -LiteralPath $to) { throw "Da co file, khong ghi de: $to" }
    $src = New-Object System.Drawing.Bitmap($from)
    $bmp = New-Object System.Drawing.Bitmap($w, $h, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.CompositingMode = 'SourceCopy'
    $g.InterpolationMode = 'HighQualityBicubic'
    $g.PixelOffsetMode = 'HighQuality'
    $attr = New-Object System.Drawing.Imaging.ImageAttributes
    $attr.SetWrapMode('TileFlipXY') # tránh viền lạ ở mép ảnh
    $g.DrawImage($src, (New-Object System.Drawing.Rectangle(0, 0, $w, $h)), 0, 0, $src.Width, $src.Height, 'Pixel', $attr)
    $attr.Dispose(); $g.Dispose()
    $bmp.Save($to, [System.Drawing.Imaging.ImageFormat]::Png)
    $bmp.Dispose(); $src.Dispose()
}

function Get-Size([string]$path) {
    $img = [System.Drawing.Image]::FromFile($path)
    $size = @($img.Width, $img.Height)
    $img.Dispose()
    return $size
}

$x2 = Get-Ids "$icon\x2"
$x3 = Get-Ids "$icon\x3"
$x4 = Get-Ids "$icon\x4"
$done = @{ x2 = 0; x3 = 0; x4 = 0; web = 0; boqua = 0 }

foreach ($id in @($x4)) {
    $from = "$icon\x4\$id.png"
    foreach ($z in @(@('x2', $x2, 0.5), @('x3', $x3, 0.75))) {
        if ($z[1].Contains($id)) { continue }
        $s = Get-Size $from
        if ($s[0] -le 2 -and $s[1] -le 2) { $done.boqua++; continue }
        $done[$z[0]]++
        if (-not $Preview) {
            $w = [Math]::Max(1, [int][Math]::Round($s[0] * $z[2], [MidpointRounding]::AwayFromZero))
            $h = [Math]::Max(1, [int][Math]::Round($s[1] * $z[2], [MidpointRounding]::AwayFromZero))
            Save-Scaled $from "$icon\$($z[0])\$id.png" $w $h
        }
    }
}

foreach ($id in @($x2)) {
    if ($x4.Contains($id)) { continue }
    $s = Get-Size "$icon\x2\$id.png"
    if ($s[0] -le 2 -and $s[1] -le 2) { $done.boqua++; continue }
    $done.x4++
    if (-not $Preview) {
        if (-not $x3.Contains($id)) { throw "Thieu ca x3 cua $id" }
        Save-Scaled "$icon\x3\$id.png" "$icon\x4\$id.png" ($s[0] * 2) ($s[1] * 2)
    }
}

if (-not $Preview) { $x2 = Get-Ids "$icon\x2" }
$webIds = Get-Ids $web
foreach ($id in @($x2)) {
    if ($webIds.Contains($id)) { continue }
    $done.web++
    if (-not $Preview) { Copy-Item -LiteralPath "$icon\x2\$id.png" -Destination "$web\$id.png" }
}

$label = if ($Preview) { 'Se tao' } else { 'Da tao' }
"$label x2=$($done.x2) x3=$($done.x3) x4=$($done.x4), web/icon=$($done.web), bo qua anh giu cho=$($done.boqua)"
