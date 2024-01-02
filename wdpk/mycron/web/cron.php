<?php


/**
* cron.php
* 
* PHP file that updates and delivers files
*/

$file_crontab = "/var/spool/cron/crontabs/www-data";

// write log messages to debug file
function logMsg($msg) {
    file_put_contents("/tmp/debug_apkg", date("Y-m-d H:i:s").'[mycron] [cron.php]'.' '.$msg.PHP_EOL, FILE_APPEND);
}


// POST request
if (isset($_POST['text']))
{

    // logging
    logMsg("POST request");

    // save the cron entries in file
    file_put_contents($file_crontab, base64_decode($_POST['text']));

}


// GET request that requests file contents
if (isset($_GET["file"]))
{
    $text_return = file_get_contents($file_crontab);
    echo $text_return;
}


?>