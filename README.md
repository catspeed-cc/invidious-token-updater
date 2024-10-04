# invidious-token-updater

## SCRIPT IS IN PROCESS OF BEING UPDATED ... CLONE/PULL AT OWN RISK.
A proper development branch will be set up eventually. Readme below will be updated once new changes are finalized.

## General

This script is to automatically update the visitordata and po-token for Invidious instance. 

This script was written for a manually installed instance of Invidious under the user account "invidious". Invidious executable must already be compiled, and service already started. The script will modify the configuration file and restart the service.

The user 'invidious' must have sudo access without password in order to restart the service, otherwise the script will ask for password. This is OK if you plan to run the script manually, but for crontab to automate it hourly, it will not work with a password.

docker and docker-compose is required as the script runs code from google inside the docker container to get the tokens

Now and then, YT will show a blank page to you and ask to perform a search in order for the algo to show you videos. This is a load of BS, YT is just testing to see if you are a bot or human. I've added a curl command to automagically perform a search query randomized from searches.txt.

You may add your own searches, one per line, so that there are more searches - too many for YT to ban. The likeliness of them starting to ban these specific searches is likely non-existant, as this would make the platform un-usable - eventually all searches possible would be banned. Using a more common search term is preferable, as banning it would also ban legitimate searches for the same term.

The tokens only need updating once per 24-48 hours, however I think it is better to do it every 3 hours to change the tokens regularily to try and stay as anonymous as possible.

***It is no longer required that the script resides inside the invidious directory.***

***The script no longer replaces the invidious configuration file, it will edit the specific configuration lines directly.***

***This script is NOT production worthy without extensive changes to the way the tokens are updated, etc.***

## Instructions

Below assumes the following:

USER - invidious

INVIDIOUS INSTALL LOCATION - ~invidious/invidious/

INVIDIOUS TOKEN UPDATER INSTALL LOCATION - ~invidious/invidious-token-updater/

SCRIPT LOCATION - ~invidious/invidious-token-updater/update-tokens.sh

1) Create user invidious (as root)
   ```useradd -m invidious```
2) Add user to /etc/sudoers (as root) ```invidious ALL=(ALL:ALL)NOPASSWD:ALL```
3) Add user to docker group (as root) ```usermod -aG docker invidious```
4) Switch to invidious user ```su - invidious```
5) Install invidious to the home directory of ```~invidious``` (follow invidious manual install instructions)
6) Edit ```config/config.example.yml``` to contain your settings
7) Inside invidious directory, clone this script ```git clone https://github.com/mooleshacat/invidious-token-updater.git```
8) Chmod the update-tokens.sh script ```chmod +x ~invidious/invidious/invidious-token-updater/update-tokens.sh```
9) Edit the update-tokens.sh script to contain the installation directory (if different from ~invidious/invidious)
10) Test the script ```~invidious/invidious/invidious-token-updater/update-tokens.sh``` and check ```config/config.yml``` gets created with tokens on the bottom
11) Add a crontab to invidious user account (this one is every 3 hours) ```00 */3 * * * ~invidious/invidious/invidious-token-updater/update-tokens.sh```

The reason this script is dirty is I can't figure out how to edit the existing config.yml and so I chose to delete existing one then copy a new one and append the tokens to the bottom. This works for me in my private, firewalled instance, but is not meant to be used in production without extensive changes.

If anyone wishes they can fork the code and modify it to a more proper state, and submit the script to invidious repository.

***If you want a production ready script, make the changes yourself, or hire someone who knows what they are doing.***

***I just hacked something together to make it work. This is by no means production-worthy.***
