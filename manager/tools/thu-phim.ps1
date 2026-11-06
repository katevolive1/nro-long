# Thử gửi phím vào cửa sổ game (PostMessage, cửa sổ không cần được chọn): mở slot, chờ vào game, chụp riêng cửa sổ game
# (PrintWindow, không chụp màn hình), gửi phím, chụp lại, đóng đúng PID đã mở. So data_location trong DB trước/sau.
# Cách dùng: powershell -ExecutionPolicy Bypass -File thu-phim.ps1 -Phim l -Cho 25 -Anh C:\tmp
param([string]$Phim = 'l', [int]$Cho = 25, [string]$Anh = $env:TEMP, [int]$Id = 1, [string]$Exe = 'NroManager.exe')
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$asm = [Reflection.Assembly]::LoadFrom("$root\$Exe")
$SB = $asm.GetType('NroManager.SlotBuilder'); $tAcc = $asm.GetType('NroManager.Acc'); $tCfg = $asm.GetType('NroManager.Config')
$cfg = $tCfg.GetMethod('Load').Invoke($null, $null)
$tCfg.GetField('SlotsDir').SetValue($cfg, "$root\slots")
$goc = $tCfg.GetField('GocDir').GetValue($cfg); $app = (Get-Content "$goc\DragonBoy_Data\app.info" -Raw) -split "`n"
$s = $SB.GetMethod('ReadRmsString').Invoke($null, @(($SB.GetMethod('RmsDirOf').Invoke($null, @($app[0].Trim(), $app[1].Trim())) + '\accManager')))
$e = ($s -split '\|')[0]; $i = $e.IndexOf('$'); $User = $e.Substring(0, $i)
$a = [Activator]::CreateInstance($tAcc); $tAcc.GetField('Id').SetValue($a, $Id); $tAcc.GetField('User').SetValue($a, $User); $tAcc.GetField('Pass').SetValue($a, $e.Substring($i + 1))
function Loc { & 'C:\xampp\mysql\bin\mysql.exe' -uroot team10_long -N -e "SELECT p.data_location FROM player p JOIN account a ON a.id=p.account_id WHERE a.username='$User'" }
"tai khoan $User, vi tri truoc: $(Loc)"
$info = $SB.GetMethod('Prepare').Invoke($null, @($a, $cfg, $false, [Action[string]]{ param($m) Write-Host "LOG: $m" }))
$d = $info.GetType().GetField('SlotDir').GetValue($info); $x = $info.GetType().GetField('Exe').GetValue($info)

Add-Type -AssemblyName System.Drawing
Add-Type -TypeDefinition @'
using System; using System.Runtime.InteropServices;
public struct RC5 { public int L, T, R, B; }
public static class W5 {
  [DllImport("user32.dll")] public static extern bool GetWindowRect(IntPtr h, out RC5 r);
  [DllImport("user32.dll")] public static extern bool PrintWindow(IntPtr h, IntPtr hdc, uint f);
  [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr h, uint m, IntPtr w, IntPtr l);
  [DllImport("user32.dll")] public static extern uint MapVirtualKey(uint code, uint type);
}
'@
function Shot($h, $file) {
  $r = New-Object RC5; [W5]::GetWindowRect($h, [ref]$r) | Out-Null
  $bmp = New-Object Drawing.Bitmap ($r.R - $r.L), ($r.B - $r.T)
  $g = [Drawing.Graphics]::FromImage($bmp); $hdc = $g.GetHdc(); [W5]::PrintWindow($h, $hdc, 2) | Out-Null; $g.ReleaseHdc($hdc); $g.Dispose()
  $bmp.Save($file); $bmp.Dispose()
}
function Key($h, [char]$c) {
  $vk = [uint32][char]::ToUpper($c); $sc = [W5]::MapVirtualKey($vk, 0)
  [W5]::PostMessage($h, 0x100, [IntPtr]$vk, [IntPtr](1 -bor ($sc -shl 16))) | Out-Null          # WM_KEYDOWN
  [W5]::PostMessage($h, 0x102, [IntPtr][int]$c, [IntPtr](1 -bor ($sc -shl 16))) | Out-Null       # WM_CHAR
  Start-Sleep -Milliseconds 80
  [W5]::PostMessage($h, 0x101, [IntPtr]$vk, [IntPtr]([int64]0xC0000001 -bor ($sc -shl 16))) | Out-Null  # WM_KEYUP
}

$p = Start-Process "$d\$x" -WorkingDirectory $d -PassThru
"PID $($p.Id)"
Start-Sleep $Cho
$p.Refresh(); if ($p.HasExited) { 'CUA SO DA TAT'; exit 2 }
$h = $p.MainWindowHandle
Shot $h "$Anh\phim-truoc.png"
foreach ($c in $Phim.ToCharArray()) { Key $h $c; Start-Sleep -Milliseconds 300 }
Start-Sleep 5
Shot $h "$Anh\phim-sau.png"
$p.CloseMainWindow() | Out-Null; Start-Sleep 4; if (-not $p.HasExited) { $p.Kill() }
Start-Sleep 2
"da dong PID $($p.Id), vi tri sau: $(Loc)"
