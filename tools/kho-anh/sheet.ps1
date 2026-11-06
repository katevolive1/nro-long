# Ghép nhiều icon thành 1 ảnh có nhãn ID, để xem 1 lần thay vì mở từng file.
# Xem dải ID:      .\sheet.ps1 -From 17000 -To 17199
# Xem danh sách:   .\sheet.ps1 -Ids 100,1000,14514 -Out thu.png
# So sánh các bộ:  .\sheet.ps1 -Compare -Ids 1000,14514 -Sets @{cur='...\data\icon\x4'; tumlum='...'}
# Ảnh ra nằm ở kho-anh\sheets (gitignore).
param(
    [int]$From = -1,
    [int]$To = -1,
    [int[]]$Ids = @(),
    [string]$Dir = '',
    [string]$Out = '',
    [int]$Cols = 20,
    [int]$Cell = 72,
    [switch]$Compare,
    [hashtable]$Sets = @{},
    [string[]]$Order = @()
)
Add-Type -AssemblyName System.Drawing
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
if ($Dir -eq '') { $Dir = Join-Path $root 'kho-anh\hop-nhat' }
$sheetDir = Join-Path $root 'kho-anh\sheets'
New-Item -ItemType Directory -Force -Path $sheetDir | Out-Null
if ($From -ge 0) { $Ids = $From..$To }
if ($Ids.Count -eq 0) { throw 'Can -From/-To hoac -Ids' }
if ($Order.Count -eq 0) { $Order = @($Sets.Keys | Sort-Object) }
if ($Out -eq '') { $Out = "sheet-$($Ids[0])-$($Ids[-1]).png" }
if (-not [IO.Path]::IsPathRooted($Out)) { $Out = Join-Path $sheetDir $Out }

$label = 14
$font = New-Object System.Drawing.Font('Arial', 8)
$black = [System.Drawing.Brushes]::Black
$backColor = [System.Drawing.Color]::FromArgb(205, 215, 228)

function Draw-Icon($g, [string]$path, [int]$x, [int]$y, [int]$size) {
    if (-not (Test-Path -LiteralPath $path)) { return $false }
    $img = [System.Drawing.Image]::FromFile($path)
    try {
        $scale = [Math]::Min(1.0, [Math]::Min($size / $img.Width, $size / $img.Height))
        $w = [Math]::Max(1, [int]($img.Width * $scale))
        $h = [Math]::Max(1, [int]($img.Height * $scale))
        $g.DrawImage($img, [int]($x + ($size - $w) / 2), [int]($y + ($size - $h) / 2), $w, $h)
    } finally { $img.Dispose() }
    return $true
}

if ($Compare) {
    $idWidth = 60
    $width = $idWidth + $Order.Count * ($Cell + 6)
    $height = $label + 4 + $Ids.Count * ($Cell + 6)
    $bmp = New-Object System.Drawing.Bitmap($width, $height)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear($backColor)
    $g.InterpolationMode = 'NearestNeighbor'
    for ($c = 0; $c -lt $Order.Count; $c++) { $g.DrawString($Order[$c], $font, $black, $idWidth + $c * ($Cell + 6), 2) }
    for ($r = 0; $r -lt $Ids.Count; $r++) {
        $y = $label + 4 + $r * ($Cell + 6)
        $g.DrawString("$($Ids[$r])", $font, $black, 2, $y + 30)
        for ($c = 0; $c -lt $Order.Count; $c++) {
            $null = Draw-Icon $g (Join-Path $Sets[$Order[$c]] "$($Ids[$r]).png") ($idWidth + $c * ($Cell + 6)) $y $Cell
        }
    }
} else {
    $rows = [Math]::Ceiling($Ids.Count / $Cols)
    $bmp = New-Object System.Drawing.Bitmap(($Cols * ($Cell + 4)), ($rows * ($Cell + $label + 4)))
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.Clear($backColor)
    $g.InterpolationMode = 'NearestNeighbor'
    for ($i = 0; $i -lt $Ids.Count; $i++) {
        $x = ($i % $Cols) * ($Cell + 4)
        $y = [Math]::Floor($i / $Cols) * ($Cell + $label + 4)
        if (Draw-Icon $g (Join-Path $Dir "$($Ids[$i]).png") $x $y $Cell) {
            $g.DrawString("$($Ids[$i])", $font, $black, $x, $y + $Cell)
        }
    }
}
$g.Dispose()
$bmp.Save($Out, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$font.Dispose()
"Da ghi $Out"
