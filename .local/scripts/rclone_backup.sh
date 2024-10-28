#!/bin/bash
# Script to sync my "~/Documents" folder with Dropbox using `rclone`.

# Find version managed folders and exclude them.
find ~/Documents -type d -name '.git' | sed 's\.git\\' | sed 's\/home/sahel/Documents/\\' > exclude-file.txt

# Specify other folders to exclude.
cat << EOF >> exclude-file.txt
out_dir/
aux_dir/
EOF

# Dry run to see what will be synced.
rclone sync --dry-run --skip-links /home/sahel/Documents Dropbox:Thinkpad_Backup --exclude-from exclude-file.txt --exclude '.obsidian/'

read -p "Perform operations (y/n)? " confirmation
case $confirmation in
  y)
    rclone sync --skip-links --verbose /home/sahel/Documents Dropbox:Thinkpad_Backup --exclude-from exclude-file.txt --exclude '.obsidian/'
    rm exclude-file.txt
  ;;
  *)
    rm exclude-file.txt
    exit
  ;;
esac
