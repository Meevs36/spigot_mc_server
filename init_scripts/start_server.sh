#! /bin/sh
# Author -- meevs
# Creation Date -- 2023-12-29
# File Name -- start_server.sh
# Notes --

#echo -e "\e[38;2;200;200;0mSetting EULA...\e[0m"
#echo "eula=${MC_EULA}" > ./eula.txt

echo -e "\e[38;2;200;200;0m<<INFO>> -- Writing EULA..."
echo "eula=${MC_EULA}" > ./eula.txt

echo -e "\e[38;2;0;200;0m<<INFO>> -- Starting server!\e[0m"
java -Xms"${MIN_RAM}" -Xmx"${MAX_RAM}" -jar "./spigot-${MC_VERSION}.jar" nogui
echo -e "\e[38;2;0;200;0m<<INFO>> -- Server has stopped!\e[0m"
