<?php
require_once __DIR__ . "/view/layout.php";

function getAvatar($gender) {
    return match((int)$gender){
        0 => "img/td.jpg",
        1 => "img/nm.jpg",
        2 => "img/xd.jpg",
        default => "img/td.jpg"
    };
}

function getPower($data_point){
    $arr = json_decode($data_point, true);
    return $arr[1] ?? 0;
}

function getPetPower($pet){
    $pet = json_decode($pet, true);
    if(isset($pet[1])){
        $info = json_decode($pet[1], true);
        return $info[1] ?? 0;
    }
    return 0;
}

function getTask($data_task){
    $task = json_decode($data_task, true);
    return [
        "main" => $task[0] ?? 0,
        "sub" => $task[1] ?? 0
    ];
}

function formatK($num){
    if($num >= 1000000000) return round($num/1000000000, 1) . " Tỷ";
    if($num >= 1000000) return round($num/1000000, 1) . " Tr";
    if($num >= 1000) return round($num/1000, 1) . " K";
    return number_format($num);
}

// DATA
$topSM = [];
$res = $conn->query("SELECT name, gender, data_point, pet FROM player");
while($row = $res->fetch_assoc()){
    $sm = getPower($row['data_point']);
    $pet = getPetPower($row['pet']);
    $topSM[] = [
        "name"=>$row['name'],
        "gender"=>$row['gender'],
        "total"=>$sm + $pet,
        "sm"=>$sm,
        "pet"=>$pet
    ];
}
usort($topSM, fn($a,$b)=>$b['total'] <=> $a['total']);
$topSM = array_slice($topSM,0,20);

$topTask = [];
$res = $conn->query("SELECT name, gender, data_task FROM player");
while($row = $res->fetch_assoc()){
    $task = getTask($row['data_task']);
    $topTask[] = [
        "name"=>$row['name'],
        "gender"=>$row['gender'],
        "main"=>$task['main'],
        "sub"=>$task['sub']
    ];
}
usort($topTask, fn($a,$b)=>($b['main'] <=> $a['main']) ?: ($b['sub'] <=> $a['sub']));
$topTask = array_slice($topTask,0,20);

$topNap = [];
$res = $conn->query("SELECT p.name, p.gender, a.tongnap FROM player p JOIN account a ON p.account_id = a.id");
while($row = $res->fetch_assoc()){
    $topNap[] = $row;
}
usort($topNap, fn($a,$b)=>$b['tongnap'] <=> $a['tongnap']);
$topNap = array_slice($topNap,0,20);
?>
<?php
$tab = in_array($_GET['tab'] ?? '', ['sm', 'task', 'nap'], true) ? $_GET['tab'] : 'sm';
$tabs = ['sm' => 'Sức Mạnh', 'task' => 'Nhiệm Vụ', 'nap' => 'Tiết Kiệm'];

function bxh_player(array $p): void
{
    ?>
    <span class="rank-player">
        <img src="/<?= site_e(getAvatar($p['gender'])) ?>" alt="" width="38" height="38" loading="lazy">
        <strong><?= site_e($p['name']) ?></strong>
    </span>
    <?php
}

site_head('Bảng xếp hạng', 'rank', 'Bảng xếp hạng sức mạnh, nhiệm vụ và tiết kiệm của ' . SITE_NAME . '.');
?>
<div class="wrap wrap--narrow">
    <div class="page-head">
        <h1>Bảng xếp hạng</h1>
        <p>Top 20 người chơi mạnh nhất máy chủ.</p>
    </div>
    <nav class="tabs" aria-label="Loại bảng xếp hạng">
        <?php foreach ($tabs as $key => $label): ?>
            <a href="?tab=<?= $key ?>"<?= $key === $tab ? ' aria-current="page"' : '' ?>><?= $label ?></a>
        <?php endforeach; ?>
    </nav>
    <div class="card">
        <table class="rank-table">
            <?php if ($tab === 'sm'): ?>
                <thead><tr><th scope="col">Hạng</th><th scope="col">Nhân vật</th><th scope="col" class="num">Tổng sức mạnh</th></tr></thead>
                <tbody>
                <?php foreach ($topSM as $i => $p): ?>
                    <tr class="is-<?= $i + 1 ?>">
                        <td><span class="rank-no"><?= $i + 1 ?></span></td>
                        <td><?php bxh_player($p); ?></td>
                        <td class="num"><?= site_e(formatK($p['total'])) ?>
                            <span class="sub">Sư <?= site_e(formatK($p['sm'])) ?> · Đệ <?= site_e(formatK($p['pet'])) ?></span>
                        </td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            <?php elseif ($tab === 'task'): ?>
                <thead><tr><th scope="col">Hạng</th><th scope="col">Nhân vật</th><th scope="col" class="num">Nhiệm vụ</th></tr></thead>
                <tbody>
                <?php foreach ($topTask as $i => $p): ?>
                    <tr class="is-<?= $i + 1 ?>">
                        <td><span class="rank-no"><?= $i + 1 ?></span></td>
                        <td><?php bxh_player($p); ?></td>
                        <td class="num"><?= (int)$p['main'] ?>-<?= (int)$p['sub'] ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            <?php else: ?>
                <thead><tr><th scope="col">Hạng</th><th scope="col">Nhân vật</th><th scope="col" class="num">Tổng</th></tr></thead>
                <tbody>
                <?php foreach ($topNap as $i => $p): ?>
                    <tr class="is-<?= $i + 1 ?>">
                        <td><span class="rank-no"><?= $i + 1 ?></span></td>
                        <td><?php bxh_player($p); ?></td>
                        <td class="num"><?= number_format($p['tongnap'] / 10) ?></td>
                    </tr>
                <?php endforeach; ?>
                </tbody>
            <?php endif; ?>
        </table>
    </div>
</div>
<?php site_foot(); ?>
