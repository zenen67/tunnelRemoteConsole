#!/bin/bash
installation_path='/~/tunnelRemoteConsole'

echo "Thanks you for installing tunnelRemoteConsole
If you have some issue write me to zenen67@gmail.com
Now I will ask you some questions"

echo "Installation path [default:$installation_path]"
read input_installation
echo $input_installation
if [ ! -z "$input_installation" ];then
  installation_path=$input_installation
fi
echo "tunnelRemoteConsole will be installed in $installation_path"
mkdir -p $installation_path
  rsync -arv * $installation_path




