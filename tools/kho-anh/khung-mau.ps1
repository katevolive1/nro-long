# Tao khung mau nen xanh #00FF00 tu cac anh part x4 de dua Gemini ve lai (xem ANH.md muc "Cai trang moi bang Gemini").
#   .\khung-mau.ps1 -Ids (13179..13194) -Cols 4 -Out ..\..\kho-anh\<ten>\2-than.png
param([int[]]$Ids, [int]$Cols, [string]$Out, [int]$Scale = 2, [string]$Dir = (Join-Path $PSScriptRoot '..\..\Teamobi2026\data\icon\x4'))
Add-Type -AssemblyName System.Drawing
$imgs = $Ids | ForEach-Object { [System.Drawing.Image]::FromFile((Join-Path $Dir "$_.png")) }
$m = 0; foreach ($im in $imgs) { $m = [Math]::Max($m, [Math]::Max($im.Width, $im.Height)) }
[int]$cell = $m * $Scale + 32
[int]$rows = [Math]::Ceiling($imgs.Count / $Cols)
$bmp = New-Object System.Drawing.Bitmap ([int]($cell * $Cols)), ([int]($cell * $rows))
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::FromArgb(0, 255, 0))
$g.InterpolationMode = 'HighQualityBicubic'
$pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(0, 160, 0)), 2
for ($i = 0; $i -lt $imgs.Count; $i++) {
    $c = $i % $Cols; $r = [Math]::Floor($i / $Cols); $im = $imgs[$i]
    $w = $im.Width * $Scale; $h = $im.Height * $Scale
    $g.DrawImage($im, [int]($c * $cell + ($cell - $w) / 2), [int]($r * $cell + ($cell - $h) / 2), $w, $h)
    $g.DrawRectangle($pen, $c * $cell, $r * $cell, $cell - 1, $cell - 1)
}
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
"$Out cell=$cell cols=$Cols rows=$rows"
$imgs | ForEach-Object { $_.Dispose() }; $g.Dispose(); $bmp.Dispose()
