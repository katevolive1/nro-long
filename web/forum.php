<?php
require_once __DIR__ . '/view/layout.php';
require_once __DIR__ . '/settings.php';
require_once __DIR__ . '/forum_data.php';
$conn->close();

function forum_post_item(array $post): void
{
    $date = date('d/m/Y H:i', strtotime($post['created_at']));
    ?>
    <a class="post-item" href="/bai-viet.php?id=<?= (int)$post['id'] ?>">
        <img src="<?= site_e($post['avatar_url']) ?>" alt="" width="44" height="44" loading="lazy">
        <span>
            <span class="post-item__title"><?= site_e($post['tieude']) ?></span>
            <span class="post-item__meta">bởi <?= site_e($post['username']) ?> · <?= site_e($date) ?></span>
        </span>
    </a>
    <?php
}

site_head('Diễn đàn', 'forum', 'Tin tức, sự kiện và thảo luận của ' . SITE_NAME . '.');
?>
<div class="wrap">
    <div class="page-head">
        <h1>Diễn đàn</h1>
        <p>Tin tức, sự kiện và thông báo từ máy chủ.</p>
    </div>
    <div class="forum-layout">
        <div>
            <div class="card">
                <?php if (!empty($pinned_posts)): ?>
                    <div class="post-list__label">Bài ghim</div>
                    <?php foreach ($pinned_posts as $post) { forum_post_item($post); } ?>
                <?php endif; ?>
                <?php if (!empty($unpinned_posts)): ?>
                    <div class="post-list__label">Bài mới</div>
                    <?php foreach ($unpinned_posts as $post) { forum_post_item($post); } ?>
                <?php endif; ?>
                <?php if (empty($pinned_posts) && empty($unpinned_posts)): ?>
                    <p class="empty">Chưa có bài viết.</p>
                <?php endif; ?>
            </div>
            <?php if ($total_pages > 1): ?>
                <nav class="pager" aria-label="Phân trang">
                    <?php for ($i = 1; $i <= $total_pages; $i++): ?>
                        <a href="?page=<?= $i ?>"<?= $i == $current_page ? ' aria-current="page"' : '' ?>><?= $i ?></a>
                    <?php endfor; ?>
                </nav>
            <?php endif; ?>
        </div>
        <aside class="side-stack">
            <div class="card card--pad side-card">
                <?php if ($is_logged_in): ?>
                    <div class="user-box">
                        <img src="<?= site_e($user_avatar) ?>" alt="" width="56" height="56">
                        <div>
                            <strong><?= site_e($display_player_name) ?></strong>
                            <span>Số dư: <?= number_format((float)$user_vnd) ?> VND</span>
                        </div>
                    </div>
                    <div class="side-actions">
                        <a class="btn btn--small btn--light" href="/tai-khoan.php">Tài khoản</a>
                    </div>
                <?php else: ?>
                    <h2>Tham gia ngay</h2>
                    <p>Tạo tài khoản miễn phí để vào game.</p>
                    <div class="side-actions">
                        <a class="btn" href="/dang-ky.php">Đăng ký</a>
                        <a class="btn btn--light" href="/dang-nhap.php">Đăng nhập</a>
                    </div>
                <?php endif; ?>
            </div>
            <div class="card card--pad side-card">
                <h2>Bảng xếp hạng</h2>
                <div class="side-actions">
                    <a class="btn btn--small btn--light" href="/bxh01.php?tab=sm">Top Sức Mạnh</a>
                    <a class="btn btn--small btn--light" href="/bxh01.php?tab=task">Top Nhiệm Vụ</a>
                    <a class="btn btn--small btn--light" href="/bxh01.php?tab=nap">Top Tiết Kiệm</a>
                </div>
            </div>
            <a class="btn btn--sun btn--block" href="<?= site_e(site_client_url()) ?>" download>Tải bản PC</a>
        </aside>
    </div>
</div>
<?php site_foot(); ?>
