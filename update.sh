#!/bin/bash

# Original script by http://www.reddit.com/u/javajames64
# Updates by http://www.reddit.com/u/OhMrBigshot

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sessionfile=`find "${HOME}/.dbus/session-bus/" -type f`
export `grep "DBUS_SESSION_BUS_ADDRESS" "${sessionfile}" | sed '/^#/d'`

files=(
	01-Morning.png
	02-Late-Morning.png
	03-Afternoon.png
	04-Late-Afternoon.png
	05-Evening.png
	06-Late-Evening.png
	07-Night.png
	08-Late-Night.png
)

#Timings for the backgrounds in order. Your life may vary.
timing=(
	7
	10
	12
	17
	18
	19
	21
	23
)

hour=`date +%H`

case $XDG_CURRENT_DESKTOP in
	Mint|Mate) setcmd="gsettings set org.mate.background picture-uri";;
	Cinnamon) setcmd="gsettings set org.cinnamon.background picture-uri";;	
	*) setcmd="feh --bg-fill";;
esac
if [[ -z $XDG_CURRENT_DESKTOP ]]; then
	case $DESKTOP_SESSION in
		i3) setcmd="feh --bg-fill"
	esac
fi

for i in {7..0..-1}
do 
    if [[ $hour -ge ${timing[i]} ]]; then
        $setcmd file://$DIR/${files[i]}
        echo "Wallpaper set to ${files[i]}"
        exit
    fi
done

$setcmd file://$DIR/${files[7]}
echo "Wallpaper set to ${files[7]}"
