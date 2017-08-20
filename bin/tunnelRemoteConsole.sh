#!/bin/bash
#title           :tunnelRemoteConsole.sh
#description     :This script will make a SSH Tunnel to connect to Remote consoles 
#for HP Proliant ILO - Huawei - Lenovo
#author :Manuel Fernandez
#version         :1.0    
#usage:
source ../src/tunnel.conf
function help(){
   echo "
This script create a SSH tunnel in Linux/MAC, with this parameters:
Usage: $(basename $0) [ARGS]
        where ARGS can be:

Basic:

  --help         This message

Advanced parameters:
--hwid [Mandatory] with these options 'hp' 'lenovo' 'huawei'
--browser [Optional]  Open a browser configure in the file tunnel.conf
--ip_gateway_SSH [Mandatory] Linux/Unix server with access to ports of terminal remote.  
--port_gateway_SSH [Optional]Port of SSH gateway, 
 if not set will be use default port for SSH(22)
--remoteIP IP remote thats the IP of ILO, for Ex in HP servers case..
--localIP[Optional] Set a temporal IP in loopback interface, if not set
the IP used will be 127.0.0.1, this options allow open multiples remotes consoles.

Ex:
   $0 --help
   $0 --browser --ip_gateway_SSH 213.4.28.160 --port_gateway_SSH 5000 --remoteIP 192.168.0.6\
   --hwid hp --localIP 1.1.1.1
"
}
# Extract command lines parameters and test it
function get_parameters(){
   while [ "$1" ]
   do
      case $1 in
         --hwid)
             hwid=$2
             shift
           ;;
         --browser)
             browser='true'
             shift  
           ;;
         --ip_gateway_SSH)
             ip_gateway_SSH=$2
             shift
           ;;
         --port_gateway_SSH)
             port_gateway_SSH=$2
             shift
           ;;
         --remoteIP)
             remoteIP=$2
             shift
           ;;
         --localIP)
             localIP=$2
             shift
           ;;
         --username)
             localIP=$2
             shift
           ;;
         --help)
           help
           exit 0
         ;;
         *)
         ;;
      esac
      shift
   done
}
function addIP(){
  sudo ip addr add $IP_LOCAL/32 dev lo0
}
function delIP(){
  sudo ip addr del $IP_LOCAL/32 dev lo0
}
function openbrowser(){
  if [ $(uname) == 'Darwin']; then
    open -a "$browser_path" -new-window http://$local_ip
  elif [ $(uname) == 'Linux' ];then
     $browser_path -new-window http://$local_ip &
else
  echo "Not supported platform"
  exit 1
fi
}
function createtunnel(){
  case $hwid in
         hp)
           sudo ssh -p $port_gateway_SSH -L $localIP:22:$remoteIP:22 \
             -L $localIP:23:$remoteIP:23 -L $localIP:80:$remoteIP:80\
             -L $localIP:443:$remoteIP:443  -L $localIP:3389:$remoteIP:3389\
             -L $localIP:17988:$remoteIP:17988  -L $localIP:9300:$remoteIP:9300\
             -L $localIP:17990:$remoteIP:17990  -L $localIP:3002:$remoteIP:3002 \ 
             $username@$ip_gateway_SSH
             ;;
         huawei)
           sudo ssh -p $port_gateway_SSH -L $localIP:22:$remoteIP:22 \
             -L $localIP:23:$remoteIP:23 -L $localIP:80:$remoteIP:80 \
             -L $localIP:443:$remoteIP:443  -L $localIP:2198:$remoteIP:2198 \
             -L $localIP:2199:$remoteIP:2199 -L $localIP:8208:$remoteIP:8208 \
             $username@$ip_gateway_SSH
             ;;
         lenovo)
           sudo ssh -p $port_gateway_SSH -L $localIP:22:$remoteIP:22 \
             -L $localIP:23:$remoteIP:23 -L $localIP:80:$remoteIP:80\
             -L $localIP:443:$remoteIP:443  -L $localIP:3900:$remoteIP:3900\
             $username@$ip_gateway_SSH
  esac           
}
# MAIN
get_parameters
if [ "$local_ip" != "127.0.0.1" ]; then
   addIP
fi
if [ browser =='true' ]; then
  openbrowser
fi
createtunnel
if [ "$local_ip" != "127.0.0.1" ]; then
   delIP
fi
exit 0