<style>
textarea {  
   font-family:"Helvetica, Geneva, Arial, sans-serif";  
   font-size: 15px;
   color: #4B5A68;
   width:100%;
   height:125px;
   white-space: pre;
   overflow-wrap: normal;
   overflow-x: scroll;
}
.cronarea {
   background:#F0F0F0;
   white-space: pre;
   overflow-wrap: normal;
   overflow-x: scroll;
   min-height:125px;
}
</style>


<script>

    function sendCron(){
        var cronentry = document.getElementById("myTextarea").value;
        var xhttp = new XMLHttpRequest();
        xhttp.open("POST", "apps/mycron/cron.php", true);
        xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhttp.send("text="+cronentry); 
        xhttp.onload = () => {
            if (xhttp.readyState === xhttp.DONE) {
                if (xhttp.status === 200) {
                    getCrontab();
                    getCronEntry();
                }
            };
        };
    };

    function getCrontab(){
        var xhttp = new XMLHttpRequest();
        xhttp.open("GET", "apps/mycron/cron.php?file=crontab", true);
        xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhttp.send(null);
        xhttp.onload = () => {
        if (xhttp.readyState === xhttp.DONE) {
            if (xhttp.status === 200) {
                const div = document.getElementById('myCronarea');
                div.innerHTML = xhttp.responseText;

            }
        }
        };
    };

    function getCronEntry(){
        var xhttp = new XMLHttpRequest();
        xhttp.open("GET", "apps/mycron/cron.php?file=cronentry", true);
        xhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhttp.send(null);
        xhttp.onload = () => {
        if (xhttp.readyState === xhttp.DONE) {
            if (xhttp.status === 200) {
                const textarea = document.getElementById('myTextarea');
                textarea.innerHTML = xhttp.responseText;
                textarea.value=xhttp.responseText;

            }
        }
        };
    };

    getCrontab();
    getCronEntry();

</script>


<!-- Title and Description -->
<div class="h1_content header_2"><span class="_text" datafld="title">MyCron</span></div>
<div class="field_top">
    <span class="_text" datafld="title_note">
        <i>MyCron</i> creates and uses a user named <i>www-data</i> to run cronjobs. Why <i>www-data</i>? Because it is left in the sudoers file by WD, and hence allowed to run commands as root. We don't need to hassle with the <i>root</i> user's crontab.<i>MyCron</i> makes a SUID copy of the <i>sudo</i> binary, that can be used to run commands as <i>root</i>.<br><br>
        Put your cronjobs below and hit save afterwards. Be aware that the <b>syntax is not checked</b>. Put a newline after each entry.
    </span>
</div>
<textarea id="myTextarea"></textarea>
<br>

<!-- Button that sends the textarea contents to the cron.php and updates the crontab DIV contents -->
<button onclick="sendCron()">Save</button>


<!-- DIV that shows the current crontab of root user -->
<br>
<div class="field_top"><span class="_text" datafld="title_note"> The following shows the current crontab of the user <i>www-data</i>:</span></div>
<br>
<div class="cronarea" id="myCronarea"></div>
<br>
