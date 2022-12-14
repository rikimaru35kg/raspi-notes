#!/bin/bash

sudo rsync -abv --delete --backup-dir="/media/pi/RASPI 000 MAIN/delete_backup/backup-$(date +%Y%m%d-%H%M%S)" /media/pi/RASPI\ 000\ MAIN/   /media/pi/RASPI\ 000\ SUB/ --exclude '$RECYCLE.BIN' --exclude 'Sytem Volume Information'
