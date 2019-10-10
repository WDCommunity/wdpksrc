#!/bin/sh

APKG_PATH=$(readlink -f $1)
. ${APKG_PATH}/env

echo "INIT linking files from path: ${APKG_PATH}" >> $LOG

# create directory for the webpage TODO FIX ME
WEBDIR="/var/www/${APKG_NAME}/"
mkdir -p ${WEBDIR}
ln -sf ${APKG_PATH}/web/* ${WEBDIR}


# remove SSL modules to make room for the lighttpd webserver
# renaming the suffix is sufficient
MODS=/usr/local/apache2/conf/mods-enabled
if [ -e ${MODS}/ssl.load ]; then
	mv ${MODS}/ssl.load ${MODS}/ssl.load.not
	mv ${MODS}/ssl.conf ${MODS}/ssl.conf.not
fi

echo "reload WD web without SSL"
PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/local/sbin:/usr/local/bin/usr/sbin: /usr/sbin/lighty restart

# no need to touch the mysql db
#[[ -n $(pidof mysqld) ]] && kill $(pidof mysqld)

echo "increase /tmp size"
mount -o remount,size=300M /tmp

echo "setup occ symlink"
cat << EOF > /usr/sbin/occ
#!/bin/sh
sudo -u cloud /opt/bin/php /opt/share/www/owncloud/occ "\$@"
EOF

cat << EOF > /usr/sbin/ncc
#!/bin/sh
sudo -u cloud /opt/bin/php /opt/share/www/nextcloud/occ "\$@"
EOF
chmod +x /usr/sbin/?cc

