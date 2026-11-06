<?php
// Gộp nhiều bộ icon, bỏ ảnh lặp, không làm mất ảnh độc nhất.
// Dùng:  php hop-nhat.php <thư mục kho> [--giu=<file id cần giữ>] tên1=thưmục1 tên2=thưmục2 ...
//
// Bộ ĐẦU TIÊN là bộ game đang dùng: giữ đủ mọi ID, kể cả ảnh giống nhau (game gọi icon theo ID).
// Các bộ sau đánh số KHÁC game (cùng ID có thể là hình khác hẳn), nên chỉ lấy ảnh có nội dung chưa có:
//   ID chưa có  + ảnh chưa có → hop-nhat/<id>.png
//   ID chưa có  + ảnh đã có   → bỏ (ghi lap-noi-dung.tsv), trừ khi ID nằm trong --giu
//   ID đã có    + ảnh chưa có → ban-khac/<bộ>/<id>.png (xung đột, ảnh độc nhất)
//   ID đã có    + ảnh đã có   → bỏ
// Thứ tự các bộ = thứ tự ưu tiên. Không sửa, không xóa file nguồn. Xóa hop-nhat/ và ban-khac/ trước khi chạy lại.

$args = array_slice($argv, 1);
$keep = [];
foreach ($args as $k => $a) {
    if (strpos($a, '--giu=') === 0) {
        foreach (file(substr($a, 6), FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $id) { $keep[trim($id)] = true; }
        unset($args[$k]);
    }
}
$args = array_values($args);
if (count($args) < 2) {
    fwrite(STDERR, "Cach dung: php hop-nhat.php <thu muc kho> [--giu=file] ten1=thumuc1 ten2=thumuc2 ...\n");
    exit(1);
}
$kho = rtrim(str_replace('\\', '/', array_shift($args)), '/');
$sets = [];
foreach ($args as $a) {
    $p = strpos($a, '=');
    if ($p === false) { fwrite(STDERR, "Sai doi so: $a\n"); exit(1); }
    $dir = rtrim(str_replace('\\', '/', substr($a, $p + 1)), '/');
    if (!is_dir($dir)) { fwrite(STDERR, "Khong thay thu muc: $dir\n"); exit(1); }
    $sets[substr($a, 0, $p)] = $dir;
}
foreach (["$kho/hop-nhat", "$kho/ban-khac"] as $d) {
    if (!is_dir($d)) { mkdir($d, 0777, true); }
}

$chosen = [];   // id => [bộ, md5]
$seen = [];     // md5 => "bộ/id" đầu tiên có ảnh này
$lap = [];      // id bị bỏ vì trùng ảnh => "bộ/id" đã có
$conflicts = []; // id => [bộ thắng, [bộ có bản khác...]]
$alt = [];      // bộ => số ảnh độc nhất giữ ở ban-khac
$got = [];      // bộ => số ID lấy vào hop-nhat
$skipSame = 0;
$first = array_key_first($sets);

foreach ($sets as $name => $dir) {
    $files = glob("$dir/*.png");
    natsort($files);
    foreach ($files as $file) {
        $id = basename($file, '.png');
        $hash = md5_file($file);
        if (isset($chosen[$id])) {
            if ($chosen[$id][1] === $hash) { $skipSame++; continue; }
            $conflicts[$id][0] = $chosen[$id][0];
            $conflicts[$id][1][] = $name;
            if (!isset($seen[$hash])) {
                if (!is_dir("$kho/ban-khac/$name")) { mkdir("$kho/ban-khac/$name", 0777, true); }
                copy($file, "$kho/ban-khac/$name/$id.png");
                $seen[$hash] = "ban-khac/$name/$id";
                $alt[$name] = ($alt[$name] ?? 0) + 1;
            }
            continue;
        }
        if ($name !== $first && isset($seen[$hash]) && !isset($keep[$id])) {
            $lap[$id] = "$name\t" . $seen[$hash];
            continue;
        }
        copy($file, "$kho/hop-nhat/$id.png");
        $chosen[$id] = [$name, $hash];
        $seen[$hash] = $seen[$hash] ?? "$name/$id";
        $got[$name] = ($got[$name] ?? 0) + 1;
    }
    echo str_pad($name, 12), count($files), " file\n";
}

$tsv = fopen("$kho/hop-nhat-nguon.tsv", 'w');
fwrite($tsv, "id\tbo_thang\tbo_khac_noi_dung\n");
uksort($chosen, 'strnatcmp');
foreach ($chosen as $id => [$name]) {
    fwrite($tsv, "$id\t$name\t" . implode(',', $conflicts[$id][1] ?? []) . "\n");
}
fclose($tsv);

$l = fopen("$kho/lap-noi-dung.tsv", 'w');
fwrite($l, "id_bi_bo\tbo\tanh_giong_o\n");
foreach ($lap as $id => $v) { fwrite($l, "$id\t$v\n"); }
fclose($l);

$md = "# Báo cáo gộp icon\n\nThứ tự ưu tiên: " . implode(' > ', array_keys($sets)) . "\n\n";
$md .= "- `hop-nhat/`: **" . count($chosen) . "** ID\n";
$md .= "- `ban-khac/`: **" . array_sum($alt) . "** ảnh độc nhất bị trùng số ID\n";
$md .= "- Bỏ vì trùng hoàn toàn (cùng ID, cùng ảnh): $skipSame file\n";
$md .= "- Bỏ vì ID mới nhưng ảnh đã có (khác số): " . count($lap) . " file, xem `lap-noi-dung.tsv`\n";
$md .= "- ID xung đột: **" . count($conflicts) . "**\n\n";
$md .= "| Bộ | ID vào hop-nhat | Ảnh vào ban-khac |\n|---|---|---|\n";
foreach ($sets as $name => $_) { $md .= "| $name | " . ($got[$name] ?? 0) . " | " . ($alt[$name] ?? 0) . " |\n"; }
$md .= "\n## ID xung đột\n\n| ID | Chọn | Bộ có bản khác |\n|---|---|---|\n";
uksort($conflicts, 'strnatcmp');
foreach ($conflicts as $id => [$win, $others]) { $md .= "| $id | $win | " . implode(', ', $others) . " |\n"; }
file_put_contents("$kho/BAO-CAO-XUNG-DOT.md", $md);

echo "Xong: hop-nhat " . count($chosen) . ", ban-khac " . array_sum($alt) . ", lap ID " . $skipSame . ", lap anh khac so " . count($lap) . ", xung dot " . count($conflicts) . "\n";
