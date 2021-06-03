# machine id
sudo rm /etc/machine-id 
sudo systemd-machine-id-setup 

# ssh host keys
sudo rm -v /etc/ssh/ssh_host_*
sudo dpkg-reconfigure openssh-server
sudo systemctl restart ssh 

# keep up to date
sudo apt update 
sudo apt upgrade -y 


