#!/bin/sh

. $(dirname $0)/incl

#copy firmware to /lib/firmware
cp -rf ${TVM_ROOT_DIR}/share/firmware/* /lib/firmware/

export LD_LIBRARY_PATH=${TVM_ROOT_DIR}/lib
export TVMOSAIC_ROOT_CONFIG_DIR=${TVM_ROOT_DIR}

${TVM_ROOT_DIR}/tvmosaic_server -command_line_mode &
