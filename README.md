BitDay-Linux
=============

BitDay-Linux is an automated installer for the [BitDay package](http://www.reddit.com/r/bitday/comments/1ts4j0/bitday_version_10/) by [/u/BloodyMarvellous](http://www.reddit.com/user/BloodyMarvellous).

## Requirements

Requirements are usually built into most Linux distributions:

* **wget** to download the zip
* **tar** to extract the downloaded zip


## How to use?

Just make a new directory where you want the wallpapers to be placed and installs, and run the following command:

    wget https://github.com/chenasraf/BitDay-Linux/raw/master/install.sh
    
Then just make sure you have execute permissions on the install.sh file:

    chmod +x install.sh
    
And run it:

    ./install.sh
    
That's it! You'll be prompted for everything you need, and the script will download any remaining files that are missing. Enjoy!

## How can I help?

* Is your Linux distribution/desktop environment not supported?

Feel free to do your research to find out how to determine if another user is using the same desktop environment, and how to update wallpapers via command-line (bash) on that environment, then feel free to **fork** and **create a pull request** with the desired changes to **update.sh** to include those distros/desktop environments.

* Is there a bug?

Feel free to do the same to fix it.
