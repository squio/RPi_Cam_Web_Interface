#!/bin/bash

source $(dirname $(readlink -f $0))/helper.sh

log "called $0 with $@"
log "starting video capture to: $1"

if [ -n "$CAPTURE_IMAGES" ]; then
	/var/www/macros/stop_capture_images.sh $@
	/var/www/macros/capture_images.sh $@ &
fi
