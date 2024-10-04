#!/bin/bash

# Function to set password policy
set_password_policy() {
    echo "Setting password policy..."

    # Set maximum password age to 90 days
    echo "Setting maximum password age to 90 days..."
    sudo chage --maxdays 90 -m 1 -M 90 -I -1 -l -1 root

    # Set minimum password length to 12 characters
    echo "Setting minimum password length to 12 characters..."
    if grep -q "pam_unix.so" /etc/pam.d/common-password; then
        # Backup the original file
        sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.bak
        sudo sed -i 's/^password\s*required\s*pam_unix.so/password required pam_unix.so min=12/' /etc/pam.d/common-password
    else
        echo "Could not find pam_unix.so in common-password file."
    fi

    # Set password complexity requirements
    echo "Setting password complexity requirements..."
    if grep -q "pam_pwquality.so" /etc/pam.d/common-password; then
        # Backup the original file
        sudo cp /etc/pam.d/common-password /etc/pam.d/common-password.bak
        sudo sed -i 's/^password\s*required\s*pam_unix.so/password required pam_pwquality.so retry=3 minclass=4/' /etc/pam.d/common-password
    else
        echo "Could not find pam_pwquality.so in common-password file."
    fi

    echo "Password policy has been updated."
}

# Run the password policy configuration
set_password_policy

# Inform the user
echo "Please inform users about the new password policy requirements."
