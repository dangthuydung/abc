#!/bin/bash
sudo apt -y update
sudo apt install -y nginx
sudo systemctl start nginx
sudo systemctl enable nginx