#!/bin/sh
INST_PATH=/mnt/HD/HD_a2/Nas_Prog/myshellscript
TMP_PATH=/var/tmp/
WEB_PATH=/var/www/apps/myshellscript/
LOG=/tmp/debug_apkg

log(){
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    echo "$TIME [myshellscript] [$(basename $0)] $1" >> $LOG
}

beforeapkg_sh() {
	log "Script called: $0 $@"
}

preinst_sh() {
	log "Script called: $0 $@"
	log "Make backup of myscript.sh"
	cp $INST_PATH/bin/myscript.sh $TMP_PATH
}

install_sh() {
	log "Script called: $0 $@"
	mv -f $1 $2
}

remove_sh() {
	log "Script called: $0 $@"
	log "Remove app path \"$1\""
	rm -rf $1
}

stop_sh() {
	log "Script called: $0 $@"

}

init_sh() {
	log "Script called: $0 $@"
	log "Create symlink for webpage \"$WEB_PATH\""
	mkdir -p $WEB_PATH
	ln -sf $1/web/* $WEB_PATH
	log "Restore myscript.sh"
	cp $TMP_PATH/myscript.sh $INST_PATH/bin/myscript.sh 2> /dev/null
	rm $TMP_PATH/myscript.sh 2> /dev/null
}

start_sh() {
	log "Script called: $0 $@"
	log "Run myscript.sh"
	. $INST_PATH/bin/myscript.sh
}

clean_sh() {
	log "Script called: $0 $@"
	log "Remove symlink of web path \"$WEB_PATH\""
	rm -rf $WEB_PATH
}
