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

resolution=""

select choice in "${options[@]}"; do
    case "$choice" in
        "High-Res:1920x1080")
            resolution="high"
            break
            ;;
        "Mid-Res:1280x720")
            resolution="mid"
            break
            ;;
        "Low-Res:854x480")
            resolution="low"
            break
            ;;
        "Custom")
            width=""
            height=""
            
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