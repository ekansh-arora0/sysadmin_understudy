#!/bin/bash

if [[ "$1" == "--help" ]]; then
    cat <<EOF
This script renames files in a directory, incrementing the number in the filenames.
Usage: ./file_rename_script.sh [directory]
EOF
    exit 0
fi

if [ -z "$1" ]; then
    echo "Error: No directory provided." >&2
    echo "Usage: ./file_rename_script.sh [directory]" >&2
    exit 1
fi

directory="$1"

if [ ! -d "$directory" ]; then
    echo "Error: Directory '$directory' does not exist." >&2
    exit 1
fi

echo "Preview of files to be renamed:"
find "$directory" -type f -name 'prefix*.txt' | head -n 5

find "$directory" -type f -name 'prefix*.txt' | while read file; do
    new_name=$(echo "$file" | awk -F'[/.]' '{num=substr($1,7); print substr($0, 0, length($0)-length($2)) (num+1) ".txt"}')
    mv "$file" "$new_name"
done

echo "Files renamed: "
find "$directory" -type f -name 'prefix*.txt' | wc -l

if [ "$(find "$directory" -type f -name 'prefix*.txt' | wc -l)" -eq 0 ]; then
    echo "All files have been successfully renamed." >&2
else
    echo "Some files were not renamed!" >&2
fi

echo "List of renamed files:"
find "$directory" -type f -name 'prefix*.txt' | tail -n 10

find "$directory" -type f -name 'prefix*.txt' | xargs cat
