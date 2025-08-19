#!/bin/bash
# user_add.sh - Simple User Creation Script for RHEL

# Must run as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ Please run as root (use sudo)."
    exit 1
fi

# Ask for username
read -p "Enter the username: " username

# Check if user exists
if id "$username" &>/dev/null; then
    echo "⚠️ User '$username' already exists!"
    exit 1
fi

# Optional UID
read -p "Enter UID (or press Enter for default): " userid

# Optional group
read -p "Enter group name (or press Enter to skip): " groupname

# Build useradd command
cmd="useradd $username"

if [ -n "$userid" ]; then
    cmd="$cmd -u $userid"
fi

if [ -n "$groupname" ]; then
    # Create group if not found
    if ! getent group "$groupname" > /dev/null; then
        groupadd "$groupname"
        echo "✅ Group '$groupname' created."
    fi
    cmd="$cmd -g $groupname"
fi

# Run command
$cmd
if [ $? -eq 0 ]; then
    echo "✅ User '$username' created successfully."
    passwd "$username"
else
    echo "❌ Failed to create user."
fi

