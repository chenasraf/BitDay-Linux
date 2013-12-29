#!/bin/sh

pwd=`pwd`

sep="--------------------------------------------------------------------------"
echo $sep
echo "***               8bit Day Wallpaper Rotator for Linux                 ***" 
echo $sep
echo


echo "This will revert all the changes."
echo

read -p "Are you sure that's what you want? [y/n] " yn
case $yn in
	[Yy]*)
		echo
		echo "Removing tasks..."

		line="${pwd}/update.sh" # This should be enough to identify the lines in cron.
		crontab -l | grep -v "$line1" | crontab - # Re-output any lines that are NOT the previous line (effectively removing it) from crontab

		if [ -f /etc/pm/sleep.d/RotatingWallpaper.sh ]; then
			echo "We need root permissions to delete '/etc/pm/sleep.d/RotatingWallpaper.sh': "
			sudo -k sh -c "rm /etc/pm/sleep.d/RotatingWallpaper.sh"
			if [[ $? -ne 0 ]]; then # If there was a problem deleting (user failed/refused to give root?)
				echo "There was a problem deleting the unsuspend file, please delete it manually:"
				echo "    sudo rm /etc/pm/sleep.d/RotatingWallpaper.sh"
			fi
		fi
		;;
esac
echo

read -p "Delete this directory and its files? [y/n] " yn
case $yn in
	[Yy]*) rm -R $pwd;;
esac
echo


echo "Done! We're sorry to see you go!"
