#!/bin/bash

apt update

username=$1

# Check if script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root."
   exit 1
fi

# Check if user already exists
if id "$username" >/dev/null 2>&1; then
   echo "User $username already exists. SKIPPED"
else
   # Create the user
   adduser --disabled-password --gecos "" "$username"

   # Add user to the sudo group
   usermod -aG sudo "$username"

   # Display success message
   echo "User $username has been created and added to the sudo group."
fi

# Create SSH directory for user
if id "$username" >/dev/null 2>&1; then
   mkdir -p /home/$username/.ssh
   chown -R username:$username /home/$username/.ssh
   echo "SSH directory for $username created."
else
   echo "Unable to create SSH directory for $username. Does not exist."
fi
