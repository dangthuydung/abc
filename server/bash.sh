#!/bin/bash
  sudo apt -y update
  sudo apt install -y nginx
  sudo systemctl start nginx
  sudo systemctl enable nginx
  aws s3 cp s3:///bucket-demo1126/app-key-1.pem 
