<?php
session_start();
require_once __DIR__ . '/config.php';

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
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng Nhập - Chú Bé Rồng Online</title>
    <link rel="icon" href="/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="/view/static/css/template.css?v=1.10">
    <link rel="stylesheet" href="/view/static/css/site-fixes.css?v=4">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; background: #b3afaf; font-family: Arial, sans-serif; color: #3c1b09; }
        .login-page { max-width: 630px; margin: 16px auto; background: #ffaf4c; border-radius: 15px; overflow: hidden; box-shadow: 0 8px 24px #0002; }
        .login-header { background: #ff5601; text-align: center; padding: 16px 8px 5px; }
        .login-header img { width: 180px; max-width: 55%; height: auto; }
        .menu2 { background: #ff5601; padding-bottom: 4px; }
        .menu2 table { border-spacing: 4px; }
        .login-content { padding: 28px 24px 36px; }
        .login-card { max-width: 430px; margin: auto; background: #fff9ee; border: 2px solid #d47b27; border-radius: 14px; padding: 25px; box-shadow: 0 6px 18px #9d490b24; }
        h1 { margin: 0 0 7px; color: #c84d09; font-size: 26px; text-align: center; }
        .intro { margin: 0 0 24px; color: #75513b; text-align: center; line-height: 1.5; }
        label { display: block; font-weight: bold; margin: 15px 0 7px; }
        input { width: 100%; min-height: 43px; padding: 10px 12px; border: 1px solid #d7aa76; border-radius: 8px; font: inherit; background: #fff; }
        input:focus { outline: 2px solid #ffaf4c; outline-offset: 1px; }
        .password-row { position: relative; }
        .password-row input { padding-right: 72px; }
        .show-password { position: absolute; right: 5px; top: 5px; width: 59px; height: 33px; padding: 0; border: 0; background: transparent; color: #9b430d; cursor: pointer; }
        .submit-button { display: block; width: 100%; margin-top: 24px; padding: 12px; border: 0; border-radius: 9px; background: #f45108; color: #fff; font: bold 17px Arial, sans-serif; cursor: pointer; }
        .submit-button:hover { background: #d94003; }
        .message { margin: 0 0 12px; padding: 11px; border-radius: 8px; background: #ffe6e6; color: #9d1e1e; line-height: 1.4; }
        .register-link { text-align: center; margin: 20px 0 0; }
        .register-link a { color: #9b430d; font-weight: bold; }
        @media (max-width: 640px) { .login-page { margin: 0; border-radius: 0; min-height: 100vh; } .login-content { padding: 20px 12px; } .login-card { padding: 20px 16px; } }
    </style>
</head>
<body>
<div class="login-page">
    <div class="login-header"><a href="/index.php"><img src="/images/logo_sk_he.png" alt="Chú Bé Rồng Online"></a></div>
    <div class="menu2">
        <table width="100%" cellspacing="4"><tr class="menu">
            <td><a href="/index.php">Trang Chủ</a></td>
            <td><a href="/gioi-thieu.php">Giới Thiệu</a></td>
            <td><a href="/forum.php">Diễn Đàn</a></td>
            <td><a href="https://zalo.me/g/hfaysi616" target="_blank" rel="noopener">Box Zalo</a></td>
        </tr></table>
    </div>
    <main class="login-content">
        <div class="login-card">
            <h1>Đăng Nhập</h1>
            <p class="intro">Đăng nhập để vào diễn đàn hoặc trang quản trị.</p>
            <?php if ($error !== ''): ?><div class="message" role="alert"><?= htmlspecialchars($error, ENT_QUOTES, 'UTF-8') ?></div><?php endif; ?>
            <form method="post" action="/dang-nhap.php">
                <input type="hidden" name="csrf" value="<?= htmlspecialchars($_SESSION['login_csrf'], ENT_QUOTES, 'UTF-8') ?>">
                <label for="username">Tên tài khoản</label>
                <input id="username" name="username" type="text" maxlength="20" value="<?= htmlspecialchars($username, ENT_QUOTES, 'UTF-8') ?>" autocomplete="username" required>
                <label for="password">Mật khẩu</label>
                <div class="password-row">
                    <input id="password" name="password" type="password" autocomplete="current-password" required>
                    <button type="button" class="show-password" id="showPassword" aria-label="Hiện mật khẩu">Hiện</button>
                </div>
                <button class="submit-button" type="submit">Đăng Nhập</button>
            </form>
            <p class="register-link">Chưa có tài khoản? <a href="/dang-ky.php">Đăng ký</a></p>
        </div>
    </main>
</div>
<script>
document.getElementById('showPassword').addEventListener('click', function () {
    const password = document.getElementById('password');
    const visible = password.type === 'password';
    password.type = visible ? 'text' : 'password';
    this.textContent = visible ? 'Ẩn' : 'Hiện';
    this.setAttribute('aria-label', visible ? 'Ẩn mật khẩu' : 'Hiện mật khẩu');
});
</script>
</body>
</html>
