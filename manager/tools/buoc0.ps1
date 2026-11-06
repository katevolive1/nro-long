# BÆ°á»›c 0: dá»±ng thá»­ slot 1 tá»« client gá»‘c báº±ng hard link, Ä‘á»•i tÃªn cÃ´ng ty Ä‘á»ƒ cÃ³ RMS riÃªng
param([string]$Goc = 'F:\nr-long', [string]$Slot = 'F:\AILinhTinh\nro-long\manager\slots\1', [int]$Num = 1)
$ErrorActionPreference = 'Stop'
$cty = 'NROSLOT{0:D7}' -f $Num
if (Test-Path $Slot) { Remove-Item $Slot -Recurse -Force }
New-Item -ItemType Directory $Slot | Out-Null
$n = 0
Get-ChildItem $Goc -Recurse -File | Where-Object { $_.Name -notlike 'GameAssembly.dll.truoc-*' } | ForEach-Object {
  $rel = $_.FullName.Substring($Goc.Length).TrimStart('\')
  $dst = Join-Path $Slot $rel
  New-Item -ItemType Directory (Split-Path $dst) -Force | Out-Null
  if ($rel -in 'DragonBoy_Data\globalgamemanagers','DragonBoy_Data\app.info') {
    $b = [IO.File]::ReadAllBytes($_.FullName)
    $s = [Text.Encoding]::ASCII.GetBytes('DefaultCompany'); $t = [Text.Encoding]::ASCII.GetBytes($cty)
    $hit = 0
    for ($i = 0; $i -le $b.Length - $s.Length; $i++) {
      if ($b[$i] -eq $s[0]) { $ok = $true; for ($j = 1; $j -lt $s.Length; $j++) { if ($b[$i+$j] -ne $s[$j]) { $ok = $false; break } }
        if ($ok) { [Array]::Copy($t, 0, $b, $i, $t.Length); $hit++ } }
    }
    [IO.File]::WriteAllBytes($dst, $b); "$rel : $hit lan thay"
  } else { New-Item -ItemType HardLink -Path $dst -Target $_.FullName | Out-Null; $n++ }
}
"hard link: $n file, cong ty = $cty"

