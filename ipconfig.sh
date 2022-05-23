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


### display network ID info
echo "${fgteal}${uline}Network Info:${reset}"	#header for Net info
ip route show | grep -v via | cut -d" " -f 1-3 | column -t
printf "\n"


### the interfaces
(
    echo "${fgteal}${uline}if status IPv4 IPv6 MAC${reset}"
    (ip -o link ; ip -o  a ; echo "this exists only to flush data" ) | sort -V | awk '
        /inet6/ {ip6=$4} 
        /inet / {ip4=$4}
        { if ($2~":") 
            {   
                iface=$2 ; mac=$(NF-2) ; status=$(NF-10)
                print iface,status,ip4,ip6,mac
                iface=""
                status=""
                ip4=""
                ip6=""
                mac=""
            }
        }

            ' 
) | column -n -t 
echo ""

### default gateway info
echo -e "${fgteal}${uline}Default Gateway:${reset}"
(
echo "${reset}IPv4: ${fgblue}$(ip -4 route | awk '/default/ {print $3,$2,$5}' )" 
echo "${reset}IPv6: ${fgblue}$(ip -6 route | awk '/default/ {print $3,$2,$5}' )" 
) | column -t
printf "\n"


### dns info
echo "${fgteal}${uline}Default DNS:${reset}"	#DNS header
cat /etc/resolv.conf | grep -v '^#' | grep . | sort | sed "s/^\([a-z]*\) /${reset}\1 ${fgpurple}/"	#print DNS info
printf "${reset}\n"
