#!/bin/bash

# formatting basics
uline=$(tput smul)
reset=$(tput sgr0)
fgred=$(tput setaf 1)
fgreen=$(tput setaf 2)
fgyellow=$(tput setaf 3)
fgblue=$(tput setaf 4)
fgpurple=$(tput setaf 5)
fgteal=$(tput setaf 6)
fgwhite=$(tput setaf 7)


### prints loopback info
echo "${fgteal}${uline}loopback:${reset}"
ip --brief address show | head -1
ip --brief link | head -1
printf "\n"


### display network ID info
echo "${fgteal}${uline}Network Info:${reset}"	#header for Net info
ip route show | tail -1
printf "\n"

line_ct=$(ip --brief address show | wc -l)


## and individual interface info:

#if more than one interface (&lo)
if [ $line_ct -gt 2 ] ; then
    #iterate over interfaces
    for ((i=2;i<=$line_ct; i++)) ; do
        let x=$(( i-1 ))	#set if num as i-1
        let color=$(( ($x-1)%7+1 ))	#cycle color between 1 and 7
        tput setaf $color	#change color for each if
        echo -e "${uline}$x \n\tif:\t\tStatus:\t\tAddresses:${reset}"	#header
        printf "${fgblue}IP:\t"		#print if(i) ip
        ip --brief address show | sed -n ${i}p
        printf "${fgyellow}MAC:\t:"	#print if(i) MAC
        ip --brief link | sed -n ${i}p
        printf "\n"
    done
else	#if only one if
    printf "${uline}1:\tif:   \t\tStatus:\t\tAddresses:${reset}\n"	#header
    printf "${fgblue}IP:\t"		#print IP
    ip --brief address show | tail -1
    printf "${fgyellow}MAC:\t"		#print MAC
    ip --brief link | tail -1
fi
echo "${reset}"


### default gateway info
echo -e "${fgteal}${uline}Default Gateway:${reset}"
(
echo "${reset}IPv4: ${fgblue}$(ip -4 route show | awk '/default/ {print $3,$2,$5}' )" 
echo "${reset}IPv6: ${fgblue}$(ip -6 route show | awk '/default/ {print $3,$2,$5}' )" 
) | column -t
printf "\n"


### dns info
echo "${fgteal}${uline}Default DNS:${reset}"	#DNS header
cat /etc/resolv.conf | grep -v '^#' | grep . | sort | sed "s/^\([a-z]*\) /${reset}\1 ${fgpurple}/"	#print DNS info
printf "${reset}\n"
