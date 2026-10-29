<?php
require_once __DIR__ . "/config.php";

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

<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Bảng Xếp Hạng</title>
<link rel="icon" type="image/jpg" href="img/icon.jpg">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<style>
/* --- PHẦN SỬA ĐỂ GIỐNG PANEL --- */
body {
    margin: 0;
    font-family: 'Segoe UI', Arial;
    /* Background gradient xanh từ panel */
    background: linear-gradient(135deg, #bae6fd, #60a5fa);
    min-height: 100vh;
    display: flex;
    justify-content: center;
    padding: 20px 0;
    font-size: 90%;
}

.wrapper {
    max-width: 720px;
    width: 100%;
    /* Khung tối bo góc từ panel */
    background: linear-gradient(160deg, #4a4a4a, #2b2b2b 65%, #1b1b1b);
    border-radius: 28px;
    padding: 22px;
    box-shadow: 0 25px 60px rgba(0,0,0,.5), inset 0 2px 8px rgba(255,255,255,.1);
    border: 1px solid rgba(255,255,255,0.15);
    color: white; /* Đổi màu chữ mặc định trong khung thành trắng */
    margin: 0 12px;
}
/* ---------------------------------- */

/* --- TẤT CẢ PHẦN CÒN LẠI GIỮ NGUYÊN --- */
* { box-sizing: border-box; }

.topbar { text-align: center; margin-bottom: 20px; }

.back-btn {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    padding: 12px 22px;
    border-radius: 30px;
    background: linear-gradient(135deg,#3b82f6,#2563eb);
    color: #fff;
    text-decoration: none;
    font-weight: 700;
    font-size: 110%;
    box-shadow: 0 6px 15px rgba(0,0,0,.3);
    transition: .2s;
}

.back-btn:hover {
    transform: translateY(-2px) scale(1.05);
    box-shadow: 0 10px 25px rgba(0,0,0,.4);
}

@media(min-width:769px){
    body{font-size:115%;}
}

.tabs {
    display: flex;
    gap: 6px;
    margin-bottom: 10px;
}

.tabs button {
    flex: 1;
    padding: 15px;
    font-weight: 700;
    border: none;
    border-radius: 12px;
    color: #fff;
    font-size: 125%;
    cursor: pointer;
    transition: opacity 0.2s;
}

.tabs button:hover { opacity: 0.9; }

/* Màu sắc các nút Tab */
.btn-sm{background:#f43f5e !important;}
.btn-task{background:#2196f3 !important;}
.btn-nap{background:#4caf50 !important;}

.bxh-box {
    padding: 5px;
    border-radius: 16px;
    transition: background 0.3s ease;
}

/* Màu khung đồng bộ với Tab đang active */
.bg-sm{background:#f43f5e;}
.bg-task{background:#2196f3;}
.bg-nap{background:#4caf50;}

.card {
    background: #fff;
    border-radius: 12px;
    padding: 10px;
    color: #333; /* Giữ màu chữ tối cho nội dung bảng */
}

.title {
    text-align: center;
    font-weight: 800;
    color: #fff;
    padding: 8px;
    border-radius: 10px;
    margin-bottom: 8px;
}

#sm .title{background:#f43f5e;}
#task .title{background:#2196f3;}
#nap .title{background:#4caf50;}

.table {
    width: 100%;
    border-collapse: collapse;
}

.table th, .table td {
    padding: 8px;
    text-align: center;
}

.table th {
    background: #f8fafc;
    border-bottom: 2px solid #edf2f7;
    color: #333;
}

.avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    overflow: hidden;
    margin: auto;
}

.avatar img {
    width: 100%;
    height: 100%;
    object-fit: contain;
}

.power span{display:block; font-size: 0.9em;}
.name{font-weight:700;}

.top0 td{background:#fff8e1;}
.top1 td{background:#f1f5f9;}
.top2 td{background:#fff5f5;}

.tab { display: none; }
.tab.active { display: block; }
</style>

<script>
function openTab(id, colorClass){
    document.querySelectorAll('.tab').forEach(t=>t.classList.remove('active'));
    document.getElementById(id).classList.add('active');
    
    // Đổi màu khung bxh-box
    const box = document.querySelector('.bxh-box');
    box.className = 'bxh-box ' + colorClass;
}
document.addEventListener('DOMContentLoaded', () => {
    const tab = new URLSearchParams(location.search).get('tab');
    if (tab === 'task') openTab('task', 'bg-task');
    if (tab === 'nap') openTab('nap', 'bg-nap');
});
</script>
</head>

<body>

<div class="wrapper">

<div class="topbar">
    <a href="/forum.php" class="back-btn">
        <i class="fa-solid fa-house"></i> Trang Chủ
    </a>
</div>

<div class="tabs">
    <button class="btn-sm" onclick="openTab('sm', 'bg-sm')">Sức Mạnh</button>
    <button class="btn-task" onclick="openTab('task', 'bg-task')">Nhiệm Vụ</button>
    <button class="btn-nap" onclick="openTab('nap', 'bg-nap')">Tiết Kiệm</button>
</div>

<div class="bxh-box bg-sm"> <div class="card">

<div id="sm" class="tab active">
<div class="title">🏆 BXH Sức Mạnh</div>
<table class="table">
<tr><th>TOP</th><th>Tổng</th><th>Chi tiết</th><th></th></tr>
<?php foreach ($topSM as $i=>$p): ?>
<tr class="<?= 'top'.$i ?>">
<td class="name"><?= ($i+1)."." ?> <?= $p['name'] ?></td>
<td><?= formatK($p['total']) ?></td>
<td class="power">
<span>Sư: <?= formatK($p['sm']) ?></span>
<span>Đệ: <?= formatK($p['pet']) ?></span>
</td>
<td><div class="avatar"><img src="<?= getAvatar($p['gender']) ?>"></div></td>
</tr>
<?php endforeach; ?>
</table>
</div>

<div id="task" class="tab">
<div class="title">📜 BXH Nhiệm Vụ</div>
<table class="table">
<tr><th>TOP</th><th>Nhiệm vụ</th><th></th></tr>
<?php foreach ($topTask as $i=>$p): ?>
<tr class="<?= 'top'.$i ?>">
<td class="name"><?= ($i+1)."." ?> <?= $p['name'] ?></td>
<td><?= $p['main'] ?>-<?= $p['sub'] ?></td>
<td><div class="avatar"><img src="<?= getAvatar($p['gender']) ?>"></div></td>
</tr>
<?php endforeach; ?>
</table>
</div>

<div id="nap" class="tab">
<div class="title">💰 BXH Tiết Kiệm</div>
<table class="table">
<tr><th>TOP</th><th>Tổng</th><th></th></tr>
<?php foreach ($topNap as $i=>$p): ?>
<tr class="<?= 'top'.$i ?>">
<td class="name"><?= ($i+1)."." ?> <?= $p['name'] ?></td>
<td><?= number_format($p['tongnap'] / 10) ?></td>
<td><div class="avatar"><img src="<?= getAvatar($p['gender']) ?>"></div></td>
</tr>
<?php endforeach; ?>
</table>
</div>

</div>
</div>

</div>

</body>
</html>
