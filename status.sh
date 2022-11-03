#!/bin/bash

help()
{
	echo -e "\nThis script checks the status of (ptp4l of phc2sys) in (xavier2 or xavier4)\n"
	echo -e "Usage: $0 [xavier2 or xavier4] [ptp4l or phc2sys]\n"
}

if [ $# -ne 2 ] || [ $1 == "--help" ] || [ $1 == "-h" ]
then 
	help
	exit 0
fi


echo "Remote machine is $1..."

if [ $2 == "ptp4l" ]
then
	ssh -t $1 'sudo systemctl restart ptp4l@eth0.service'
	ssh -t $1 'watch systemctl status ptp4l@eth0.service'
fi

if [ $2 == "phc2sys" ]
then
	ssh -t $1 'sudo systemctl restart phc2sys-all.service'
	ssh -t $1 'watch systemctl status phc2sys-all.service'
fi
