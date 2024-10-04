#!/bin/bash

# Check if the authorized users file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /path/to/authorized_users.txt"
    exit 1
fi

# File containing the list of authorized users
AUTHORIZED_USERS_FILE="$1"

# Check if the file exists
if [ ! -f "$AUTHORIZED_USERS_FILE" ]; then
    echo "File not found: $AUTHORIZED_USERS_FILE"
    exit 1
fi

# Read the authorized users into an array
mapfile -t AUTHORIZED_USERS < "$AUTHORIZED_USERS_FILE"

# Get the list of all system users
ALL_USERS=$(cut -d: -f1 /etc/passwd)

# Convert the authorized users array into a string for easy comparison
AUTHORIZED_USERS_STRING=$(printf "%s\n" "${AUTHORIZED_USERS[@]}")

# Loop through all users and delete unauthorized ones
for USER in $ALL_USERS; do
    if ! echo "$AUTHORIZED_USERS_STRING" | grep -qw "$USER"; then
        echo "Deleting unauthorized user: $USER"
        sudo userdel -r "$USER"  # -r option removes the user's home directory
    fi
done

echo "Unauthorized user deletion process completed."
