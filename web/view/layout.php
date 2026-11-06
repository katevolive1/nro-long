<?php
// Khung chung của web công khai: <head>, thanh menu, chân trang.
// Mỗi trang: require 'view/layout.php' trước mọi output, rồi site_head(...) ... site_foot().
// Trang admin không dùng file này. CSS ở view/static/css/site.css, đổi CSS thì tăng SITE_ASSET_VER.
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
require_once __DIR__ . '/../connect.php';

const SITE_NAME = 'Chú Bé Rồng Online';
const SITE_ASSET_VER = '1';

function site_e($text): string
{
    return htmlspecialchars((string)$text, ENT_QUOTES, 'UTF-8');
}

function site_client_url(): string
{
    return '/download/NRO-long.rar?v=' . (int)@filemtime(dirname(__DIR__) . '/download/NRO-long.rar');
}

function site_zalo_url(): string
{
    return $GLOBALS['box_zalo_url'] ?? '#';
}

function site_head(string $title, string $active = '', string $description = ''): void
{
    $links = [
        'home'  => ['/index.php', 'Trang chủ'],
        'intro' => ['/gioi-thieu.php', 'Giới thiệu'],
        'forum' => ['/forum.php', 'Diễn đàn'],
        'rank'  => ['/bxh01.php', 'Bảng xếp hạng'],
    ];
    $user = $_SESSION['username'] ?? ($_SESSION['user'] ?? '');
    $isAdmin = (int)($_SESSION['is_admin'] ?? 0) === 1;
    if ($description === '') {
        $description = 'Trang chủ ' . SITE_NAME . ': game nhập vai trực tuyến về 7 viên Ngọc Rồng, tải bản PC và chơi miễn phí.';
    }
    ?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= site_e($title) ?> | <?= SITE_NAME ?></title>
    <meta name="description" content="<?= site_e($description) ?>">
    <meta name="theme-color" content="#13294b">
    <link rel="icon" href="/favicon.ico?v=3" type="image/x-icon">
    <link rel="icon" type="image/png" href="/favicon-32x32.png?v=3" sizes="32x32">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@600;800&family=Be+Vietnam+Pro:wght@400;500;700&display=swap">
    <link rel="stylesheet" href="/view/static/css/site.css?v=<?= SITE_ASSET_VER ?>">
    <script src="/view/static/js/site.js?v=<?= SITE_ASSET_VER ?>" defer></script>
</head>
<body>
<a class="skip-link" href="#noi-dung">Bỏ qua menu</a>
<header class="site-header">
    <div class="wrap site-header__row">
        <a class="site-logo" href="/index.php" aria-label="<?= SITE_NAME ?>, về trang chủ">
            <img src="/images/logo-nho.png" alt="<?= SITE_NAME ?>" width="110" height="53">
        </a>
        <button class="nav-toggle" type="button" aria-expanded="false" aria-controls="site-nav">Menu</button>
        <nav class="site-nav" id="site-nav" aria-label="Menu chính">
            <ul class="site-nav__main">
                <?php foreach ($links as $key => [$href, $label]): ?>
                    <li><a href="<?= $href ?>"<?= $key === $active ? ' aria-current="page"' : '' ?>><?= $label ?></a></li>
                <?php endforeach; ?>
                <li><a href="<?= site_e(site_zalo_url()) ?>" target="_blank" rel="noopener">Box Zalo</a></li>
            </ul>
            <ul class="site-nav__user">
                <?php if ($user !== ''): ?>
                    <?php if ($isAdmin): ?><li><a href="/admin/panel.php">Quản trị</a></li><?php endif; ?>
                    <li><a href="/tai-khoan.php"<?= $active === 'account' ? ' aria-current="page"' : '' ?>><?= site_e($user) ?></a></li>
                    <li><a href="/admin/logout.php">Đăng xuất</a></li>
                <?php else: ?>
                    <li><a href="/dang-nhap.php"<?= $active === 'login' ? ' aria-current="page"' : '' ?>>Đăng nhập</a></li>
                    <li><a class="btn btn--small btn--sun" href="/dang-ky.php">Đăng ký</a></li>
                <?php endif; ?>
            </ul>
        </nav>
    </div>
</header>
<main id="noi-dung">
    <?php
}

function site_foot(): void
{
    ?>
</main>
<footer class="site-footer">
    <div class="wrap site-footer__row">
        <div>
            <strong><?= SITE_NAME ?></strong>
            <p>Dành cho người chơi trên 18 tuổi. Chơi quá 180 phút mỗi ngày sẽ hại sức khỏe.</p>
        </div>
        <ul>
            <li><a href="<?= site_e(site_client_url()) ?>" download>Tải bản PC</a></li>
            <li><a href="/gioi-thieu.php">Giới thiệu</a></li>
            <li><a href="/forum.php">Diễn đàn</a></li>
            <li><a href="<?= site_e(site_zalo_url()) ?>" target="_blank" rel="noopener">Box Zalo</a></li>
        </ul>
    </div>
</footer>
</body>
</html>
    <?php
}
