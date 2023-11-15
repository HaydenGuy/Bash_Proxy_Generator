#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $(basename "$0") <file or dir to convert>"
    exit 1
fi

if [ -d "$1" ]; then
    arg_1="dir"
elif [ -f "$1" ]; then
    arg_1="file"
else
    echo "Error reading file"
    exit 1
fi

PS3="What resolution would you like to convert to?"
options=("High-Res: 1920x1080" "Mid-Res: 1280x720" "Low-Res: 854x480" "Custom")