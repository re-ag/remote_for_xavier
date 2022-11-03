#!/bin/bash

function help
{
	echo -e "\nThis script checks PC's date and Xaviers date\n"
	echo -e "Usage: $0\n"
}

if [ $# -ne 0 ] || [ $1 == "--help" ] || [ $1 == "-h" ]
then
	help
	exit 0
fi


echo "PC's date"
date

echo -e "\nxavier2's date"
ssh xavier2 'date'

echo -e "\nxavier4's date"
ssh xavier4 'date'
