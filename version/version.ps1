# Version server (xem version/VERSION.md).
#   chot <N>       : xuất dữ liệu game trong DB ra version/vN.sql (sau đó user commit + git tag vN).
#   doi <N | moi>  : git checkout tag vN (hoặc main), nạp dữ liệu game của bản đó vào DB, đưa nhân vật đứng ở map
#                    không có trong bản đó về nhà, rồi build. Dữ liệu người chơi không đổi theo version.
# Gọi qua version\chot-version.bat / version\doi-version.bat (bat chép file này ra %TEMP% rồi chạy, vì git checkout đổi file trong repo).
param(
    [Parameter(Mandatory = $true)][ValidateSet('chot', 'doi')][string]$Lenh,
    [Parameter(Mandatory = $true)][string]$Ban,
    [Parameter(Mandatory = $true)][string]$Repo
)
$ErrorActionPreference = 'Stop'

$mysqlBin = 'C:\xampp\mysql\bin'
$db = 'team10_long'
# Bảng dữ liệu game (đi theo version). Bảng người chơi, bang hội, web, nạp tiền, ký gửi, xếp hạng không theo version.
$bang = @(
    'achievement_template', 'array_head_2_frames', 'bg_item_template', 'clan_task_template', 'data_badges', 'flag_bag',
    'giftcode', 'head_avatar', 'img_by_name', 'intrinsic', 'item_option_template', 'item_shop', 'item_shop_option',
    'item_template', 'map_template', 'mob_template', 'npc_template', 'part', 'radar', 'shop', 'tab_shop',
    'side_task_template', 'skill_template', 'task_badges_template', 'task_main_template', 'task_sub_template'
)
$dir = Join-Path $Repo 'version'
$dangChay = Join-Path $dir '.dang-chay'      # bản đang chạy trên máy này ("moi" hoặc số), git bỏ qua
$saoLuu = Join-Path $dir '_dang-dung.sql'    # dữ liệu game của bản mới nhất, lưu lúc chuyển về bản cũ, git bỏ qua

function XuatDuLieu([string]$file) {
    & "$mysqlBin\mysqldump.exe" -u root --default-character-set=utf8mb4 --skip-dump-date --skip-extended-insert --skip-comments "--result-file=$file" $db @bang
    if ($LASTEXITCODE) { throw 'mysqldump loi (MySQL trong XAMPP da bat chua?)' }
}
function ChayFileSql([string]$file) {
    cmd /c "`"$mysqlBin\mysql.exe`" -u root --default-character-set=utf8mb4 $db < `"$file`""
    if ($LASTEXITCODE) { throw "Nap $file loi" }
}
# không đặt tên hàm là "Git": PowerShell không phân biệt hoa thường, mọi lệnh git trong file sẽ gọi đệ quy vào hàm
function ChayGit {
    & git.exe -C $Repo @args
    if ($LASTEXITCODE) { throw "git $args loi" }
}

if ($Lenh -eq 'chot') {
    if ($Ban -notmatch '^\d+$') { throw 'So version phai la so, vd: chot-version.bat 2' }
    if (& git -C $Repo tag -l "v$Ban") { Write-Host "Canh bao: tag v$Ban da co, se chi xuat lai version\v$Ban.sql." }
    XuatDuLieu (Join-Path $dir "v$Ban.sql")
    Write-Host ""
    Write-Host "Da xuat du lieu game ra version\v$Ban.sql. Tiep theo:"
    Write-Host "  1. Ghi mo ta v$Ban vao version\VERSION.md"
    Write-Host "  2. Commit tat ca thay doi"
    Write-Host "  3. git tag v$Ban"
    Write-Host "  4. git push origin main v$Ban"
    exit 0
}

# ---- doi ----
if ($Ban -ne 'moi' -and $Ban -notmatch '^\d+$') { throw 'Cach dung: doi-version.bat <so version | moi>' }
if (Get-NetTCPConnection -LocalPort 14446 -State Listen -ErrorAction SilentlyContinue) {
    throw 'Server dang chay (port 14446). Dong cua so run.bat roi chay lai.'
}
if (& git -C $Repo status --porcelain --untracked-files=no) {
    throw 'Repo con thay doi chua commit. Commit (o ban moi nhat) truoc roi moi doi version.'
}
$hien = 'moi'
if (Test-Path $dangChay) { $hien = (Get-Content $dangChay -Raw).Trim() }
if ($hien -eq $Ban) { Write-Host "Dang chay ban $Ban roi."; exit 0 }

if ($Ban -eq 'moi') {
    ChayGit checkout -q main
    if (Test-Path $saoLuu) { ChayFileSql $saoLuu } else { Write-Host 'Khong co version\_dang-dung.sql, giu nguyen du lieu game trong DB.' }
} else {
    & git -C $Repo rev-parse -q --verify "refs/tags/v$Ban" | Out-Null
    if ($LASTEXITCODE) { throw "Chua co version v$Ban (thu: git fetch --tags)." }
    if ($hien -eq 'moi') { XuatDuLieu $saoLuu }   # giữ dữ liệu game của bản mới nhất để lúc về "moi" nạp lại
    ChayGit checkout -q "v$Ban"
    ChayFileSql (Join-Path $dir "v$Ban.sql")
}

# Nhân vật đứng ở map không có trong bản này: về nhà (như MrBlue khi vào map đặc biệt)
$sqlViTri = Join-Path $env:TEMP 'nro-version-vitri.sql'
Set-Content -Path $sqlViTri -Encoding ASCII -Value 'UPDATE player SET data_location = CONCAT(''['', gender + 21, '',300,336]'') WHERE CAST(JSON_VALUE(data_location, ''$[0]'') AS SIGNED) NOT IN (SELECT id FROM map_template);'
ChayFileSql $sqlViTri

Set-Content -Path $dangChay -Encoding ASCII -Value $Ban
Write-Host ""
Write-Host "Da chuyen sang ban $Ban. Dang build..."
cmd /c "`"$Repo\Teamobi2026\build.bat`""
Write-Host "Xong. Bat server bang run.bat (no tu thay jar moi)."
if ($Ban -ne 'moi') { Write-Host "Dang o ban cu: dung sua code/commit. Muon sua thi ve ban moi nhat: doi-version.bat moi" }
