# invidious-token-updater

## General

This script is to automatically update the visitordata and po-token for Invidious instance. 

This script is very dirty and will never be added to the invidious repository without extensive modifications.

This script was written for a manually installed instance of Invidious under the user account "invidious". 

The user must have sudo access without password in order to restart the service, otherwise the script will ask for password. This is OK if you plan to run the script manually, but for crontab to automate it hourly, it will not work with a password.

Please note the script will DELETE your config.yml and copy config.example.yml to config.yml where it will append the tokens to the configuration file. You must configure config.example.yml to your configuration settings so that when this script copies it, it already is set up and ready to go.

docker-compose is required as the script runs code from google inside the docker container to get the tokens

## Instructions

1) Create user invidious
   ```useradd -m invidious```
2) Add user to /etc/sudoers ```invidious ALL=(ALL:ALL)NOPASSWD:ALL```
3) Install invidious to the home directory of ```~invidious``` (follow invidious manual install instructions)
4) Edit ```config/config.example.yml``` to contain your settings
5) Either in home directory, or invidious directory, clone this script ```git clone ...```
6) Edit the update-tokens.sh script to contain the installation directory (if different from ~invidious/invidious)
7) Test the script ```~invidious/invidious/invidious-token-updater/update-tokens.sh``` and check config.yml gets created with tokens on the bottom
8) Add a crontab ```crontab```
