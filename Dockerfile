FROM balenalib/rpi-raspbian:buster
RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y supervisor nginx php7.3-fpm php7.3-cli php7.3-common php-apcu apache2-utils gpac motion zip ffmpeg gstreamer1.0-tools
WORKDIR /rpicam
COPY bin /rpicam/bin
COPY etc /rpicam/etc
COPY www /rpicam/www
COPY config.txt install.sh cam.sh /rpicam/
RUN chmod o+x *.sh \
 && sed -i 's/\[\[/\[/g' install.sh \
 && sed -i 's/\]\]/\]/g' install.sh \
 && sed -i 's/\[/\[\[/g' install.sh \
 && sed -i 's/\]/\]\]/g' install.sh \
 && mkdir -p /opt/vc/bin \
 && touch /etc/rc.local \
 && ./install.sh q
RUN sed -i "s/server_name localhost;/server_name _;/g" /etc/nginx/sites-enabled/rpicam
COPY docker-files/supervisor.conf			/etc/supervisor.conf
COPY docker-files/nginx.conf				/etc/nginx/nginx.conf
COPY docker-files/php-fpm.conf				/etc/php/7.3/fpm/pool.d/www.conf
COPY docker-files/start_vid.sh				/var/www/macros/start_vid.sh
COPY docker-files/end_vid.sh				/var/www/macros/end_vid.sh
COPY docker-files/capture_images.sh			/var/www/macros/capture_images.sh
COPY docker-files/stop_capture_images.sh	/var/www/macros/stop_capture_images.sh
COPY docker-files/schedule.json				/var/www/schedule.json
COPY docker-files/uconfig					/var/www/uconfig
RUN mkdir -p -m 0777 /run/php
COPY docker-entrypoint.sh /rpicam/
RUN chmod u+x docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["supervisord", "-c", "/etc/supervisor.conf"]
