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

PS3="What resolution would you like to convert to? "
options=("High-Res:1920x1080" "Mid-Res:1280x720" "Low-Res:854x480" "Custom" "Exit")

width=""
height=""
            

select choice in "${options[@]}"; do
    case "$choice" in
        "High-Res:1920x1080")
            width="1920"
            height="1080"
            break
            ;;
        "Mid-Res:1280x720")
            width="1280"
            height="720"
            break
            ;;
        "Low-Res:854x480")
            width="854"
            height="480"
            break
            ;;
        "Custom")
            echo "Please enter a positive width and height. Type quit to exit the application"
            while ! [[ $width =~ ^[1-9][0-9]*$ && $height =~ ^[1-9][0-9]*$ ]]; do
                read -p "Resolution Width: " width

                if [[ $width == "quit" ]]; then
                    exit 1
                fi

                read -p "Resolution Height: " height

                if [[ $height == "quit" ]]; then
                    exit 1
                fi

                if ! [[ $width =~ ^[1-9][0-9]*$ && $height =~ ^[1-9][0-9]*$ ]]; then
                    echo "Invalid input. Please enter positive numbers for both width and height."
                fi
            done
            break
            ;;
        "Exit")
            exit 1
            ;;
        *)
            echo -e "\nInvalid option. Please enter a number from 1 to ${#options[@]}\n"
            ;;
    esac
done

resolution="${width}x${height}"

file_name=""
while [ -z "$file_name" ]; do
    read -p "What should your file(s) be called? " file_name
done

output_dir=""
while [ -z "$output_dir" ]; do
    read -ep "Where should your file(s) be saved (cwd for current directory)? " output_dir
done

if [ "$output_dir" == "cwd" ]; then
    output_dir="$(pwd)"
fi

if [ -d "$output_dir" ]; then
    if [ "$arg_1" == "file" ]; then
        ffmpeg -i "$1" -c:v "libx264" -s "$resolution" "$output_dir/$file_name$count.mp4"
    elif [ "$arg_1" == "dir" ]; then
        count=1
        for file in "$1"/*; do
            if [ -f "$file" ] && [ "$file" != "$0" ]; then
                ffmpeg -i "$file" -c:v "libx264" -s "$resolution" "$output_dir/$file_name$count.mp4"
                count=$((count+1))
            fi
        done
    else
        echo "Invalid file or output directory"
        exit 1
    fi
fi