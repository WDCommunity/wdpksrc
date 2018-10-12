#!/bin/sh

. $(dirname $0)/incl

#copy firmware to /lib/firmware
if [ -d /lib/firmware ]; then
	ln -s ${TVM_ROOT_DIR}/share/firmware/* /lib/firmware/
else
	ln -s ${TVM_ROOT_DIR}/share/firmware /lib/firmware
fi

export LD_LIBRARY_PATH=${TVM_ROOT_DIR}/lib
export TVMOSAIC_ROOT_CONFIG_DIR=${TVM_ROOT_DIR}

${TVM_ROOT_DIR}/tvmosaic_server -command_line_mode &
