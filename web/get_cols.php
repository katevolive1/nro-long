<?php
require_once "config.php";
$res = $conn->query("SHOW COLUMNS FROM history_transaction");
$cols = [];
while($row = $res->fetch_assoc()) {
    $cols[] = $row['Field'];
}
echo json_encode($cols);
?>
