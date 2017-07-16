#!/bin/sh

# case "$(pidof komodod | wc -w)" in
# 0)  # komodod is not running
#    ;;
# 1)  # komodod is running
#    ;;
# *)  # we have more than one komodod
#     # kill $(pidof komodod | awk '{print $1}')
#    ;;
# esac

while [ $(pidof komodod | wc -w) -eq 1 ]; do
	echo Komodo Daemon is running ...
	sleep 5
	~/komodo/src/komodo-cli stop 2>/dev/null
done
gnome-terminal -e "$HOME/komodo/src/komodod"
sleep 10
time=0

# Ugly code to wait komodod loading blocks ...
status=$(~/komodo/src/komodo-cli getinfo 2>&1 | awk '/error code:/ {print $3;}')
while [ $status -eq "-28" ]; do
	echo ["\033[1;34m $time \033[0m"] Waiting loading blocks ...
	sleep 1
	time=$((time+1))
	status=$(~/komodo/src/komodo-cli getinfo 2>&1 | awk '/error code:/ {print $3;}')
	if [ -z $status ] 
	then 
		break
	fi
done

gnome-terminal -e "java -jar $HOME/komodo/src/KomodoSwingWalletUI.jar"
