#!/usr/bin/bash

. ./config.cfg.sh

echo ""
echo "Updating tokens, please wait..."
echo ""

# CLEAR OLD PROXY VARS
export HTTP_PROXY=
export HTTPS_PROXY=

# TEST WHAT CURRENT IP IS
oldip=$(curl -s ipinfo.io/ip)
echo "OLD EXTERNAL IP: ${oldip}"

# LEAVE THIS UNLESS YOU NEED SEPERATE PROXY FOR EACH (most users do not)
export HTTP_PROXY=${YOUR_HTTP_PROXY}
export HTTPS_PROXY=${YOUR_HTTP_PROXY}

# TEST WHAT NEW CURRENT IP IS
newip=$(curl -s ipinfo.io/ip)
echo "NEW EXTERNAL IP: ${newip}"

echo ""
echo "Generating visitordata & potoken, please wait ..."
echo ""

# THIS IS THE ACTUAL COMMAND, WILL TAKE TIME TO PROCESS
theOUTPUT=$(sudo docker run --rm quay.io/invidious/youtube-trusted-session-generator)

# This is a test output
#theOUTPUT="[INFO] internally launching GUI (X11 environment) [INFO] starting Xvfb [INFO] launching chromium instance [INFO] launching browser. visitor_data: TESTINGOUTPUTONLY-CgtqX3B3M3k2QklmRIEGgAgUg%3D%3D po_token: TESTINGOUTPUTONLY-jCQOtGaJ4KediLqyCsdGqZmU7_0NuXQe-_7s9zNndWofD0quLZnoqft8zDg6ZyApcHLrnPwbdB3dIW1vAfty9Wo-CWMMDCSMGs9u2j4yG5qFSbJQNg4K9PB26tbFBjKqPPKA== successfully removed temp profile /tmp/uc_v4yrv40b"

# EXTRACT THE TOKENS
VISITORDATA=$(echo ${theOUTPUT} | awk -F '[ ]' '{print $18}')
POTOKEN=$(echo ${theOUTPUT} | awk -F '[ ]' '{print $20}')

# DISPLAY TO $USER
echo "po_token: \"${POTOKEN}\""
echo "visitor_data: \"${VISITORDATA}\""


# MAKE THE CONFIGURATION MODIFICATIONS

echo ""
echo "Changing to invidious directory (${INV_INSTALL_DIR})"
echo ""

# CHANGE TO CONFIG DIR
cd ${INV_INSTALL_DIR}

echo "Deleting old config.yml"

# REMOVE EXISTING CONFIG
rm config/config.yml

echo "Copying config.example.yml to config.yml"

# COPY EXAMPLE CONFIG (preconfigured to your liking)
cp config/config.example.yml config/config.yml

# ECHO THE TOKENS TO BOTTOM OF THE CONFIG FILE
echo "po_token: \"${POTOKEN}\"" | tee -a config/config.yml
echo "visitor_data: \"${VISITORDATA}\"" | tee -a config/config.yml

# ECHO THE TOKENS TO LOGFILE
TSTAMP=$(date +"[%D][%T]")
echo "" | tee -a ${INV_LOG_FILE} >/dev/null
echo "${TSTAMP} UPDATED TOKENS!" | tee -a ${INV_LOG_FILE} >/dev/null
echo "${TSTAMP} po_token: \"${POTOKEN}\"" | tee -a ${INV_LOG_FILE} >/dev/null
echo "${TSTAMP} visitor_data: \"${VISITORDATA}\"" | tee -a ${INV_LOG_FILE} >/dev/null

echo ""
echo "Random search to wake up YT"
echo ""
YT_QUERY=$(shuf -n 1 ./searches.txt)
YT_QUERY=${YT_QUERY//[$'\t\r\n']}
YT_QUERY=${YT_QUERY// /+}
echo "Querying for '${YT_QUERY}'"
curl https://www.youtube.com/results?search_query=${YT_QUERY} > /dev/null

echo ""
echo "Restarting inv_sig_helper docker..."
sudo docker restart ${INV_SIG_HELPER_CONTAINER_NAME}

sleep 2

echo ""
echo "Restarting Invidious service..."
sudo service ${INV_SERVICE_NAME} restart

echo ""
echo "Done. Have a good day :)"
echo ""
