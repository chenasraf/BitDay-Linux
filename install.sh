#!/bin/bash

pwd=`pwd` # Save current directory

sep="--------------------------------------------------------------------------"
echo $sep
echo "***               8bit Day Wallpaper Rotator for Linux                 ***"
echo "*** Rotator Script: http://www.reddit.com/u/javajames64                ***"
echo "*** Auto Installer: http://www.reddit.com/u/OhMrBigshot                ***"
echo $sep
echo

echo "* Select a resolution (files will be downloaded): [1/5]"
echo "    1) 1280x720"
echo "    2) 1280x800"
echo "    3) 1440x900"
echo "    4) 1600x900"
echo "    5) 1680x1050"
echo "    6) 1920x1080"
echo "    7) 1920x1200"
echo "    8) 2560x1440"
echo "    9) 2560x1600"
echo "    10) 2880x1800"
echo "    11) 3840x2160"
echo "    12) 4096x2304"
echo

# Only accept proper input
while read -p "    Type a number (1-11): " input; do
	if [[ -n $input ]]; then
		case $input in
			1) file="1280x720"; break;;
			2) file="1280x800"; break;;
			3) file="1440x900"; break;;
			4) file="1600x900"; break;;
			5) file="1680x1050"; break;;
			6) file="1920x1080"; break;;
			7) file="1920x1200"; break;;
			8) file="2560x1440"; break;;
			9) file="2560x1600"; break;;
			10) file="2880x1800"; break;;
			11) file="3840x2160"; break;;
			12) file="4096x2304"; break;;
		esac
	fi
done

if [[ -z $file ]]; then
	file="2880x1800" # Never supposed to get here but... just in case
fi

# Actual download link for tar
download="https://github.com/chenasraf/BitDay-Linux/raw/master/tars/BitDay-$file.tar.gz"

echo $sep
echo "* Downloading scripts & wallpapers, please wait... [2/5]"
echo

# Check if file already exists
if [[ -e "./BitDay-$file.tar.gz" ]]; then
	echo "Wallpaper pack already exists, skipping download."
else
	wget $download
fi

# Download update & uninstall scripts
wget "https://github.com/chenasraf/BitDay-Linux/raw/master/update.sh"
wget "https://github.com/chenasraf/BitDay-Linux/raw/master/uninstall.sh"


echo $sep
echo "* Changing permissions... [3/5]"
chmod +x update.sh uninstall.sh
echo

echo
echo "* Extracting zip... [4/5]"
# Extract the tar
# Wildcards are leftovers from before the structure was flat... keeping in case that changes again or more files are added
tar xvf "BitDay-$file.tar.gz" --wildcards '*.png' --strip-components=1
rm -f "BitDay-$file.tar.gz"
echo "Done."

echo $sep
echo "* Creating cron jobs... [5/5]"
echo

read -p "Create a cron job every hour? [y/n] " yn
case $yn in
	[Yy]*)
		line="0 * * * * ${pwd}/update.sh"
		if ! crontab -l | grep -Fxq "$line"; then
			(crontab -l ; echo "$line") | crontab -
		else
			echo "- Cron already exists, skipping."
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
			echo "- Cron already exists, skipping."
		fi
		;;
esac
echo

read -p "Run script after system resume (from suspension)? (requires root) [y/n] " yn
case $yn in
	[Yy]*)
		# This creates a file in /etc/pm/sleep.d which runs on system suspend & resume, but this script uses case to run only on resume
		# sudo -k makes sure password is prompted regardless of its cache state
		# sh -c is required for sudo to perform inside ore-written script
		sudo -k bash -c "echo -e \"case \"\$\{1\}\" in\n\tresume|thaw)\n\t\t${pwd}/update.sh\n\t;;\nesac\" > /etc/pm/sleep.d/RotatingWallpaper.sh"
		if [ $? -ne 0 ]; then # Error code is not 0 (not success)
			echo "ERROR: Return from suspension script not created.";
		else
			# Chmod & chown the new file
			sudo bash -c "chmod +x /etc/pm/sleep.d/RotatingWallpaper.sh"
			sudo bash -c "chown $USER /etc/pm/sleep.d/RotatingWallpaper.sh"
		fi
		;;
esac
echo


echo "Done!"
