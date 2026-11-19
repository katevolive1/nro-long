# Cat sheet part do Gemini ve lai (tu khung mau nen xanh #00FF00) thanh anh part x2/x3/x4 + dx/dy moi.
# Khung mau tao bang luoi: o = max(w,h)*2+32 cua anh x4 goc, anh goc phong 2 lan dat giua o.
#   .\gemini-part.ps1 -Sheet ..\..\kho-anh\gamma\Gemini_Generated_GAMMA_Than.png -Part '[[13179,-1,-4],...]' -Cols 4 -Out ..\..\kho-anh\gamma\out\than
#   -Head: anh Gemini ve to/nho tuy y -> co theo chieu cao anh goc, can day va giua (dung cho dau).
# Ra: <Out>\x2|x3|x4\<idGoc>.png, <Out>\part.txt (idGoc newDx newDy), <Out>\so-sanh.png (goc | moi | chong).
param(
    [Parameter(Mandatory)][string]$Sheet,
    [Parameter(Mandatory)][string]$Part,
    [Parameter(Mandatory)][int]$Cols,
    [Parameter(Mandatory)][string]$Out,
    [switch]$Head,
    [string]$IconDir = (Join-Path $PSScriptRoot '..\..\Teamobi2026\data\icon\x4'),
    [int]$Margin = 14
)
Add-Type -AssemblyName System.Drawing
Add-Type -ReferencedAssemblies System.Drawing -TypeDefinition @'
using System; using System.Drawing; using System.Drawing.Imaging; using System.Collections.Generic; using System.Runtime.InteropServices;
public static class GemPart {
    // Xoa nen xanh trong 1 o, bo manh nho (watermark, vet ke), ghi vao dst (cung kich thuoc sheet). Tra ve bbox [x0,y0,x1,y1) hoac null.
    public static int[] KeyCell(Bitmap sheet, Bitmap dst, Rectangle cell, int margin) {
        int W = sheet.Width, H = sheet.Height;
        Rectangle r = new Rectangle(cell.X + margin, cell.Y + margin, cell.Width - 2 * margin, cell.Height - 2 * margin);
        BitmapData sd = sheet.LockBits(new Rectangle(0, 0, W, H), ImageLockMode.ReadOnly, PixelFormat.Format32bppArgb);
        int stride = sd.Stride; byte[] s = new byte[stride * H]; Marshal.Copy(sd.Scan0, s, 0, s.Length); sheet.UnlockBits(sd);
        int rw = r.Width, rh = r.Height, n = rw * rh;
        byte[] al = new byte[n]; byte[] px = new byte[n * 4];
        for (int y = 0; y < rh; y++) for (int x = 0; x < rw; x++) {
            int i = (r.Y + y) * stride + (r.X + x) * 4, j = y * rw + x;
            int b = s[i], g = s[i + 1], rr = s[i + 2], m = Math.Max(rr, b), d = g - m;
            int a = d >= 70 ? 0 : d <= 25 ? 255 : (int)(255 * (70 - d) / 45.0);
            if (d > 0) g = m;
            al[j] = (byte)a; px[j * 4] = (byte)b; px[j * 4 + 1] = (byte)g; px[j * 4 + 2] = (byte)rr;
        }
        int[] lab = new int[n]; for (int i = 0; i < n; i++) lab[i] = -1;
        List<int> area = new List<int>(); Stack<int> st = new Stack<int>();
        for (int i = 0; i < n; i++) {
            if (al[i] <= 64 || lab[i] >= 0) continue;
            int id = area.Count, cnt = 0; lab[i] = id; st.Push(i);
            while (st.Count > 0) {
                int p = st.Pop(); cnt++; int px0 = p % rw, py0 = p / rw;
                for (int dy = -1; dy <= 1; dy++) for (int dx = -1; dx <= 1; dx++) {
                    int qx = px0 + dx, qy = py0 + dy; if (qx < 0 || qy < 0 || qx >= rw || qy >= rh) continue;
                    int q = qy * rw + qx; if (al[q] > 64 && lab[q] < 0) { lab[q] = id; st.Push(q); }
                }
            }
            area.Add(cnt);
        }
        if (area.Count == 0) return null;
        int big = 0; foreach (int c in area) big = Math.Max(big, c);
        int min = Math.Max(50, big * 3 / 100);
        bool[] keep = new bool[n];
        for (int i = 0; i < n; i++) keep[i] = lab[i] >= 0 && area[lab[i]] >= min;
        // giu vien mo (alpha thap) sat manh duoc giu, ban kinh 2
        bool[] fin = new bool[n];
        for (int y = 0; y < rh; y++) for (int x = 0; x < rw; x++) {
            int j = y * rw + x; if (al[j] == 0) continue;
            if (keep[j]) { fin[j] = true; continue; }
            if (lab[j] >= 0) continue;
            for (int dy = -2; dy <= 2 && !fin[j]; dy++) for (int dx = -2; dx <= 2; dx++) {
                int qx = x + dx, qy = y + dy; if (qx < 0 || qy < 0 || qx >= rw || qy >= rh) continue;
                if (keep[qy * rw + qx]) { fin[j] = true; break; }
            }
        }
        BitmapData dd = dst.LockBits(new Rectangle(0, 0, W, H), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
        byte[] o = new byte[dd.Stride * H]; Marshal.Copy(dd.Scan0, o, 0, o.Length);
        int x0 = int.MaxValue, y0 = int.MaxValue, x1 = -1, y1 = -1;
        for (int y = 0; y < rh; y++) for (int x = 0; x < rw; x++) {
            int j = y * rw + x; if (!fin[j]) continue;
            int k = (r.Y + y) * dd.Stride + (r.X + x) * 4;
            o[k] = px[j * 4]; o[k + 1] = px[j * 4 + 1]; o[k + 2] = px[j * 4 + 2]; o[k + 3] = al[j];
            int sx = r.X + x, sy = r.Y + y;
            if (sx < x0) x0 = sx; if (sy < y0) y0 = sy; if (sx + 1 > x1) x1 = sx + 1; if (sy + 1 > y1) y1 = sy + 1;
        }
        Marshal.Copy(o, 0, dd.Scan0, o.Length); dst.UnlockBits(dd);
        return x1 < 0 ? null : new int[] { x0, y0, x1, y1 };
    }
}
'@

function Resize-Region($src, [double]$sx, [double]$sy, [double]$sw, [double]$sh, [int]$w, [int]$h) {
    $bmp = New-Object System.Drawing.Bitmap $w, $h, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = 'HighQualityBicubic'; $g.PixelOffsetMode = 'HighQuality'; $g.CompositingQuality = 'HighQuality'
    $ia = New-Object System.Drawing.Imaging.ImageAttributes; $ia.SetWrapMode('TileFlipXY')
    $g.DrawImage($src, (New-Object System.Drawing.Rectangle 0, 0, $w, $h), [float]$sx, [float]$sy, [float]$sw, [float]$sh, 'Pixel', $ia)
    $g.Dispose(); return $bmp
}

$frames = @((ConvertFrom-Json $Part) | Where-Object { $_[0] -ne 2954 -and $_[0] -ne 2955 })
$orig = @($frames | ForEach-Object { [System.Drawing.Image]::FromFile((Resolve-Path (Join-Path $IconDir "$($_[0]).png")).Path) })
$mx = 0; foreach ($im in $orig) { $mx = [Math]::Max($mx, [Math]::Max($im.Width, $im.Height)) }
[int]$tCell = $mx * 2 + 32
$rows = [int][Math]::Ceiling($frames.Count / $Cols)
$sheetBmp = [System.Drawing.Bitmap]::FromFile((Resolve-Path $Sheet).Path)
$keyed = New-Object System.Drawing.Bitmap $sheetBmp.Width, $sheetBmp.Height, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$F = $sheetBmp.Width / ($tCell * $Cols)
$cw = $sheetBmp.Width / $Cols; $ch = $sheetBmp.Height / $rows
foreach ($z in 2, 3, 4) { New-Item -ItemType Directory -Force (Join-Path $Out "x$z") | Out-Null }
$lines = @(); $res = @()
for ($i = 0; $i -lt $frames.Count; $i++) {
    $id = $frames[$i][0]; $w = $orig[$i].Width; $h = $orig[$i].Height
    $c = $i % $Cols; $r = [Math]::Floor($i / $Cols)
    $cell = New-Object System.Drawing.Rectangle ([int]($c * $cw)), ([int]($r * $ch)), ([int]$cw), ([int]$ch)
    $bb = [GemPart]::KeyCell($sheetBmp, $keyed, $cell, $Margin)
    if ($null -eq $bb) { Write-Warning "o $i ($id) trong"; continue }
    if ($Head) {
        $k = ($bb[3] - $bb[1]) / $h                       # px sheet tren 1 px x4
        $orgX = ($bb[0] + $bb[2]) / 2 - $w * $k / 2; $orgY = $bb[3] - $h * $k
    } else {
        $k = 2 * $F
        $orgX = ($c * $tCell + [int](($tCell - 2 * $w) / 2)) * $F; $orgY = ($r * $tCell + [int](($tCell - 2 * $h) / 2)) * $F
    }
    $u = 4 * $k                                           # px sheet tren 1 px x1
    $ox = [Math]::Floor(($bb[0] - $orgX) / $u); $oy = [Math]::Floor(($bb[1] - $orgY) / $u)
    $ex = [Math]::Ceiling(($bb[2] - $orgX) / $u); $ey = [Math]::Ceiling(($bb[3] - $orgY) / $u)
    $W1 = [int]($ex - $ox); $H1 = [int]($ey - $oy)
    Write-Verbose "$id cell=$cell bb=$($bb -join ',') O=$orgX,$orgY k=$k o=$ox,$oy size=$W1 x $H1"
    foreach ($z in 2, 3, 4) {
        $b = Resize-Region $keyed ($orgX + $ox * $u) ($orgY + $oy * $u) ($W1 * $u) ($H1 * $u) ($W1 * $z) ($H1 * $z)
        $b.Save((Join-Path $Out "x$z\$id.png"), [System.Drawing.Imaging.ImageFormat]::Png); $b.Dispose()
    }
    $ndx = $frames[$i][1] + $ox; $ndy = $frames[$i][2] + $oy
    $lines += "$id $ndx $ndy"
    $res += , @($i, $id, [int]$frames[$i][1], [int]$frames[$i][2], [int]$ndx, [int]$ndy)
}
$lines | Set-Content -Encoding ascii (Join-Path $Out 'part.txt')

# So sanh: moi khung 3 o (goc | moi | chong), cung goc toa do x1 -> x4
$pad = 24; $cellW = $tCell; $cmp = New-Object System.Drawing.Bitmap ($cellW * 3 * [Math]::Min($Cols, $res.Count)), ($cellW * $rows)
$g = [System.Drawing.Graphics]::FromImage($cmp); $g.Clear([System.Drawing.Color]::FromArgb(200, 210, 225))
$cm = New-Object System.Drawing.Imaging.ColorMatrix; $cm.Matrix33 = 0.45
$half = New-Object System.Drawing.Imaging.ImageAttributes; $half.SetColorMatrix($cm)
foreach ($e in $res) {
    $i = $e[0]; $c = $i % $Cols; $r = [Math]::Floor($i / $Cols)
    $old = $orig[$i]; $new = [System.Drawing.Image]::FromFile((Resolve-Path (Join-Path $Out "x4\$($e[1]).png")).Path)
    $bx = [Math]::Min($e[2], $e[4]) * 4; $by = [Math]::Min($e[3], $e[5]) * 4
    for ($p = 0; $p -lt 3; $p++) {
        $x0 = ($c * 3 + $p) * $cellW + $pad - $bx; $y0 = $r * $cellW + $pad - $by
        if ($p -ne 1) { $g.DrawImage($old, $x0 + $e[2] * 4, $y0 + $e[3] * 4, $old.Width, $old.Height) }
        if ($p -eq 1) { $g.DrawImage($new, $x0 + $e[4] * 4, $y0 + $e[5] * 4, $new.Width, $new.Height) }
        if ($p -eq 2) { $g.DrawImage($new, (New-Object System.Drawing.Rectangle ($x0 + $e[4] * 4), ($y0 + $e[5] * 4), $new.Width, $new.Height), 0, 0, $new.Width, $new.Height, 'Pixel', $half) }
    }
    $new.Dispose()
}
$cmp.Save((Join-Path $Out 'so-sanh.png'), [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $cmp.Dispose(); $keyed.Dispose(); $sheetBmp.Dispose(); $orig | ForEach-Object { $_.Dispose() }
"Xong $($res.Count)/$($frames.Count) khung -> $Out"
