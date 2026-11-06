<?php
// Xuất bảng icon_id → item từ item_template ra ICON.md, để tra icon mà không cần mở ảnh.
// Dùng:  php xuat-icon.php [thư mục kho, mặc định ../../kho-anh]
// Cần MySQL đang chạy (DB team10_long, root không mật khẩu; đổi ở 2 dòng dưới nếu máy khác).
// Ra: ICON.md ở gốc repo; <kho>/xung-dot-dang-dung.txt (ID xung đột có item đang dùng).
$dbUser = 'root';
$dbPass = '';

$root = dirname(__DIR__, 2);
$kho = rtrim(str_replace('\\', '/', $argv[1] ?? "$root/kho-anh"), '/');

$conn = new mysqli('127.0.0.1', $dbUser, $dbPass, 'team10_long');
$conn->set_charset('utf8mb4');
$rows = $conn->query('SELECT id, NAME, icon_id, TYPE FROM item_template ORDER BY icon_id, id');

$icons = [];
while ($r = $rows->fetch_assoc()) {
    $icons[(int)$r['icon_id']][] = $r;
}

// id => bộ thắng, các bộ khác nội dung (từ hop-nhat.php)
$nguon = [];
if (is_file("$kho/hop-nhat-nguon.tsv")) {
    foreach (file("$kho/hop-nhat-nguon.tsv", FILE_IGNORE_NEW_LINES) as $i => $line) {
        if ($i === 0) { continue; }
        $c = explode("\t", $line);
        $nguon[$c[0]] = [$c[1], $c[2] ?? ''];
    }
}

$md = "# Bảng icon → vật phẩm\n\n";
$md .= "Xuất từ `item_template` bằng `tools/kho-anh/xuat-icon.php`, đổi DB thì chạy lại. ";
$md .= "Cách dùng và cấu trúc kho ảnh: [ANH.md](ANH.md).\n\n";
$md .= "Cột Xung đột: có bản ảnh khác ở các bộ ghi trong ô (đang dùng bản của `data/icon`). Dấu `!` = `data/icon` không có ảnh, item hiện trống.\n\n";
$md .= "| Icon | Vật phẩm (id: tên) | Xung đột |\n|---|---|---|\n";
$missing = [];
$dangDung = [];
foreach ($icons as $iconId => $items) {
    $names = array_map(fn($r) => $r['id'] . ': ' . str_replace('|', '/', trim($r['NAME'])), $items);
    $info = $nguon[(string)$iconId] ?? null;
    $flag = '';
    if (!is_file("$root/Teamobi2026/data/icon/x4/$iconId.png")) {
        $flag = '!';
        $missing[] = $iconId;
    } elseif ($info !== null && $info[1] !== '') {
        $flag = $info[1];
        $dangDung[] = $iconId . "\t" . $info[0] . "\t" . $info[1] . "\t" . trim($items[0]['NAME']);
    }
    $md .= "| $iconId | " . implode('; ', $names) . " | $flag |\n";
}
file_put_contents("$root/ICON.md", $md);
file_put_contents("$kho/xung-dot-dang-dung.txt", implode("\n", $dangDung) . "\n");
echo count($icons) . " icon dang dung, " . count($dangDung) . " xung dot, " . count($missing) . " thieu anh\n";
if ($missing) { echo 'Thieu: ' . implode(', ', array_slice($missing, 0, 30)) . "\n"; }
