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
suitable directory in $PATH. 

Optional extra: create an alias for it to make it easier to call; I suggest ipinfo - do so by adding the following to the .bashrc file in the user's home directory: `alias ipinfo='ipconfig.sh'`
