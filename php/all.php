<?php
$session = $_GET['session'];
header('Content-Type: text/event-stream');
header('Cache-Control: no-cache'); // recommended to prevent caching of event data.

function fetchDB($session) {
    $res = '';
    $con=mysqli_connect("31.22.4.32","feifeiha_public","p0OnMM722iqZ","feifeiha_webmsg");

    // Check connection
    if (mysqli_connect_errno($con))
    {
        $res = "Failed to connect to MySQL: " . mysqli_connect_error();
    }
    $result = mysqli_query($con,"SELECT * FROM (SELECT * FROM webmsg WHERE session='" . $session . "' ORDER BY id DESC LIMIT 20) AS t ORDER BY id ASC");
    while($row = mysqli_fetch_array($result))
    {
        $res = $res . '<b>' . $row['user'] . '@' . $row['time'] . "</b><br/>" . $row['text'] . '<br/></span><br/><br/>';
    }
    mysqli_close($con);
    return $res;
}

echo fetchDB($session);
?>
