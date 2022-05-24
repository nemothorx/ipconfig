# ipconfig.sh
A bash script that gives a concise output for the ip command "show" functions
Reminiscent of the ipconfig command in windows (with no args added) or the
original ifconfig (no args) in unix/linux.

Goal is to take outputs to get ip address, network ID, MAC address, default
gateway, and default DNS server(s) and put it in an easily-reachable command.
May add new info, improve display or information, or make it more efficient in
the future

## Configuring:
You'll want to download the file and place it in /usr/local/bin/ or other
suitable directory in $PATH. Remove .sh suffix or create easier alias to taste.

## Credits
* Origin: https://www.reddit.com/r/linux/comments/uvq8nw/script_to_spruce_up_ips_output/
* This code subsequently forked from: https://github.com/pingej77/ipconfig.sh
