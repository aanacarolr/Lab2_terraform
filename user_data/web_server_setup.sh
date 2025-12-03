#!/bin/bash
set -xe

# Install nginx on Amazon Linux 2023
dnf update -y
dnf install -y nginx

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
    <h1>Terraform Assignment 2025</h1>
    <p>Deployed with Terraform in two availability zones.</p>
    <p>Student: Ana Carolina Raulino (LNUMBER_HERE)</p>
    <p>Instance ID: ${INSTANCE_ID}</p>
    <p>Availability Zone: ${AZ}</p>
  </body>
</html>
EOF
