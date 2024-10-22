#!/bin/bash
# attempt to show the main network info in a clear readable manner

# formatting basics
bold=$(tput bold)
uline=$(tput smul)
reset=$(tput sgr0)
fgred=$(tput setaf 1)
fggreen=$(tput setaf 2)
fgyellow=$(tput setaf 3)
fgblue=$(tput setaf 4)
fgpurple=$(tput setaf 5)
fgteal=$(tput setaf 6)
fgwhite=$(tput setaf 7)


### display network ID info
echo "${fgteal}${uline}Network Info:${reset}"	#header for Net info
ip route show | grep -v via | cut -d" " -f 1-3 | column -t
echo ""


### the interfaces
echo "${fgteal}${uline}Interface Info:${reset}"
(
    echo "${bold}iface Status IPv4 IPv6 MAC${reset}"
    (ip -o link ; ip -o  a ; echo "this exists only to flush data" ) | sort -V | awk '
        # populate our ip6 and ip4 vars from a matching line
        /inet6/ {ip6=$4} 
        /inet / {ip4=$4}
        { if ($2~":") 
            # due to the sort-V, this should be the last line of each interface
            # more vars but also extra: print output and reset vars
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
) | sed -e "s/: / /g ; s/UNKNOWN/${fgyellow}UNKNOWN${reset}/g ; s/DOWN/${fgred}DOWN${reset}/g ; s/UP/${fggreen}UP${reset}/g" | column -n -t
echo ""


### default gateway info
echo -e "${fgteal}${uline}Default Gateway:${reset}"
(
echo "${reset}IPv4: ${fgpurple}$(ip -4 route | awk '/default/ {print $3,$2,$5}' )" 
echo "${reset}IPv6: ${fgpurple}$(ip -6 route | awk '/default/ {print $3,$2,$5}' )" 
) | column -t
echo ""


### dns info
echo "${fgteal}${uline}Default DNS:${reset}"	#DNS header
cat /etc/resolv.conf | grep -v '^#' | grep . | sed "s/^\([a-z]*\) /${reset}\1 ${fgpurple}/"	#print DNS info
echo "${reset}"
