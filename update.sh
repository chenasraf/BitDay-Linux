#!/bin/bash

# Original script by http://www.reddit.com/u/javajames64
# Updates by http://www.reddit.com/u/OhMrBigshot

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

sessionfile=`find "${HOME}/.dbus/session-bus/" -type f`
export `grep "DBUS_SESSION_BUS_ADDRESS" "${sessionfile}" | sed '/^#/d'`

files=(
  11-Mid-Night.png
  12-Late-Night.png
  01-Early-Morning.png
  02-Mid-Morning.png
  03-Late-Morning.png
  04-Early-Afternoon.png
  05-Mid-Afternoon.png
  06-Late-Afternoon.png
  07-Early-Evening.png
  08-Mid-Evening.png
  09-Late-Evening.png
  10-Early-Night.png
)

#Timings for the backgrounds in order. Your life may vary.
timing=(0 2 4 6 8 10 13 16 18 20 21)

hour=`date +%H`
hour=$(echo $hour | sed 's/^0*//')


# Different desktop environment implementations
case $XDG_CURRENT_DESKTOP in
	Mint|Mate) setcmd="gsettings set org.mate.background picture-uri";;
	MATE) setcmd="gsettings set org.mate.background picture-filename ";;
	Cinnamon) setcmd="gsettings set org.cinnamon.background picture-uri file://";;
	*) setcmd="gsettings set org.gnome.desktop.background picture-uri file://";; # GNOME/Unity, default
esac
if [[ -z $XDG_CURRENT_DESKTOP ]]; then # Fallback for i3
	case $DESKTOP_SESSION in
		i3) setcmd="feh --bg-fill"
	esac
fi

for i in ${!timing[@]}; do # Loop through the wallpapers
    if [ ${timing[$i]} -gt $hour ]; then
        $setcmd $DIR/${files[i-1]}
        echo "Wallpaper set to ${files[i-1]}"
        exit
    fi
done

# Fallback at last wallpaper if time is not relevant
$setcmd $DIR/${files[7]}
echo $setcmd
echo "Wallpaper set to ${files[7]}"
