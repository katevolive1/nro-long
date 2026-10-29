# Chuyển client PC "Mod INT" sang đọc HP/KI kiểu long.
# Cách dùng: powershell -ExecutionPolicy Bypass -File patch.ps1 "D:\nr-long\GameAssembly.dll"
# Chạy lại nhiều lần không sao (chỉ sửa byte còn ở trạng thái gốc).
param([Parameter(Mandatory = $true)][string]$Dll)

# Mỗi mục: offset file, byte gốc, byte mới, byte kiểm tra (offset, giá trị) để chắc đúng chỗ
$patches = @(
    # ModFunc..cctor: C6 41 12 01 (isReadInt = true) -> 00. Game1, Game2
    @{ Off = 0x3E6298; Old = 0x01; New = 0x00; CheckOff = 0x3E6295; Check = 0xC6 },
    @{ Off = 0x59D538; Old = 0x01; New = 0x00; CheckOff = 0x59D535; Check = 0xC6 },
    # myReader.ReadParamDQT: khi isReadInt = false nó đọc param option 4 byte, server gửi 2 byte.
    # Đổi jne (75 3C) thành jmp (EB 3C) để luôn đọc 2 byte. Game1 (RVA 0x4043E6), Game2 (RVA 0x1D0D16)
    @{ Off = 0x402BE6; Old = 0x75; New = 0xEB; CheckOff = 0x402BE7; Check = 0x3C },
    @{ Off = 0x1CF516; Old = 0x75; New = 0xEB; CheckOff = 0x1CF517; Check = 0x3C }
)

$b = [IO.File]::ReadAllBytes($Dll)
$changed = 0
foreach ($p in $patches) {
    if ($b[$p.CheckOff] -ne $p.Check -or ($b[$p.Off] -ne $p.Old -and $b[$p.Off] -ne $p.New)) {
        Write-Host ('Byte tai 0x{0:X} khong dung. Dung lai.' -f $p.Off); exit 1
    }
    if ($b[$p.Off] -eq $p.Old) { $b[$p.Off] = $p.New; $changed++ }
}
if ($changed -eq 0) { Write-Host 'File da la ban long day du, khong can sua.'; exit 0 }
if (-not (Test-Path "$Dll.int-backup")) { Copy-Item $Dll "$Dll.int-backup" }
[IO.File]::WriteAllBytes($Dll, $b)
Write-Host "Da sua $changed cho. MD5 moi: $((Get-FileHash $Dll -Algorithm MD5).Hash)"
