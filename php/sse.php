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
    $result = mysqli_query($con,"SELECT * FROM (SELECT * FROM webmsg WHERE session='" . $session . "' ORDER BY id DESC LIMIT 2) AS t ORDER BY id ASC");
    $flag = 0;
    while($row = mysqli_fetch_array($result))
    {
        if(strtoupper($row['text']) == 'DO A BARREL ROLL' && $flag == 1)
            return 'do a barrel roll';

        $class = " class='bubbleOdd' ";
        if($flag == 1) {
            $class = " class='bubbleEven' ";
            $flag = 0;
        }
        else {
            $flag = 1;
        }
        // $res = $res . '<b>' . $row['user'] . '@' . $row['time'] . "</b><br/>" . $row['text'] . '<br/></span><br/><br/>';
        // $res = $res . '<span' . $class. '><b>' . $row['user'] . '@' . $row['time'] . "</b><br/>" . $row['text'] . '<br/></span>';
        $res = $res . '<td style="width: 50%; height: 100%;"' . $class. '><b>' . $row['user'] . "</b><br/>" . $row['text'] . '</td>';
    }
    $res = '<table style="width: 100%; height: 100%;"><tr style="width: 100%; height: 100%;">' . $res . '</tr></table>';
mysqli_close($con);
return $res;
}

function sendMsg($id, $msg) {
    echo "id: $id" . PHP_EOL;
    echo "data: $msg" . PHP_EOL;
    echo PHP_EOL;
    ob_flush();
    flush();
}

$serverTime = time();
sendMsg($serverTime, fetchDB($session));
?>
