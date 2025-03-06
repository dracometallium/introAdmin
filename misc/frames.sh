#!/bin/sh

commands(){
    dirName=$(dirname "$1")
    baseName=$(basename -s .svg "$1")
    echo "file-open:$1"
    echo "select-all:layers"
    echo "selection-hide"
    echo "export-type:pdf"
    echo "export-overwrite"
    echo "export-area-page"
    i=0
    inkscape --query-all "$1" |
        grep layer |
        sed 's/,.*//' |
        while read -r layer; do
            echo "select:$layer"
            echo "selection-unhide"
            f=$(printf "%0.2d" "$i")
            expFile="$dirName/$baseName-$f.pdf"
            echo "export-filename:$expFile"
            echo "export-do"
            i=$((i + 1))
        done
        echo "file-close"
}

frames(){
    commands "$1" |
        inkscape --shell
}

while [ "0" != "$#" ]; do
    frames "$1"
    shift
done
