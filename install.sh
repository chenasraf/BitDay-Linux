#!/bin/sh

pwd=`pwd`

sep="--------------------------------------------------------------------------"
echo $sep
echo "***               8bit Day Wallpaper Rotator for Linux                 ***" 
echo "*** Rotator Script: http://www.reddit.com/u/javajames64                ***" 
echo "*** Auto Installer: http://www.reddit.com/u/OhMrBigshot                ***" 
echo $sep
echo


echo "* Changing permissions... [1/5]"
chmod +x update.sh
echo

echo "* Select a resolution (files will be downloaded): [2/5]"
echo "    1) 1280x720"
echo "    2) 1280x800"
echo "    3) 1366x768"
echo "    4) 1440x900"
echo "    5) 1600x900"
echo "    6) 1680x1050"
echo "    7) 1920x1080"
echo "    8) 1920x1200"
echo "    9) 2560x1440"
echo "    10) 2560x1600"
echo "    11) 2880x1800"
echo

input=
while [[ "$input" = "" ]]; do
	read -p "    Type a number (1-11): " input
done

case $input in
	1) file="1280x720";;
	2) file="1280x800";;
	3) file="1366x768";;
	4) file="1440x900";;
	5) file="1600x900";;
	6) file="1680x1050";;
	7) file="1920x1080";;
	8) file="1920x1200";;
	9) file="2560x1440";;
	10) file="2560x1600";;
	11) file="2880x1800";;
esac

if [[ -z $file ]]; then
	file=2880x1800
fi
download="https://github.com/chenasraf/8BitDay-Linux/raw/master/tars/BitDay-$file.zip"

echo "* Downloading wallpapers, please wait... [3/5]"
echo
wget $download
echo
echo "* Extracting zip... [4/5]"
tar xvf "BitDay-$file.zip" --wildcards '*.png'
echo "Done."

echo "* Creating cron jobs... [5/5]"
echo

read -p "Create a cron job every hour? [y/n] " yn
case $yn in
	[Yy]*)
		line="0 * * * * ${pwd}/update.sh"
		if ! crontab -l | grep -Fxq "$line"; then
			(crontab -l ; echo "$line") | crontab -
		else
			echo "[cron already exists, skipping]"
		fi
		;;
esac
echo

read -p "Create a cron job after each reboot? [y/n] " yn
case $yn in
	[Yy]*)
		line="@reboot ${pwd}/update.sh"
		if ! crontab -l | grep -Fxq "$line"; then
			(crontab -l ; echo "$line") | crontab -
		else
			echo "[cron already exists, skipping]"
		fi
		;;
esac
echo

read -p "Run script after system resume (from suspension)? (requires root) [y/n] " yn
case $yn in
	[Yy]*)
		sudo -k sh -c "echo -e \"case \"\${1}\" in\n\tresume|thaw)\n\t\t${pwd}/update.sh\n\t;;\nesac\" > /etc/pm/sleep.d/RotatingWallpaper.sh"
		if [ $? -ne 0 ]; then
			echo " --> ERROR: Return from suspension script not created";
		else			
			sudo sh -c "chmod +x /etc/pm/sleep.d/RotatingWallpaper.sh"
			sudo sh -c "chown $USER /etc/pm/sleep.d/RotatingWallpaper.sh"
		fi
		;;
esac
echo


echo "Done!"
