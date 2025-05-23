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

ls -ltr "$directory"
echo "Preview of files to be renamed:"
find "$directory" -type f -name 'prefix*.txt' | head -n 5

find "$directory" -type f -name 'prefix*.txt' | while read file; do
    base=$(basename "$file")
    dir=$(dirname "$file")
    number=$(echo "$base" | sed -E 's/prefix([0-9]+)\.txt/\1/')
    new_number=$((number + 1))
    new_file="$dir/prefix${new_number}.txt"
    mv "$file" "$new_file"
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

