#!/bin/bash
sudo apt update -y
sudo apt  install docker.io -y
sudo usermod -aG docker $USER
sudo chmod 660 /var/run/docker.sock
sudo chown -R ubuntu:docker /var/run/docker.sock 

