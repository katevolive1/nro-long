<?php
require_once __DIR__ . '/view/layout.php';

$latestPosts = [];
$result = $conn->query('SELECT id, tieude, created_at FROM posts ORDER BY created_at DESC LIMIT 5');
if ($result) {
    $latestPosts = $result->fetch_all(MYSQLI_ASSOC);
    $result->free();
}

site_head('Trang chủ', 'home');
?>
<section class="hero">
    <div class="wrap hero__row">
        <div>
            <img class="hero__logo" src="/images/logo-vua.png" alt="<?= SITE_NAME ?>" width="640" height="310">
            <h1>Luyện tập, săn Ngọc&nbsp;Rồng, hạ boss cùng bạn bè</h1>
            <p class="hero__text">Chọn một trong 3 hành tinh, tăng sức mạnh, thu nhận đệ tử và cùng bang hội chiến đấu trong thế giới 7 viên Ngọc Rồng.</p>
            <div class="hero__actions">
                <a class="btn btn--big" href="<?= site_e(site_client_url()) ?>" download>Tải bản PC</a>
                <a class="btn btn--big btn--light" href="/dang-ky.php">Đăng ký miễn phí</a>
            </div>
            <p class="hero__note">Hiện có bản cho máy tính Windows.</p>
        </div>
        <img class="hero__art" src="/images/banner_Summer.png" alt="Các nhân vật trong game tụ họp ở bãi biển" width="615" height="270">
    </div>
</section>

<section class="section wrap">
    <h2 class="section__title">Vào game trong 3 bước</h2>
    <p class="section__lead">Tài khoản dùng riêng cho máy chủ này, không chung với trò chơi nào khác.</p>
    <ol class="steps">
        <li class="card step">
            <h3>Tải game</h3>
            <p><a href="<?= site_e(site_client_url()) ?>" download>Tải bản PC</a>, giải nén rồi mở <strong>DragonBoy.exe</strong>.</p>
        </li>
        <li class="card step">
            <h3>Tạo tài khoản</h3>
            <p><a href="/dang-ky.php">Đăng ký</a> trên web, chỉ cần tên tài khoản và mật khẩu.</p>
        </li>
        <li class="card step">
            <h3>Chọn hành tinh</h3>
            <p>Đăng nhập trong game, tạo nhân vật và bắt đầu hành trình.</p>
        </li>
    </ol>
</section>

<section class="section wrap">
    <h2 class="section__title">Chọn hành tinh của bạn</h2>
    <p class="section__lead">Mỗi hành tinh có hình dạng và khả năng riêng.</p>
    <div class="planets">
        <article class="card planet planet--td">
            <img src="/img/td.jpg" alt="" width="104" height="104" loading="lazy">
            <h3>Trái Đất</h3>
            <p>Kỹ năng đặc biệt khó chịu, rất mạnh khi đi theo nhóm.</p>
        </article>
        <article class="card planet planet--nm">
            <img src="/img/nm.jpg" alt="" width="104" height="104" loading="lazy">
            <h3>Namếc</h3>
            <p>Khả năng tái tạo và hỗ trợ đồng đội đáng kinh ngạc.</p>
        </article>
        <article class="card planet planet--xd">
            <img src="/img/xd.jpg" alt="" width="104" height="104" loading="lazy">
            <h3>Xayda</h3>
            <p>Sức mạnh kinh hoàng khi chiến đấu đơn độc.</p>
        </article>
    </div>
</section>

<section class="section wrap">
    <h2 class="section__title">Chiêu thức</h2>
    <p class="section__lead">Nâng cấp chiêu thức và tiềm năng bản thân để đạt sức mạnh cao nhất. <a href="/gioi-thieu.php#s4">Xem thêm</a></p>
    <div class="skills">
        <div class="card card--pad">
            <h3>Cơ bản</h3>
            <div class="skills__row">
                <img src="/images/gif/gif_maphongba.gif" alt="Chiêu Ma phong ba" loading="lazy">
                <img src="/images/gif/gif_gif_Saiyain.gif" alt="Biến hình Saiyan" loading="lazy">
                <img src="/images/gif/gif_supber_kame.gif" alt="Chiêu Super Kame" loading="lazy">
            </div>
        </div>
        <div class="card card--pad">
            <h3>VIP</h3>
            <div class="skills__row">
                <img src="/images/gif/gif_maphongba_VIP.gif" alt="Chiêu Ma phong ba bản VIP" loading="lazy">
                <img src="/images/gif/gif_gif_Saiyain_VIP.gif" alt="Biến hình Saiyan bản VIP" loading="lazy">
                <img src="/images/gif/gif_supber_kame_VIP.gif" alt="Chiêu Super Kame bản VIP" loading="lazy">
            </div>
        </div>
    </div>
</section>

<section class="section wrap two-col">
    <div>
        <h2 class="section__title">Tin mới</h2>
        <p class="section__lead"><a href="/forum.php">Xem tất cả ở diễn đàn</a></p>
        <div class="card">
            <?php foreach ($latestPosts as $post): ?>
                <a class="post-item post-item--plain" href="/bai-viet.php?id=<?= (int)$post['id'] ?>">
                    <span>
                        <span class="post-item__title"><?= site_e($post['tieude']) ?></span>
                        <span class="post-item__meta"><?= site_e(date('d/m/Y', strtotime($post['created_at']))) ?></span>
                    </span>
                </a>
            <?php endforeach; ?>
            <?php if (!$latestPosts): ?><p class="empty">Chưa có bài viết.</p><?php endif; ?>
        </div>
    </div>
    <div>
        <h2 class="section__title">Dành cho tân thủ</h2>
        <p class="section__lead">Những điều nên biết trước khi vào game.</p>
        <div class="card accordion">
            <details open>
                <summary>Điều khiển trên máy tính</summary>
                <div>Dùng chuột: click chuột phải để di chuyển, click chuột trái để chọn, click đôi vào đối tượng để tương tác.</div>
            </details>
            <details>
                <summary>Hồi phục và tập luyện</summary>
                <div>
                    <ul>
                        <li>Đậu thần tăng KI và HP ngay lập tức, nâng cấp để phục hồi nhiều hơn.</li>
                        <li>Mang theo người được 10 hạt đậu. Muốn nhiều hơn, hãy xin bạn bè trong Bang.</li>
                        <li>Cây đậu thần kết hạt sau một thời gian, kể cả khi bạn offline.</li>
                        <li>Đùi gà phục hồi 100% HP, KI. Cà chua phục hồi 100% KI. Cà rốt phục hồi 100% HP.</li>
                        <li>Thể lực giảm khi đánh quái và tăng lại khi không đánh nữa.</li>
                        <li>Không thể bay, dùng kỹ năng nếu hết KI.</li>
                    </ul>
                </div>
            </details>
            <details>
                <summary>Tăng tiềm năng</summary>
                <div>
                    <ul>
                        <li>Sách kỹ năng học miễn phí tại Quy Lão Kame khi có đủ điểm tiềm năng.</li>
                        <li>Đánh quái cùng bạn bè trong Bang được nhiều điểm tiềm năng hơn đánh một mình.</li>
                        <li>Tập luyện với bạn bè tại khu vực thích hợp được nhiều điểm hơn đánh quái.</li>
                        <li>Vào game đều đặn mỗi ngày để nhận Ngọc miễn phí.</li>
                        <li>Sau 3 ngày không tham gia, bạn sẽ bị giảm sức mạnh do lười luyện tập.</li>
                    </ul>
                </div>
            </details>
            <details>
                <summary>Giữ an toàn tài khoản</summary>
                <div>Admin không bao giờ hỏi mật khẩu của bạn. Đừng đưa mật khẩu cho bất kỳ ai.</div>
            </details>
        </div>
    </div>
</section>
<?php site_foot(); ?>
