#!/bin/bash

# Get the current directory
current_directory=$(pwd)

# Find all JPEG images in the current directory
jpeg_images=$(find "$current_directory" -name "*.jpg")

# Initialize the counter
counter=1

# Rename each JPEG image
for image in $jpeg_images; do

  # Rename the image to "anish-" followed by the counter and the file extension
  new_name="anish-$(printf "%04d" $counter).jpg"
  mv "$image" "$new_name"

  # Increment the counter
  counter=$((counter + 1))

done
