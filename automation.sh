#!/bin/bash
sudo apt-get update
sudo apt-get install apache2 -y
sudo systemctl enable apache2
sudo systemctl status apache2
sudo apt-get install awscli -y
aws s3 ls

my_name="punit:"
s3_bucket="upgradpunit"
timestamp=$(date '+%d%m%Y-%H%M%S')
file_type="tar"
Date_Created="$timestamp"

tar -cvf /tmp/"$my_name"-httpd-"$timestamp".tar /var/log/apache2/*.log

aws s3 cp /tmp/"$my_name"-httpd-"$timestamp".tar s3://"$s3_bucket"/

inventory_file="/var/www/html/inventory.html"

if [ -f "$inventory_file" ]; then
    echo "File exists"
else
    sudo touch "$inventory_file"  
    sudo chmod 777 "$inventory_file"
    echo -e "Log Type\tDate Created\tType\tSize" >> "$inventory_file"
fi

size=$(du -h /tmp/"$my_name"-httpd-"$timestamp".tar | awk '{print $1}')
log_type="httpd-logs"

echo -e "$log_type\t$timestamp\t$file_type\t$size" >> "$inventory_file"
cat "$inventory_file"
