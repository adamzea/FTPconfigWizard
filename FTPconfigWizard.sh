#!/bin/bash

# Prompt user for username and password
read -p "Enter username for FTP access: " username
read -sp "Enter password for FTP access: " password
echo

# Prompt user for folder directory
read -p "Enter folder directory for FTP access: " folder_dir

# Install vsftpd FTP server
sudo apt-get update
sudo apt-get install vsftpd -y

# Configure vsftpd to allow FTP access to the requested folder directory using the provided username & password
sudo cp /etc/vsftpd.conf /etc/vsftpd.conf.bak
sudo sed -i 's/#write_enable=YES/write_enable=YES/' /etc/vsftpd.conf
sudo sed -i 's/#chroot_local_user=YES/chroot_local_user=YES/' /etc/vsftpd.conf
sudo sed -i 's/#user_sub_token=/user_sub_token=/' /etc/vsftpd.conf
sudo sed -i 's/#local_root=/local_root=/' /etc/vsftpd.conf
sudo sed -i 's/#userlist_enable=YES/userlist_enable=YES/' /etc/vsftpd.conf
sudo sed -i 's/#userlist_file=/userlist_file=/' /etc/vsftpd.conf
sudo sed -i 's/#userlist_deny=NO/userlist_deny=YES/' /etc/vsftpd.conf
sudo echo "$username" | sudo tee -a /etc/vsftpd.userlist
sudo mkdir -p $folder_dir
sudo chown nobody:nogroup $folder_dir
sudo chmod a-w $folder_dir
sudo echo "local_root=$folder_dir" | sudo tee -a /etc/vsftpd.conf
sudo echo "$username" | sudo tee -a /etc/vsftpd.conf
sudo echo "$password" | sudo tee -a /etc/vsftpd.conf
sudo echo "file_open_mode=0777" | sudo tee -a /etc/vsftpd.conf
sudo systemctl restart vsftpd.service

# Grant write permissions to the supplied username and password on the supplied directory
sudo chown -R $username:$username $folder_dir
sudo chmod -R 770 $folder_dir

echo "FTP server installed and configured successfully!"
