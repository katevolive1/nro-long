<?php
require_once __DIR__ . '/view/layout.php';
require_once __DIR__ . '/post_detail_logic.php';

site_head($post_detail ? $post_detail['tieude'] : 'Bài viết không tồn tại', 'forum');
?>
<div class="wrap wrap--narrow">
    <a class="back-link" href="/forum.php">Quay lại diễn đàn</a>
    <?php if ($post_detail): ?>
        <article class="card article">
            <h1><?= site_e($post_detail['tieude']) ?></h1>
            <div class="article__meta">
                <img src="<?= site_e($post_detail['author_avatar_path']) ?>" alt="" width="40" height="40">
                <span>
                    <strong><?= site_e($post_detail['username']) ?></strong><br>
                    <?= site_e(date('d/m/Y H:i', strtotime($post_detail['created_at']))) ?>
                </span>
            </div>
            <div class="article__body">
                <?= nl2br(site_e($post_detail['noidung'])) ?>
                <?php if (!empty($post_detail['display_image_path'])): ?>
                    <img src="<?= $post_detail['display_image_path'] ?>" alt="" loading="lazy">
                <?php endif; ?>
            </div>
        </article>
    <?php else: ?>
        <div class="card article">
            <?php if ($_alert !== ''): ?><div class="notice"><?= strip_tags($_alert) ?></div><?php endif; ?>
            <p>Bài viết không tồn tại hoặc đã bị xóa.</p>
        </div>
    <?php endif; ?>
</div>
<?php site_foot(); ?>
