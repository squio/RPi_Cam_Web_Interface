#!/bin/bash

rpicamdir=/var/www
rpicam_nginx_conf=/etc/nginx/sites-available/rpicam
user_pass=$USER_PASS

if [[ "$user_pass" != "" ]]; then
	user=$(echo $user_pass | cut -d: -f1)
	pass=$(echo $user_pass | cut -d: -f2)
	sudo htpasswd -b -c /usr/local/.htpasswd $user $pass
	sed -i "s/auth_basic\ .*/auth_basic \"Restricted\";/g" $rpicam_nginx_conf
	sed -i "s/#auth_basic_user_file/\ auth_basic_user_file/g" $rpicam_nginx_conf
fi

echo /opt/vc/lib > /etc/ld.so.conf
ldconfig

if [[ ! -e /usr/bin/raspimjpeg ]]; then
	cp bin/raspimjpeg /opt/vc/bin/
	chmod 0755 /opt/vc/bin/raspimjpeg
	ln -s /opt/vc/bin/raspimjpeg /usr/bin/raspimjpeg
fi

if [[ ! -e /dev/shm/mjpeg/status_mjpeg.txt ]]; then
	mkdir -p /dev/shm/mjpeg
	chmod 0777 /dev/shm/mjpeg
	touch /dev/shm/mjpeg/status_mjpeg.txt
	chmod 0666 /dev/shm/mjpeg/status_mjpeg.txt
	touch /dev/shm/mjpeg/cam.jpg
	chmod 0666 /dev/shm/mjpeg/cam.jpg
fi

:>/var/www/html/scheduleLog.txt
chown -R www-data:www-data $rpicamdir
chmod 0777 $rpicamdir/media
chmod 0666 $rpicamdir/schedule.json
chmod 0666 $rpicamdir/uconfig

exec "$@"
