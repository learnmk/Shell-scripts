
#!/bin/bash
# This script take backup of directory from remote server on backup server using rsync. 
# Make sure passowrdless ssh configuration already configure between both hosts for succesfull execution of script.

# Remote server details
remote_user="username"
remote_server="remote_server_address"
remote_directory="remote_directory_path"

# Local backup directory
backup_dir="backup"
timestamp=$(date +"%Y%m%d%H%M%S")

# Ensure the local backup directory exists
mkdir -p "$backup_dir"

# Use rsync to copy files from the remote server to the local backup directory
rsync -avz -e ssh "$remote_user@$remote_server:$remote_directory" "$backup_dir/backup_$timestamp/"

echo "Backup completed and saved to $backup_dir/backup_$timestamp/"

