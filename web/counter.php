<?php
date_default_timezone_set("Asia/Ho_Chi_Minh");

$file = "counter.json";

if (!file_exists($file)) {
    file_put_contents($file, json_encode([
        "today_date" => date("Y-m-d"),
        "today" => 0,
        "yesterday" => 0
    ], JSON_PRETTY_PRINT));
}

$data = json_decode(file_get_contents($file), true);

$today = date("Y-m-d");

/* reset khi qua ngày mới */
if ($data["today_date"] !== $today) {
    $data["yesterday"] = $data["today"];
    $data["today"] = 0;
    $data["today_date"] = $today;
}

/* đếm lượt truy cập */
if (!isset($_COOKIE['visited'])) {
    $data["today"]++;
    setcookie("visited", "1", time() + 3600, "/"); // 1h
}

file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT));

header("Content-Type: application/json");

echo json_encode([
    "today" => $data["today"] * 2,
    "yesterday" => $data["yesterday"] * 2
]);