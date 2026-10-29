<?php
session_start();
?>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đăng Ký - Chú Bé Rồng Online</title>
    <link rel="icon" href="/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="/view/static/css/template.css?v=1.10">
    <link rel="stylesheet" href="/view/static/css/site-fixes.css?v=4">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; background: #b3afaf; font-family: Arial, sans-serif; color: #3c1b09; }
        .register-page { max-width: 630px; margin: 16px auto; background: #ffaf4c; border-radius: 15px; overflow: hidden; box-shadow: 0 8px 24px #0002; }
        .register-header { background: #ff5601; text-align: center; padding: 16px 8px 5px; }
        .register-header img { width: 180px; max-width: 55%; height: auto; }
        .menu2 { background: #ff5601; padding-bottom: 4px; }
        .menu2 table { border-spacing: 4px; }
        .register-content { padding: 28px 24px 36px; }
        .register-card { max-width: 430px; margin: auto; background: #fff9ee; border: 2px solid #d47b27; border-radius: 14px; padding: 25px; box-shadow: 0 6px 18px #9d490b24; }
        h1 { margin: 0 0 7px; color: #c84d09; font-size: 26px; text-align: center; }
        .intro { margin: 0 0 24px; color: #75513b; text-align: center; line-height: 1.5; }
        label { display: block; font-weight: bold; margin: 15px 0 7px; }
        input { width: 100%; min-height: 43px; padding: 10px 12px; border: 1px solid #d7aa76; border-radius: 8px; font: inherit; background: #fff; }
        input:focus { outline: 2px solid #ffaf4c; outline-offset: 1px; }
        .hint { color: #765e4d; font-size: 12px; margin-top: 5px; }
        .password-row { position: relative; }
        .password-row input { padding-right: 72px; }
        .show-password { position: absolute; right: 5px; top: 5px; width: 59px; height: 33px; padding: 0; border: 0; background: transparent; color: #9b430d; cursor: pointer; }
        .submit-button { display: block; width: 100%; margin-top: 24px; padding: 12px; border: 0; border-radius: 9px; background: #f45108; color: #fff; font: bold 17px Arial, sans-serif; cursor: pointer; }
        .submit-button:hover { background: #d94003; }
        .submit-button:disabled { opacity: .6; cursor: wait; }
        .message { display: none; margin-top: 15px; padding: 11px; border-radius: 8px; line-height: 1.4; }
        .message.error { display: block; background: #ffe6e6; color: #9d1e1e; }
        .message.success { display: block; background: #e4f8e7; color: #1c7330; }
        .login-link { text-align: center; margin: 20px 0 0; }
        .login-link a { color: #9b430d; font-weight: bold; }
        @media (max-width: 640px) { .register-page { margin: 0; border-radius: 0; min-height: 100vh; } .register-content { padding: 20px 12px; } .register-card { padding: 20px 16px; } }
    </style>
</head>
<body>
<div class="register-page">
    <div class="register-header"><a href="/index.php"><img src="/images/logo_sk_he.png" alt="Chú Bé Rồng Online"></a></div>
    <div class="menu2">
        <table width="100%" cellspacing="4"><tr class="menu">
            <td><a href="/index.php">Trang Chủ</a></td>
            <td><a href="/gioi-thieu.php">Giới Thiệu</a></td>
            <td><a href="/forum.php">Diễn Đàn</a></td>
            <td><a href="https://zalo.me/g/hfaysi616" target="_blank" rel="noopener">Box Zalo</a></td>
        </tr></table>
    </div>
    <main class="register-content">
        <div class="register-card">
            <h1>Đăng Ký Tài Khoản</h1>
            <p class="intro">Tạo tài khoản để tham gia Chú Bé Rồng Online.</p>
            <form id="registerForm" novalidate>
                <label for="username">Tên tài khoản</label>
                <input id="username" name="username" type="text" minlength="4" maxlength="12" pattern="[A-Za-z0-9_]{4,12}" autocomplete="username" required>
                <div class="hint">4–12 ký tự: chữ, số hoặc dấu gạch dưới.</div>

                <label for="password">Mật khẩu</label>
                <div class="password-row">
                    <input id="password" name="password" type="password" minlength="6" autocomplete="new-password" required>
                    <button type="button" class="show-password" id="showPassword" aria-label="Hiện mật khẩu">Hiện</button>
                </div>

                <label for="confirmPassword">Nhập lại mật khẩu</label>
                <input id="confirmPassword" type="password" minlength="6" autocomplete="new-password" required>
                <button class="submit-button" id="submitButton" type="submit">Đăng Ký</button>
                <div id="message" class="message" role="status" aria-live="polite"></div>
            </form>
            <p class="login-link">Đã có tài khoản? <a href="/dang-nhap.php">Đăng nhập</a></p>
        </div>
    </main>
</div>
<script>
const form = document.getElementById('registerForm');
const submitButton = document.getElementById('submitButton');
const message = document.getElementById('message');
const password = document.getElementById('password');
const confirmPassword = document.getElementById('confirmPassword');

document.getElementById('showPassword').addEventListener('click', function () {
    const visible = password.type === 'password';
    password.type = visible ? 'text' : 'password';
    confirmPassword.type = visible ? 'text' : 'password';
    this.textContent = visible ? 'Ẩn' : 'Hiện';
    this.setAttribute('aria-label', visible ? 'Ẩn mật khẩu' : 'Hiện mật khẩu');
});

function showMessage(text, type) {
    message.textContent = text;
    message.className = 'message ' + type;
}

form.addEventListener('submit', async function (event) {
    event.preventDefault();
    message.className = 'message';
    const username = document.getElementById('username').value.trim();
    if (!/^[A-Za-z0-9_]{4,12}$/.test(username)) {
        showMessage('Tên tài khoản cần 4–12 ký tự, chỉ gồm chữ, số hoặc dấu gạch dưới.', 'error');
        return;
    }
    if (password.value.length < 6) {
        showMessage('Mật khẩu cần ít nhất 6 ký tự.', 'error');
        return;
    }
    if (password.value !== confirmPassword.value) {
        showMessage('Hai mật khẩu không khớp.', 'error');
        return;
    }

    submitButton.disabled = true;
    submitButton.textContent = 'Đang đăng ký...';
    try {
        const data = new FormData();
        data.set('username', username);
        data.set('password', password.value);
        data.set('token', btoa(navigator.userAgent + '|' + Date.now()));
        data.set('fp', btoa(navigator.userAgent + screen.width + screen.height + navigator.language));
        const response = await fetch('/dangky.php', {method: 'POST', body: data});
        const result = await response.json();
        if (result.status === 'success') {
            form.reset();
            showMessage('Đăng ký thành công! Bạn có thể đăng nhập ngay.', 'success');
        } else {
            showMessage(result.message || 'Đăng ký thất bại. Vui lòng thử lại.', 'error');
        }
    } catch (error) {
        showMessage('Không kết nối được máy chủ. Vui lòng thử lại.', 'error');
    } finally {
        submitButton.disabled = false;
        submitButton.textContent = 'Đăng Ký';
    }
});
</script>
</body>
</html>
