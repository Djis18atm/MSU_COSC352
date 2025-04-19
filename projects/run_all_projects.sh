#!/bin/bash

# Accept project directory as a parameter
if [ -z "$1" ]; then
    echo "Usage: $0 <project_directory>"
    exit 1
fi

PROJECTS_DIR="$1"
PARAMS="thisisaname 10"

# Stage 1: Build all Docker images
images=()
image_dirs=()
for project_path in "$PROJECTS_DIR"/*/; do
    project_num=$(basename "$project_path")
    
    for user_dir in "$project_path"/*/; do
        [ -d "$user_dir" ] || continue
        user_name=$(basename "$user_dir")
        
        # Skip directories that are not in <string>_<string> format
        if ! [[ "$user_name" =~ ^[a-zA-Z]+_[a-zA-Z]+$ ]]; then
            continue
        fi
        
        image_name="project_${project_num}:${user_name}"
        images+=("$image_name")
        image_dirs+=("$user_dir")

        echo "Building Docker image: $image_name"
        docker build -t "$image_name" "$user_dir"
    done
done

# Stage 2: Run all Docker containers
for i in "${!images[@]}"; do
    image_name="${images[$i]}"
    user_dir="${image_dirs[$i]}"
    project_num=$(echo "$image_name" | grep -oE '[0-9]+')
    user_name=$(echo "$image_name" | sed 's/^project_[0-9]+_//')
    
    if [[ "$project_num" == "1" || "$project_num" == "2" ]]; then
        output=$(docker run --rm "$image_name" $PARAMS)
    else
        output=$(docker run --rm "$image_name")
    fi
    
    project_extensions=()
    while IFS= read -r -d '' file; do
        ext="${file##*.}"
        [[ "$ext" != "$file" && ! " ${project_extensions[*]} " =~ " $ext " ]] && project_extensions+=(".$ext")
    done < <(find "$user_dir" -type f -print0)
    
    echo "project $project_num for $user_name (${project_extensions[*]}): $output"
done
