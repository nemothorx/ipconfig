#!/bin/bash

#prints loopback info
echo "loopback:"
ip --brief address show | head -1
ip --brief link | head -1
printf "\n"

#display network ID info
tput setaf 6
setterm -underline on; echo Network Info:	#header for Net info
setterm -underline off; tput setaf 7		#reformat
ip route show | tail -1
printf "\n"

line_ct=$(ip --brief address show | wc -l)

if [ $line_ct -gt 2 ]	#if more than one interface (&lo)
then
	for ((i=2;i<=$line_ct; i++))	#iterate over interfaces
	do
		let x=$i-1		#set if num as i-1
		let color=($x-1)%7+1	#cycle color between 1 and 7
		tput setaf $color	#change color for each if
		setterm -underline on	#underline header
		echo -e $x "\n\tif:\t\tStatus:\t\tAddresses:"	#header
		setterm -underline off
		tput setaf 4		#ip=blue
		printf "IP:\t"		#print if(i) ip
		ip --brief address show | sed -n ${i}p
		tput setaf 3		#mac=orange
		printf "MAC:\t:"	#print if(i) MAC
		ip --brief link | sed -n ${i}p
		printf "\n"
    	done
else	#if only one if
	setterm -underline on
	printf "1:\tif:   \t\tStatus:\t\tAddresses:\n"	#header
	setterm -underline off
	tput setaf 4		#ip=blue
	printf "IP:\t"		#print IP
	ip --brief address show | tail -1
	tput setaf 3		#mac=orange
	printf "MAC:\t"		#print MAC
	ip --brief link | tail -1
fi
#default gateway info
setterm -underline on
echo -e "\n$(tput setaf 6)Default Gateway:"
setterm -underline off
tput setaf 4	#ip=blue
echo -n $(ip -4 route show | head -1) | sed 's/dev.*//' | sed 's/default via //'
echo -e -n "\t\t" $(ip -6 route show | tail -1)"\n" | sed 's/dev.*//'
printf "\n"

#dns info
setterm -underline on
echo "$(tput setaf 6)Default DNS:"	#DNS header
setterm -underline off
tput setaf 5   	#make DNS purple
cat /etc/resolv.conf | tail -3 | sed 's/search //' | sed 's/nameserver //g'	#print DNS info
tput sgr0	#reset font-color
printf "\n"
