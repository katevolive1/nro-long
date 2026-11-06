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

function formatK($num){
    if($num >= 1000000000) return round($num/1000000000, 1)." Tỷ";
    if($num >= 1000000) return round($num/1000000, 1)." Tr";
    if($num >= 1000) return round($num/1000, 1)." K";
    return number_format($num);
}

// Gộp items_bag và items_box để lấy tổng số lượng item
function getItemQuantityCombined($items_bag, $items_box, $id){
    $total = 0;
    foreach([$items_bag, $items_box] as $itemsText){
        $items = json_decode($itemsText, true);
        if(!$items) continue;
        foreach($items as $it){
            $it = json_decode($it, true);
            if(isset($it[0]) && $it[0] == $id){
                $total += $it[1] ?? 0;
            }
        }
    }
    return $total;
}

function getInventory($data_inventory){
    $inv = json_decode($data_inventory, true);
    return [
        "vang_chim" => $inv[0] ?? 0,
        "ngoc_xanh" => $inv[1] ?? 0,
        "hong_ngoc" => $inv[2] ?? 0
    ];
}

function getStat($items_bag, $items_box, $data_point){
    $arr = json_decode($data_point, true);
    return [
        "sd" => $arr[7] ?? 0,
        "hp" => getItemQuantityCombined($items_bag, $items_box, 16),
        "ki" => getItemQuantityCombined($items_bag, $items_box, 20)
    ];
}

$res = $conn->query("SELECT name, gender, data_inventory, items_bag, items_box, data_point FROM player");

$vangTuoi = $vangChim = $ngocXanh = $hongNgoc = [];
$sdBXH = $hpBXH = $kiBXH = [];

while($row = $res->fetch_assoc()){
    $inv = getInventory($row['data_inventory']);
    $stat = getStat($row['items_bag'], $row['items_box'], $row['data_point']);
    $vn = getItemQuantityCombined($row['items_bag'], $row['items_box'], 457);

    $base = [
        "name"=>$row['name'],
        "gender"=>$row['gender']
    ];

    $vangTuoi[] = $base + ["value"=>$vn];
    $vangChim[] = $base + ["value"=>$inv['vang_chim']];
    $ngocXanh[] = $base + ["value"=>$inv['ngoc_xanh']];
    $hongNgoc[] = $base + ["value"=>$inv['hong_ngoc']];

    $sdBXH[] = $base + ["value"=>$stat['sd']];
    $hpBXH[] = $base + ["value"=>$stat['hp']];
    $kiBXH[] = $base + ["value"=>$stat['ki']];
}

function top10(&$arr){
    usort($arr, fn($a,$b)=>$b['value'] <=> $a['value']);
    $arr = array_slice($arr,0,10);
}

top10($vangTuoi);
top10($vangChim);
top10($ngocXanh);
top10($hongNgoc);
top10($sdBXH);
top10($hpBXH);
top10($kiBXH);

function renderTable($title, $data, $icon){
    ?>
    <section class="card">
        <h2><?= site_e($title) ?></h2>
        <table class="rank-table">
            <thead><tr><th scope="col">Hạng</th><th scope="col">Nhân vật</th><th scope="col" class="num">Số lượng</th></tr></thead>
            <tbody>
            <?php foreach ($data as $i => $p): ?>
                <tr class="is-<?= $i + 1 ?>">
                    <td><span class="rank-no"><?= $i + 1 ?></span></td>
                    <td>
                        <span class="rank-player">
                            <img src="/<?= site_e(getAvatar($p['gender'])) ?>" alt="" width="38" height="38" loading="lazy">
                            <strong><?= site_e($p['name']) ?></strong>
                        </span>
                    </td>
                    <td class="num"><?= site_e(formatK($p['value'])) ?> <img src="/<?= site_e($icon) ?>" alt="" width="20" height="20" style="vertical-align: middle"></td>
                </tr>
            <?php endforeach; ?>
            </tbody>
        </table>
    </section>
    <?php
}

$tab = ($_GET['tab'] ?? '') === 'cs' ? 'cs' : 'tn';
site_head('Bảng xếp hạng tài nguyên', 'rank');
?>
<div class="wrap">
    <div class="page-head">
        <h1>Bảng xếp hạng tài nguyên</h1>
        <p>Top 10 người chơi theo từng loại. <a href="/bxh01.php">Về bảng xếp hạng chính</a></p>
    </div>
    <nav class="tabs" aria-label="Loại bảng xếp hạng">
        <a href="?tab=tn"<?= $tab === 'tn' ? ' aria-current="page"' : '' ?>>Tài nguyên</a>
        <a href="?tab=cs"<?= $tab === 'cs' ? ' aria-current="page"' : '' ?>>Chỉ số</a>
    </nav>
    <div class="rank-grid">
        <?php
        if ($tab === 'tn') {
            renderTable('Vàng Nổi', $vangTuoi, 'img/4028.png');
            renderTable('Vàng Chìm', $vangChim, 'img/930.png');
            renderTable('Ngọc Xanh', $ngocXanh, 'img/932.png');
            renderTable('Hồng Ngọc', $hongNgoc, 'img/7743.png');
        } else {
            renderTable('Sức Đánh', $sdBXH, 'img/2754.png');
            renderTable('3 Sao', $hpBXH, 'img/421.png');
            renderTable('7 Sao', $kiBXH, 'img/425.png');
        }
        ?>
    </div>
</div>
<?php site_foot(); ?>
