#!/bin/bash
# install Vesta CP

#SYSTEM CHECKS
if [[ "$USER" != 'root' ]]; then
	echo "Sorry, you need to run this as root"
	exit
fi


if grep -q "CentOS release 5" "/etc/redhat-release"; then
	echo "CentOS 5 is too old and not supported"
	exit
fi

if [[ -e /etc/debian_version ]]; then
	OS=debian
	RCLOCAL='/etc/rc.local'
elif [[ -e /etc/centos-release || -e /etc/redhat-release ]]; then
	OS=centos
	RCLOCAL='/etc/rc.d/rc.local'
	# Needed for CentOS 7
	chmod +x /etc/rc.d/rc.local
else
	echo "Looks like you aren't running this installer on a Debian, Ubuntu or CentOS system"
	exit
fi

#GREP HOSTNAME
IP=$(hostname -f)

#BEGIN INSTALL VESTA
#QUESTIONS
echo 'Welcome to this quick Vesta CP installation'
echo ""
echo 'Change DNS servers to public Google DNS (8.8.8.8, 8.8.4.4)?'
read -p "Change DNS? [y/n]: " -e -i n DNS
echo ""
echo "Please write your working email"
read -p "Email: " -e -i EMAIL
echo ""
echo "Please write password for admin account."
read -p "admin Password: " -e -i ADMINPASSWORD
echo ""
echo "Please write password for default mysql database user"
read -p "admin Password: " -e -i MYSQLPASSWORD


	
#BEGIN
echo "Okay, that was all I needed. We are ready to setup your Vesta Control Panel now"
if [[ "$DNS" = 'y' ]]; then
	truncate -s0 /etc/resolv.conf
	echo "nameserver 8.8.8.8" >> /etc/resolv.conf
	echo "nameserver 8.8.4.4" >> /etc/resolv.conf
fi

if [[ "$OS" = 'debian' ]]; then
	apt-get update
	apt-get install wget curl nano unzip php5-imap -y
	curl -O http://vestacp.com/pub/vst-install.sh
	bash vst-install.sh -f -e $EMAIL -s $HOSTNAME -p $ADMINPASSWORD -m MYSQLPASSWORD

else
	# Else, the distro is CentOS
	yum update
	yum install wget curl nano unzip php5-imap -y
	curl -O http://vestacp.com/pub/vst-install.sh
	bash vst-install.sh -f -e $EMAIL -s $HOSTNAME -p $ADMINPASSWORD -m MYSQLPASSWORD
fi