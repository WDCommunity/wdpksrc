<?php

$file_myscript = "/mnt/HD/HD_a2/Nas_Prog/myshellscript/bin/myscript.sh";

function logMsg($msg) {
    file_put_contents("/tmp/debug_apkg", date("Y-m-d H:i:s").'[myshellscript] [myshellscript.php]'.' '.$msg.PHP_EOL, FILE_APPEND);
}

if (isset($_POST['text']))
{
    logMsg("POST request");
    file_put_contents($file_myscript, base64_decode($_POST['text']));
} else 
{
    logMsg("GET request");
    $text_return = file_get_contents($file_myscript);
    echo $text_return;
}

?>