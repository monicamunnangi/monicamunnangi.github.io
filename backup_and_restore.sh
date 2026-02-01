#!/bin/bash

# Script to backup and restore website files

# Function to display usage information
show_usage() {
  echo "Usage: $0 [backup|restore]"
  echo ""
  echo "Commands:"
  echo "  backup   - Create a backup of the current website files"
  echo "  restore  - Restore the website from the most recent backup"
  echo ""
}

# Function to create a backup
create_backup() {
  echo "Creating backup of website files..."
  
  # Create backup directory if it doesn't exist
  mkdir -p website_backups
  
  # Create a timestamped backup folder
  TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
  BACKUP_DIR="website_backups/backup_$TIMESTAMP"
  mkdir -p "$BACKUP_DIR"
  
  # Copy current files to backup directory
  cp index.html "$BACKUP_DIR/"
  cp stylesheet.css "$BACKUP_DIR/"
  
  # Create a marker file to indicate this is the latest backup
  echo "$TIMESTAMP" > website_backups/latest_backup
  
  echo "Backup created successfully in $BACKUP_DIR"
  echo "You can now safely make changes to your website."
}

# Function to restore from backup
restore_from_backup() {
  echo "Restoring website from backup..."
  
  # Check if backup exists
  if [ ! -f website_backups/latest_backup ]; then
    echo "Error: No backup found. Please run the backup command first."
    exit 1
  fi
  
  # Get the latest backup timestamp
  LATEST_BACKUP=$(cat website_backups/latest_backup)
  BACKUP_DIR="website_backups/backup_$LATEST_BACKUP"
  
  # Check if the backup directory exists
  if [ ! -d "$BACKUP_DIR" ]; then
    echo "Error: Backup directory $BACKUP_DIR not found."
    exit 1
  fi
  
  # Remove new files
  echo "Removing new enhancement files..."
  rm -f stylesheet-additions.css banner-enhancement.js enhancement-loader.js job-market-banner.html index-new.html
  
  # Restore original files
  echo "Restoring original files..."
  cp "$BACKUP_DIR/index.html" ./
  cp "$BACKUP_DIR/stylesheet.css" ./
  
  echo "Website restored successfully from backup $LATEST_BACKUP"
}

# Main script logic
if [ $# -eq 0 ]; then
  show_usage
  exit 1
fi

case "$1" in
  backup)
    create_backup
    ;;
  restore)
    restore_from_backup
    ;;
  *)
    echo "Error: Unknown command '$1'"
    show_usage
    exit 1
    ;;
esac

exit 0