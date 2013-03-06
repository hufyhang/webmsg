<?php
$user = $_GET['user'];
$session = $_GET['session'];
$msg = urldecode($_GET['msg']);
$serverTime = date('r');

$con=mysqli_connect("31.22.4.32","feifeiha_public","p0OnMM722iqZ","feifeiha_webmsg");

// Check connection
if (mysqli_connect_errno($con))
{
    $res = "Failed to connect to MySQL: " . mysqli_connect_error();
}
mysqli_query($con,"INSERT INTO webmsg (time, user, text, session) VALUES ('" . $serverTime . "', '" . $user . "', '" . $msg . "', '" . $session . "')");
mysqli_close($con);
?>
