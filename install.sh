#!/bin/sh

pwd=`pwd`

sep="--------------------------------------------------------------------------"
echo $sep
echo "***               8bit Day Wallpaper Rotator for Linux                 ***" 
echo "*** Rotator Script: http://www.reddit.com/u/javajames64                ***" 
echo "*** Auto Installer: http://www.reddit.com/u/OhMrBigshot                ***" 
echo $sep
echo


echo "* Changing permissions... [1/2]"
chmod +x update.sh
echo

echo "* Creating cron jobs... [2/2]"
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
