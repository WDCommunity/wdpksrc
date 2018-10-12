#!/bin/bash

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$(readlink -f $1)
NAS_PROG=$(readlink -f $2)

cp -rf ${INSTALL_DIR} ${NAS_PROG} >> /tmp/debug_apkg

# get available volume
#VOL_PATH="`servicetool --get-first-alive-volume`"

SHARE_NAME="TVMosaic"
SHARE_PATH="/shares/Volume_1/${SHARE_NAME}"

# create a first-level directory which is named as ${SHARE_NAME} in a volume
# TODO: create an actual OS3 share to store recordings
if [ !- ]; then
  # create folder and set rights
  mkdir -p ${SHARE_PATH}
fi

PKG_DEST=${NAS_PROG}/tvmosaic/tvm

ln -sf ${SHARE_PATH} ${PKG_DEST}/share

#copy shared.inst to share and delete it afterwards
cp -rpaf ${PKG_DEST}/shared.inst/* $SHARE_PATH/
rm -rf ${PKG_DEST}/shared.inst

#mkdir -p -m u=rwx,g=r,o=r $SHARE_PATH/RecordedTV

#chown +rw $SHARE_PATH/xmltv
#chown +rw $SHARE_PATH/channel_logo

${PKG_DEST}/reg.sh -preparenewinstall "${PKG_DEST}" "${PKG_DEST}/data" "$SHARE_PATH"
${PKG_DEST}/reg.sh -reginstall "${PKG_DEST}/data/common/product_info/tvmosaic.xml" install

echo "Install finished" >> /tmp/debug_apkg
