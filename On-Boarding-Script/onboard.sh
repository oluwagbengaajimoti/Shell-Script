# Shell Scripting.
# his script will read a CSV file that contains 20 new Linux users.
# This script will create each user on the server and add to an existing group called 'Developers'. 4 # This script will first check for the existence of the user on the system, before it will attempt to create
# The user that is being created also must also have a default home folder
# Each user should have a .ssh folder within its HOME folder. If it does not exist, then it will be created.
# For each user's SSH configuration, We will create an authorized keys file and add the below public key.

#!/bin/bash

userfile=$(cat users.csv)
PASSWORD=password
group_name=developer

# Checking if the current user running this has sudo privilege
if [ $(id -u) -eq 0 ];
then

    #This is a check if the group already exist
    if [ $(getent group $group_name) ];
    then
        echo $group_name group already exist
    else
        sudo groupadd $group_name
        echo $group_name has been successfully created
    fi

    # Reading the CSV file
    for user in $userfile;
        do
            if [ $(getent passwd $user) ];
            then
                echo $user already exist in the $group_name group
            else
                # This will create a new user
                useradd -m -g $group_name $user
                echo "$user account has been created"


                # This will create a ssh folder in the user home folder

                su - -c "mkdir ~/.ssh" $user
                echo ".ssh directory created for $user"

                # we need to set the user permission for the ssh dir

                su - -c "chmod 700 ~/.ssh" $user
                echo "user permission for .ssh directory set"

                #This will create an authorized-key file

                su - -c "touch ~/.ssh/authorized_keys" $user
                echo "Authorized Key File Created"

                # We need to set permission for the key file
                su - -c "chmod 600 ~/.ssh/authorized_keys" $user
                echo "user permission for the Authorized Key File set"

                # We need to create and set public key for users in the server
                cp -R "/home/ubuntu/shell/id_rsa.pub" "/home/$user/.ssh/authorized_keys"
                echo "Copied the Public Key to New User Account on the server"
                echo "USER CREATE"

                # Generate a password.

                sudo echo -e "$PASSWORD\n$PASSWORD" | sudo passwd "$user"
                sudo passwd -x 5 $user
            fi
        done
else
    echo "Only Admin Can Onboard A User"
fi