#!/bin/bash

source $(dirname $(readlink -f $0))/helper.sh

log "called $0 with $@"

duration=${CAPTURE_IMAGES_DURATION:-20}
interval=${CAPTURE_IMAGES_INTERVAL:-2}
file_fifo=/var/www/FIFO11

log "starting image motion capture"

while [[ $duration>0 ]]; do
	log "capturing image - $duration sec to go"
	echo "im">$file_fifo
	duration=$((duration - $interval))
	sleep $interval
done
