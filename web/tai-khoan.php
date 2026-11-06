<?php
require_once __DIR__ . '/view/layout.php';
require_once __DIR__ . '/settings.php';
require_once __DIR__ . '/forum_data.php';
$conn->close();

site_head('Tài khoản', 'account');
?>
<div class="wrap auth-page">
    <div class="card auth-card">
        <h1>Tài khoản</h1>
        <?php if ($is_logged_in): ?>
            <p class="intro">Thông tin tài khoản của bạn.</p>
            <div class="user-box">
                <img src="<?= site_e($user_avatar) ?>" alt="" width="56" height="56">
                <div>
                    <strong><?= site_e($display_player_name) ?></strong>
                    <span>Tài khoản: <?= site_e($account_username) ?></span><br>
                    <span>Số dư: <?= number_format((float)$user_vnd) ?> VND</span>
                </div>
            </div>
            <div class="side-actions">
                <a class="btn" href="<?= site_e(site_client_url()) ?>" download>Tải bản PC</a>
                <a class="btn btn--light" href="/bxh01.php">Bảng xếp hạng</a>
                <a class="btn btn--light" href="/admin/logout.php">Đăng xuất</a>
            </div>
        <?php else: ?>
            <p class="intro">Đăng nhập để xem thông tin tài khoản.</p>
            <div class="side-actions">
                <a class="btn" href="/dang-nhap.php">Đăng nhập</a>
                <a class="btn btn--light" href="/dang-ky.php">Đăng ký</a>
            </div>
        <?php endif; ?>
    </div>
</div>
<?php site_foot(); ?>
