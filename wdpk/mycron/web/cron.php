<?php


/**
* cron.php
* 
* PHP file that updates and delivers files
*/

$file_crontab = "/var/spool/cron/crontabs/www-data";
$file_cronentry = "/mnt/HD/HD_a2/Nas_Prog/mycron/bin/cron.entry";


// write log messages to debug file
function logMsg($msg) {
    file_put_contents("/tmp/debug_apkg", date("Y-m-d H:i:s").'[mycron] [cron.php]'.' '.$msg.PHP_EOL, FILE_APPEND);
}


// POST request
if (isset($_POST['text']))
{

    // logging
    logMsg("POST request");

    // TODO: add validation here!
    // only go on, if entries validated

    // save the cron entries in file
    file_put_contents($file_cronentry, $_POST['text']);
    
    // set new crontab
    $cmd = "crontab -u www-data {$file_cronentry}";
    $out=system($cmd, $retval);
    logMsg("[POST] command retval:"." ".$retval);
    logMsg("[POST] command output:"." ".$out);
    
}


// GET request that requests file contents
if (isset($_GET["file"]))
{

    // *file* parameter
    $filename = $_GET["file"];

    // logging
    logMsg("[GET] file requested:"." ".$filename);

    // cronentry
    if ($filename == "cronentry") {
        $text_return = file_get_contents($file_cronentry);
        echo $text_return;
    }

    // crontab
    if ($filename == "crontab") {
        $text_crontab = file_get_contents($file_crontab);
        echo nl2br(htmlspecialchars($text_crontab));
    }
   
}


?>