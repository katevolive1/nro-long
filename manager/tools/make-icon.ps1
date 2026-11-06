# Tạo manager\app.ico: nền đỏ bo góc, chữ trắng "hnam" (nhiều cỡ 16..256, ảnh PNG trong file .ico).
# Cách dùng: powershell -ExecutionPolicy Bypass -File make-icon.ps1   (build.bat nhúng app.ico vào NroManager.exe)
param([string]$Text = 'hnam', [string]$Out = (Join-Path (Split-Path $PSScriptRoot -Parent) 'app.ico'))
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

function Draw([int]$s) {
    $bmp = New-Object Drawing.Bitmap $s, $s, ([Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode = 'AntiAlias'; $g.TextRenderingHint = 'AntiAliasGridFit'; $g.Clear([Drawing.Color]::Transparent)
    $r = [Math]::Max(2, [int]($s * 0.18)); $d = 2 * $r; $w = $s - 1
    $bg = New-Object Drawing.Drawing2D.GraphicsPath
    $bg.AddArc(0, 0, $d, $d, 180, 90); $bg.AddArc($w - $d, 0, $d, $d, 270, 90)
    $bg.AddArc($w - $d, $w - $d, $d, $d, 0, 90); $bg.AddArc(0, $w - $d, $d, $d, 90, 90); $bg.CloseFigure()
    $g.FillPath((New-Object Drawing.SolidBrush ([Drawing.Color]::FromArgb(211, 32, 39))), $bg)
    # chữ: dựng bằng GraphicsPath rồi co cho vừa 86% chiều ngang
    $tp = New-Object Drawing.Drawing2D.GraphicsPath
    $fam = New-Object Drawing.FontFamily 'Segoe UI'
    $tp.AddString($Text, $fam, [int][Drawing.FontStyle]::Bold, 100, (New-Object Drawing.PointF 0, 0), [Drawing.StringFormat]::GenericTypographic)
    $b = $tp.GetBounds()
    $k = ($s * 0.86) / $b.Width
    if ($b.Height * $k -gt $s * 0.7) { $k = ($s * 0.7) / $b.Height }
    $m = New-Object Drawing.Drawing2D.Matrix
    $m.Translate(($s - $b.Width * $k) / 2, ($s - $b.Height * $k) / 2)
    $m.Scale($k, $k); $m.Translate(-$b.X, -$b.Y)
    $tp.Transform($m)
    $g.FillPath([Drawing.Brushes]::White, $tp)
    $g.Dispose()
    $ms = New-Object IO.MemoryStream; $bmp.Save($ms, [Drawing.Imaging.ImageFormat]::Png); $bmp.Dispose()
    return ,$ms.ToArray()
}

$sizes = 16, 24, 32, 48, 64, 128, 256
$imgs = @(); foreach ($s in $sizes) { $imgs += ,(Draw $s) }
$o = New-Object IO.MemoryStream; $bw = New-Object IO.BinaryWriter $o
$bw.Write([UInt16]0); $bw.Write([UInt16]1); $bw.Write([UInt16]$sizes.Count)
$off = 6 + 16 * $sizes.Count
for ($i = 0; $i -lt $sizes.Count; $i++) {
    $s = $sizes[$i]; $wb = if ($s -ge 256) { 0 } else { $s }
    $bw.Write([byte]$wb); $bw.Write([byte]$wb); $bw.Write([byte]0); $bw.Write([byte]0)
    $bw.Write([UInt16]1); $bw.Write([UInt16]32); $bw.Write([UInt32]$imgs[$i].Length); $bw.Write([UInt32]$off)
    $off += $imgs[$i].Length
}
foreach ($im in $imgs) { $bw.Write($im) }
[IO.File]::WriteAllBytes($Out, $o.ToArray())
"Da tao $Out ($($o.Length) byte)"
# ảnh xem thử (ngoài repo)
[IO.File]::WriteAllBytes((Join-Path $env:TEMP 'nro-manager-icon.png'), (Draw 256))
