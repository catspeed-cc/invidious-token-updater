# invidious-token-updater

## Script is abandoned again.
I cannot figure out a good way to incorporate all of the repositories, or explain how to install them separately. The project is a mess, however if anyone figures it out and can use it then that is ok :) I may make minor changes for my own use, but there are no plans to make it ready for others to use.

## General

This script is to automatically update the visitordata and po-token for Invidious instance. 

This script was written for a manually installed instance of Invidious under the user account "invidious". Invidious executable must already be compiled, and service already started. The script will modify the configuration file and restart the service.

The user 'invidious' must have sudo access without password in order to restart the service, otherwise the script will ask for password. This is OK if you plan to run the script manually, but for crontab to automate it hourly, it will not work with a password.

docker and docker-compose is required as the script runs code from google inside the docker container to get the tokens

Now and then, YT will show a blank page to you and ask to perform a search in order for the algo to show you videos. This is a load of BS, YT is just testing to see if you are a bot or human. I've added a curl command to automagically perform a search query randomized from searches.txt. This will be done on every execution of the script (basically whenever you set up the cron job for, ex. every 3 hours)

You may add your own searches, one per line, so that there are more searches - too many for YT to ban. The chances of them starting to ban these specific searches is likely non-existant, as this would make the platform un-usable - eventually all searches possible would be banned. Using a more common search term is preferable, as banning it would also ban legitimate searches for the same term.

If YT shows you cat videos, don't ask questions :3c

The tokens only need updating once per 24-48 hours, however I think it is better to do it every 3 hours to change the tokens regularily to try and stay as anonymous as possible.

***It is no longer required that the script resides inside the invidious directory.***

***The script no longer replaces the invidious configuration file, it will edit the specific configuration lines directly inside ```~invidious/invidious/config/config.yml```.***

***The script is NOT production ready without extensive changes to the way the tokens are updated, etc.***

## Instructions

Below assumes the following:

USER - invidious

INVIDIOUS INSTALL LOCATION - ~invidious/invidious/

INV_SIG_HELPER INSTALL LOCATION - ~invidious/inv_sig_helper/

INVIDIOUS TOKEN UPDATER INSTALL LOCATION - ~invidious/invidious-token-updater/

SCRIPT LOCATION - ~invidious/invidious-token-updater/update-tokens.sh

### Preperations

1) Create user invidious (as root)
   ```useradd -m invidious```
2) Add user to /etc/sudoers (as root) ```nano /etc/sudoers``` add in ```invidious ALL=(ALL:ALL)NOPASSWD:ALL```
3) Add user to docker group (as root) ```usermod -aG docker invidious```

### Install inv_sig_helper (using docker)
1) Switch to invidious user ```su - invidious``` if not already
2) Make sure you are in home directory ```cd ~```
3) Clone inv_sig_helper repository ```git clone https://github.com/iv-org/inv_sig_helper.git```
4) Change directory ```cd inv_sig_helper```
5) Build the docker image ```docker build -t inv_sig_helper .``` - this may take a while.
6) Run the docker container ```sudo docker run --restart unless-stopped --network host --name inv_sig_helper -p 127.0.0.1:12999:12999 inv_sig_helper```

### Install invidious (manual compile and installation)
1) Switch to invidious user ```su - invidious``` if not already
2) Make sure you are in home directory ```cd ~```
3) Clone invidious repository ```git clone https://github.com/iv-org/invidious.git```
4) Change directory ```cd invidious``` (follow invidious manual compile/install instructions)
5) Copy ```~invidious/invidious/config/config.example.yml``` to ```config/config.yml```
6) Edit ```~invidious/invidious/config/config.yml``` to your liking 
	- change hmac_key to anything random
	- update mongodb settings (should be localhost, verify user/pass are correct)
	- update signature_server line to your inv_sig_helper LAN IP(should be localhost, verify port is correct)


### Install invidious-token-updater
1) Switch to invidious user ```su - invidious``` if not already
2) Make sure you are in home directory ```cd ~```
3) Clone this repository ```git clone https://github.com/mooleshacat/invidious-token-updater.git```
4) Change directory ```cd invidious-token-updater```
4) Copy ```config.cfg.example``` to ```config.cfg```
5) Edit ```config.cfg``` to your liking (most defaults probably OK)
5) Test the script ```~invidious/invidious/invidious-token-updater/update-tokens.sh``` and check ```config/config.yml``` gets created with tokens on the bottom
6) Add a crontab to invidious user account (this one is every 3 hours) ```00 */3 * * * ~invidious/invidious-token-updater/update-tokens.sh```

## Dependencies
This script makes use of several other repositories and/or docker images maintained by others. I do not have anything to do with their repos and they have nothing to do with this repo. These repositories / docker images should contain their original licenses as they are either used as a remote docker image, or a cloned repository as a whole. Please be aware of these separate licenses.
- Github (youtube-trusted-session-generator): https://github.com/iv-org/youtube-trusted-session-generator
- Github (inv_sig_helper): https://github.com/iv-org/inv_sig_helper
- Github (invidious): https://github.com/iv-org/invidious

As you can see from the installation instructions, you are cloning the code repositories directly yourself, and then configuring it yourself. While my code utilizes their code, their code is in no way included within my repository.

## License
This repository uses Unlicense which can be found in LICENSE.md

If anyone wishes they can clone/fork this repository (invidious-token-updater) and modify it.
