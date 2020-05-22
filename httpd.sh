#! /bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo chkconfig httpd on
sudo systemctl start httpd
echo "<h1>Equifax Assignment Succesfully Deployed Using Terraform</h1>" | sudo tee /var/www/html/index.html