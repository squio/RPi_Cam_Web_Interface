#!/bin/bash

source $(dirname $(readlink -f $0))/helper.sh

log "called $0"

log "stopping image capture..."
sudo kill $(sudo ps aux | grep 'capture_images' | awk '{print $2}')&>/dev/null
log "done."
