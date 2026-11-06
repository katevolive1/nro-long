# Thử dựng + mở 1 slot, chờ, báo còn chạy hay đã crash, rồi đóng (kiểm tra tự đăng nhập: xem account.last_time_login trên server). Chỉ đóng đúng PID mình mở.
# Cách dùng: powershell -ExecutionPolicy Bypass -File thu-slot.ps1 -TuDangNhap 1 -Cho 30
param([int]$Id = 1, [int]$TuDangNhap = 1, [int]$Cho = 30, [string]$User = '', [string]$Pass = '', [int]$CoW = 0, [int]$CoH = 0)
$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$asm = [Reflection.Assembly]::LoadFrom("$root\NroManager.exe")
$SB = $asm.GetType('NroManager.SlotBuilder'); $tAcc = $asm.GetType('NroManager.Acc'); $tCfg = $asm.GetType('NroManager.Config')
$cfg = $tCfg.GetMethod('Load').Invoke($null, $null)
$tCfg.GetField('SlotsDir').SetValue($cfg, "$root\slots"); $tCfg.GetField('TuDangNhap').SetValue($cfg, [bool]$TuDangNhap)
if ($User -eq '') {   # lấy tài khoản đầu tiên trong accManager của client gốc
    $goc = $tCfg.GetField('GocDir').GetValue($cfg); $app = (Get-Content "$goc\DragonBoy_Data\app.info" -Raw) -split "`n"
    $s = $SB.GetMethod('ReadRmsString').Invoke($null, @(($SB.GetMethod('RmsDirOf').Invoke($null, @($app[0].Trim(), $app[1].Trim())) + '\accManager')))
    $e = ($s -split '\|')[0]; $i = $e.IndexOf('$'); $User = $e.Substring(0, $i); $Pass = $e.Substring($i + 1)
}
$a = [Activator]::CreateInstance($tAcc); $tAcc.GetField('Id').SetValue($a, $Id); $tAcc.GetField('User').SetValue($a, $User); $tAcc.GetField('Pass').SetValue($a, $Pass)
"tai khoan: $User, tu dang nhap: $TuDangNhap"
try { $info = $SB.GetMethod('Prepare').Invoke($null, @($a, $cfg, $false, [Action[string]]{ param($m) Write-Host "LOG: $m" })) } catch { throw $_.Exception.InnerException }
$d = $info.GetType().GetField('SlotDir').GetValue($info); $x = $info.GetType().GetField('Exe').GetValue($info); $r = $info.GetType().GetField('RmsDir').GetValue($info)
$p = Start-Process "$d\$x" -WorkingDirectory $d -PassThru
"PID $($p.Id)"
Start-Sleep $Cho
$p.Refresh()
if ($p.HasExited) { "CUA SO DA TAT sau <= $Cho giay (exit $($p.ExitCode))"; Select-String -Path "$r\Player.log" -Pattern 'Crash!!!|NullReference|Exception' | Select -First 5 | ForEach-Object { $_.Line.Substring(0, [Math]::Min(150, $_.Line.Length)) }; exit 2 }
"DANG CHAY sau $Cho giay"
if ($CoW -gt 0) {   # thử đổi cỡ vùng hiển thị bằng SetWindowPos rồi đo lại sau vài giây
    Add-Type -TypeDefinition 'using System;using System.Runtime.InteropServices;public struct RC4{public int L,T,R,B;}public class W4{[DllImport("user32.dll")]public static extern bool GetWindowRect(IntPtr h,out RC4 r);[DllImport("user32.dll")]public static extern bool GetClientRect(IntPtr h,out RC4 r);[DllImport("user32.dll")]public static extern bool SetWindowPos(IntPtr h,IntPtr a,int x,int y,int cx,int cy,uint f);}'
    $p.Refresh(); $h = $p.MainWindowHandle; $w = New-Object RC4; $c = New-Object RC4
    [W4]::GetWindowRect($h, [ref]$w) | Out-Null; [W4]::GetClientRect($h, [ref]$c) | Out-Null
    "truoc: client $($c.R)x$($c.B)"
    $dx = ($w.R - $w.L) - $c.R; $dy = ($w.B - $w.T) - $c.B
    [W4]::SetWindowPos($h, [IntPtr]::Zero, $w.L, $w.T, $CoW + $dx, $CoH + $dy, 4) | Out-Null
    Start-Sleep 2; [W4]::GetClientRect($h, [ref]$c) | Out-Null; "sau 2s: client $($c.R)x$($c.B)"
    Start-Sleep 4; [W4]::GetClientRect($h, [ref]$c) | Out-Null; "sau 6s: client $($c.R)x$($c.B)"
    Select-String -Path "$r\Player.log" -Pattern 'setsizeChange|Screen|resolution' | Select -Last 3 | ForEach-Object { $_.Line.Substring(0, [Math]::Min(150, $_.Line.Length)) }
}
Get-NetTCPConnection -OwningProcess $p.Id -ErrorAction SilentlyContinue | Select LocalPort, RemoteAddress, RemotePort, State | Format-Table | Out-String
$p.CloseMainWindow() | Out-Null; Start-Sleep 3; if (-not $p.HasExited) { $p.Kill() }
"da dong PID $($p.Id)"

