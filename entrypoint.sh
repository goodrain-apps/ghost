#!/bin/bash

[[ $DEBUG ]] && set -x

if [[ -z $SITE_URL ]]; then
    echo "please set your blog site, through system env 'SITE_URL' to set"
    exit 1
fi


set -e

if [[ "$*" == npm*start* ]]; then
	baseDir="$GHOST_SOURCE/content"
	for dir in "$baseDir"/*/ "$baseDir"/themes/*/; do
		targetDir="/data/${dir#$baseDir/}"
		mkdir -p "$targetDir"
		if [ -z "$(ls -A "$targetDir")" ]; then
			tar -c --one-file-system -C "$dir" . | tar xC "$targetDir"
		fi
	done

	cp /tmp/config.js /data/
    sed -i "s#SITE_URL#$SITE_URL#" /data/config.js

	ln -sf "/data/config.js" "$GHOST_SOURCE/config.js"

	chown -R 200.200 /data/

	set -- gosu rain "$@"
fi

sleep ${PAUSE:-0}

exec "npm start"
