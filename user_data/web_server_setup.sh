#!/bin/bash
set -xe

# Update packages and install nginx from Amazon Linux Extras
yum clean all
yum update -y
amazon-linux-extras enable nginx1
yum install -y nginx

# Enable and start nginx service
systemctl enable nginx
systemctl start nginx

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id || echo "unknown-instance")
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone || echo "unknown-az")

cat <<EOF >/usr/share/nginx/html/index.html
<html>
  <head>
    <title>Terraform HA Web App</title>
  </head>
  <body>
    <h1>Terraform Assignment Lab2</h1>
    <p>Deployed with Terraform in two availability zones.</p>
    <p>Student: Ana Carolina Raulino </p>
    <p>Instance ID: ${INSTANCE_ID}</p>
    <p>Availability Zone: ${AZ}</p>
  </body>
</html>
EOF

# Restart nginx to ensure new index is served
systemctl restart nginx
