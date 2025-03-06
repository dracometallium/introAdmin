#!/bin/sh

for img in "$@"; do
    if [ "$(identify -ping -format "%[fx:w]\n" "$img")" -gt 1080 ]; then
        mogrify -verbose -resize "1080x>" "$img"
    fi
done
