#!/bin/bash
set -e

if [ "$1" = 'google-chrome' ]; then
    if [ -d $HOME/extensions ]; then
        exec "$@" --load-extension=$(ls -d $HOME/extensions/*/ | xargs echo | sed 's/ /,/g')
    fi
fi

exec "$@"
