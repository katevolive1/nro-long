<?php
if (session_status() === PHP_SESSION_NONE) session_start();
if (isset($_SESSION['user']) && !isset($_SESSION['username'])) {
    $_SESSION['username'] = $_SESSION['user'];
}
require_once __DIR__ . '/connect.php';
