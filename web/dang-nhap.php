<?php
session_start();
require_once __DIR__ . '/view/layout.php';

if (empty($_SESSION['login_csrf'])) $_SESSION['login_csrf'] = bin2hex(random_bytes(32));
$error = '';
$username = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim((string)($_POST['username'] ?? ''));
    $password = (string)($_POST['password'] ?? '');
    if (!hash_equals($_SESSION['login_csrf'], (string)($_POST['csrf'] ?? ''))) {
        $error = 'Phiên đăng nhập không hợp lệ. Vui lòng tải lại trang.';
    } elseif ($username === '' || $password === '') {
        $error = 'Vui lòng nhập tài khoản và mật khẩu.';
    } else {
        $stmt = $conn->prepare('SELECT id, username, password, is_admin, ban FROM account WHERE username = ? LIMIT 1');
        $stmt->bind_param('s', $username);
        $stmt->execute();
        $account = $stmt->get_result()->fetch_assoc();
        $stmt->close();

        $storedPassword = (string)($account['password'] ?? '');
        $validPassword = $account && (hash_equals($storedPassword, $password) ||
            (password_get_info($storedPassword)['algo'] !== null && password_verify($password, $storedPassword)));
        if (!$validPassword) {
            $error = 'Sai tài khoản hoặc mật khẩu.';
        } elseif ((int)$account['ban'] === 1) {
            $error = 'Tài khoản đã bị khóa.';
        } else {
            session_regenerate_id(true);
            $_SESSION['user'] = $account['username'];
            $_SESSION['username'] = $account['username'];
            $_SESSION['id'] = (int)$account['id'];
            $_SESSION['user_id'] = (int)$account['id'];
            $_SESSION['is_admin'] = (int)$account['is_admin'];
            unset($_SESSION['login_csrf']);
            header('Location: ' . ((int)$account['is_admin'] === 1 ? '/admin/panel.php' : '/forum.php'));
            exit;
        }
    }
}
?>
<?php site_head('Đăng nhập', 'login'); ?>
<div class="wrap auth-page">
    <div class="card auth-card">
        <h1>Đăng nhập</h1>
        <p class="intro">Đăng nhập để vào diễn đàn hoặc trang quản trị.</p>
        <?php if ($error !== ''): ?><div class="message is-error" role="alert"><?= site_e($error) ?></div><br><?php endif; ?>
        <form method="post" action="/dang-nhap.php">
            <input type="hidden" name="csrf" value="<?= site_e($_SESSION['login_csrf']) ?>">
            <div class="field">
                <label for="username">Tên tài khoản</label>
                <input id="username" name="username" type="text" maxlength="20" value="<?= site_e($username) ?>" autocomplete="username" required>
            </div>
            <div class="field">
                <label for="password">Mật khẩu</label>
                <div class="password-row">
                    <input id="password" name="password" type="password" autocomplete="current-password" required>
                    <button type="button" data-show-password="password" aria-label="Hiện mật khẩu">Hiện</button>
                </div>
            </div>
            <button class="btn btn--block" type="submit">Đăng nhập</button>
        </form>
        <p class="alt">Chưa có tài khoản? <a href="/dang-ky.php">Đăng ký</a></p>
    </div>
</div>
<?php site_foot(); ?>
