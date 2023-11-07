#!/bin/bash
#This script will install Jenkins on RHEL/Debian server base on OS type.
if [ -f /etc/debian_version ]; then
  OS_TYPE="debian"
elif [ -f /etc/redhat-release ]; then
  OS_TYPE="rhel"
else
  echo "Unsupported operating system"
  exit 1
fi

if [ "$OS_TYPE" = "rhel" ]; then
   sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
   sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
   sudo yum upgrade -y
   # Add required dependencies for the jenkins package
   sudo yum install fontconfig java-17-openjdk -y
   sudo yum install jenkins -y
   sudo systemctl daemon-reload
   sudo systemctl enable jenkins
   sudo systemctl start jenkins
   sudo systemctl status jenkins
   echo "Jenkins Initial admin password : $(cat /var/lib/jenkins/secrets/initialAdminPassword)"
elif [ "$OS_TYPE" = "debian" ]; then
   sudo apt update
   sudo apt install fontconfig openjdk-17-jre
   java -version
   sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
        https://pkg.jenkins.io/debian/jenkins.io-2023.key
   echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
           https://pkg.jenkins.io/debian binary/ | sudo tee \
           /etc/apt/sources.list.d/jenkins.list > /dev/null
   sudo apt-get update -y
   sudo apt-get install jenkins -y
   sudo systemctl start jenkins
   sudo systemctl enable jenkins
   sudo systemctl status jenkins
   echo "Jenkins Initial admin password : $(cat /var/lib/jenkins/secrets/initialAdminPassword)"
fi
