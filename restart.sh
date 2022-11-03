#!/bin/bash


help()
{
	echo -e "\nThis script restart (ptp4l of phc2sys service) in (xavier2 or xavier4)\n"
        echo -e "Usage: $0 [remote machine name] [ptp4l or phc2sys]\n"
}

if [ $# -ne 2 ] || [ $1 == "--help" ] || [ $1 == "-h" ]
then
        help
        exit 0
fi

echo "Remote machine is $1..."

if [ $2 == "ptp4l" ]
then
	ssh -t $1 "sudo systemctl restart ptp4l@eth0.service"
	echo "Restart ptp4l@eth0.service successful...."
fi

if [ $2 == "phc2sys" ]
then
	ssh -t $1 "sudo systemctl restart phc2sys-all.service"
	echo "Restart phc2sys-all.service successful...."
fi
