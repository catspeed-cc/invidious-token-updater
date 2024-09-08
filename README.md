# invidious-token-updater

## General

This script is to automatically update the visitordata and po-token for Invidious instance. 

This script is very dirty and will never be added to the invidious repository without extensive modifications.

This script was written for a manually installed instance of Invidious under the user account "invidious". 

The user must have sudo access without password in order to restart the service, otherwise the script will ask for password. This is OK if you plan to run the script manually, but for crontab to automate it hourly, it will not work with a password.

Please note the script will DELETE your config.yml and copy config.example.yml to config.yml where it will append the tokens to the configuration file. You must configure config.example.yml to your configuration settings so that when this script copies it, it already is set up and ready to go.

docker-compose is required as the script runs code from google inside the docker container to get the tokens

***This script is NOT production worthy without extensive changes to the way the tokens are updated, etc.***

## Instructions

Below assumes the following:

USER - invidious

INSTALL LOCATION - ~invidious/invidious/

SCRIPT LOCATION - ~invidious/invidious/invidious-token-updater/update-tokens.sh

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

***I just hacked something together to make it work. This is by no means production-worthy.***
