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
</style>


<script>

    function sendMyShellScript(){
        var b64_text = encodeURIComponent(btoa(document.getElementById("myTextarea").value));
        var xhttp = new XMLHttpRequest();
        xhttp.open("POST", "apps/myshellscript/myshellscript.php", true);
        xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhttp.send("text="+b64_text); 
        xhttp.onload = () => {
            if (xhttp.readyState === xhttp.DONE) {
                if (xhttp.status === 200) {
                    getMyShellScript();
                }
            };
        };
    };

    function getMyShellScript(){
        var xhttp = new XMLHttpRequest();
        xhttp.open("GET", "apps/myshellscript/myshellscript.php", true);
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

    getMyShellScript();

</script>


<!-- Title and Description -->
<div class="h1_content header_2"><span class="_text" datafld="title">MyShellScript</span></div>
<div class="field_top">
    <span class="_text" datafld="title_note">
        <i>MyShellScript</i> runs the following script at bootup of your MyCloud NAS. Insert any desired commands to tweak the system!<br><br>
        Be aware that the script is <b>not</b> executed after clicking <i>Save</i>. In order to trigger it, you'll need to Stop and Start the app.
    </span>
</div>
<textarea id="myTextarea"></textarea>
<br>

<!-- Button that sends the textarea contents to the myshellscript.php -->
<button onclick="sendMyShellScript()">Save</button>
