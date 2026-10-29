# Chuyển client PC "Mod INT" sang đọc HP/KI kiểu long (ModFunc.isReadInt = false).
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch.ps1 "D:\nr-long\GameAssembly.dll"
param([Parameter(Mandatory = $true)][string]$Dll)

$md5Goc = '984E6FD75A748B1158C2330DD863BA8C'
$md5Long = 'BC2BD49AE412E904FF835FE83DFD40AC'
# Byte cuối của lệnh C6 41 12 01 (isReadInt = true) trong ModFunc..cctor của Game1 và Game2
$offsets = @(0x3E6298, 0x59D538)

$md5 = (Get-FileHash $Dll -Algorithm MD5).Hash
if ($md5 -eq $md5Long) { Write-Host 'File da la ban long, khong can sua.'; exit 0 }
if ($md5 -ne $md5Goc) { Write-Host "MD5 khong khop ban goc ($md5). Dung lai."; exit 1 }

$b = [IO.File]::ReadAllBytes($Dll)
foreach ($o in $offsets) {
    if ($b[$o - 3] -ne 0xC6 -or $b[$o] -ne 1) { Write-Host ('Byte tai 0x{0:X} khong dung. Dung lai.' -f $o); exit 1 }
}
Copy-Item $Dll "$Dll.int-backup" -Force
foreach ($o in $offsets) { $b[$o] = 0 }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua xong. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash). Ban cu: $Dll.int-backup"
