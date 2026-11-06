// Menu trên điện thoại và nút hiện/ẩn mật khẩu. Không phụ thuộc thư viện ngoài.
document.addEventListener('DOMContentLoaded', function () {
    var toggle = document.querySelector('.nav-toggle');
    var nav = document.getElementById('site-nav');
    if (toggle && nav) {
        toggle.addEventListener('click', function () {
            var open = nav.classList.toggle('is-open');
            toggle.setAttribute('aria-expanded', open ? 'true' : 'false');
        });
    }

    document.querySelectorAll('[data-show-password]').forEach(function (button) {
        var ids = button.getAttribute('data-show-password').split(',');
        button.addEventListener('click', function () {
            var fields = ids.map(function (id) { return document.getElementById(id); });
            var visible = fields[0].type === 'password';
            fields.forEach(function (field) { field.type = visible ? 'text' : 'password'; });
            button.textContent = visible ? 'Ẩn' : 'Hiện';
            button.setAttribute('aria-label', visible ? 'Ẩn mật khẩu' : 'Hiện mật khẩu');
        });
    });
});
