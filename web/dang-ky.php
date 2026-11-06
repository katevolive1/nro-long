<?php
require_once __DIR__ . '/view/layout.php';
site_head('Đăng ký', '', 'Tạo tài khoản miễn phí để chơi ' . SITE_NAME . '.');
?>
<div class="wrap auth-page">
    <div class="card auth-card">
        <h1>Đăng ký</h1>
        <p class="intro">Tạo tài khoản để tham gia <?= SITE_NAME ?>.</p>
        <form id="registerForm" novalidate>
            <div class="field">
                <label for="username">Tên tài khoản</label>
                <input id="username" name="username" type="text" minlength="4" maxlength="12" pattern="[A-Za-z0-9_]{4,12}" autocomplete="username" required>
                <p class="field__hint">4–12 ký tự: chữ, số hoặc dấu gạch dưới.</p>
            </div>
            <div class="field">
                <label for="password">Mật khẩu</label>
                <div class="password-row">
                    <input id="password" name="password" type="password" minlength="6" autocomplete="new-password" required>
                    <button type="button" data-show-password="password,confirmPassword" aria-label="Hiện mật khẩu">Hiện</button>
                </div>
            </div>
            <div class="field">
                <label for="confirmPassword">Nhập lại mật khẩu</label>
                <input id="confirmPassword" type="password" minlength="6" autocomplete="new-password" required>
            </div>
            <button class="btn btn--block" id="submitButton" type="submit">Đăng ký</button>
            <div id="message" class="message" role="status" aria-live="polite"></div>
        </form>
        <p class="alt">Đã có tài khoản? <a href="/dang-nhap.php">Đăng nhập</a></p>
    </div>
</div>
<script>
const form = document.getElementById('registerForm');
const submitButton = document.getElementById('submitButton');
const message = document.getElementById('message');
const password = document.getElementById('password');
const confirmPassword = document.getElementById('confirmPassword');

function showMessage(text, type) {
    message.textContent = text;
    message.className = 'message ' + type;
}

form.addEventListener('submit', async function (event) {
    event.preventDefault();
    message.className = 'message';
    const username = document.getElementById('username').value.trim();
    if (!/^[A-Za-z0-9_]{4,12}$/.test(username)) {
        showMessage('Tên tài khoản cần 4–12 ký tự, chỉ gồm chữ, số hoặc dấu gạch dưới.', 'is-error');
        return;
    }
    if (password.value.length < 6) {
        showMessage('Mật khẩu cần ít nhất 6 ký tự.', 'is-error');
        return;
    }
    if (password.value !== confirmPassword.value) {
        showMessage('Hai mật khẩu không khớp.', 'is-error');
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
            showMessage('Đăng ký thành công! Bạn có thể đăng nhập ngay.', 'is-ok');
        } else {
            showMessage(result.message || 'Đăng ký thất bại. Vui lòng thử lại.', 'is-error');
        }
    } catch (error) {
        showMessage('Không kết nối được máy chủ. Vui lòng thử lại.', 'is-error');
    } finally {
        submitButton.disabled = false;
        submitButton.textContent = 'Đăng ký';
    }
});
</script>
<?php site_foot(); ?>
