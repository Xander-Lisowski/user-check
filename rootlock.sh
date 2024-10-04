#/bin/bash

# List of users to restrict from using sudo
RESTRICTED_USERS=("perry" "carlos" "kan" "alice" "josefina")  # Replace with actual usernames

# Function to restrict users from sudo
restrict_users() {
    echo "Restricting users from using sudo..."

    # Backup the sudoers file
    sudo cp /etc/sudoers /etc/sudoers.bak

    # Loop through the list of restricted users
    for user in "${RESTRICTED_USERS[@]}"; do
        echo "Adding restriction for user: $user"
        echo "$user ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/$user
    done

    echo "Restrictions have been applied."
}

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Call the function to restrict users
restrict_users
