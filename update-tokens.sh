#!/usr/bin/bash

# SET YOUR INVIDIOUS INSTALL DIR HERE
export INSTALL_DIR=~invidious/invidious/
export LOG_FILE=~invidious/invidious/invidious-token-updater.log

echo ""
echo "Generating visitordata & potoken please wait ..."
echo ""

# THIS IS THE ACTUAL COMMAND, WILL TAKE TIME TO PROCESS
theOUTPUT=$(sudo docker run quay.io/invidious/youtube-trusted-session-generator)

# This is a test output
#theOUTPUT="[INFO] internally launching GUI (X11 environment) [INFO] starting Xvfb [INFO] launching chromium instance [INFO] launching browser. visitor_data: TESTINGOUTPUTONLY-CgtqX3B3M3k2QklmRIEGgAgUg%3D%3D po_token: TESTINGOUTPUTONLY-jCQOtGaJ4KediLqyCsdGqZmU7_0NuXQe-_7s9zNndWofD0quLZnoqft8zDg6ZyApcHLrnPwbdB3dIW1vAfty9Wo-CWMMDCSMGs9u2j4yG5qFSbJQNg4K9PB26tbFBjKqPPKA== successfully removed temp profile /tmp/uc_v4yrv40b"

# EXTRACT THE TOKENS
VISITORDATA=$(echo ${theOUTPUT} | awk -F '[ ]' '{print $18}')
POTOKEN=$(echo ${theOUTPUT} | awk -F '[ ]' '{print $20}')

# DISPLAY TO $USER
echo "po_token: \"${POTOKEN}\""
echo "visitor_data: \"${VISITORDATA}\""

echo ""
echo "Changing to invidious directory (${INSTALL_DIR})"
echo ""

# CHANGE TO CONFIG DIR
cd ${INSTALL_DIR}config/

echo "Deleting old config.yml"

# REMOVE EXISTING CONFIG
rm config.yml

echo "Copying config.example.yml to config.yml"

# COPY EXAMPLE CONFIG (preconfigured to your liking)
cp config.example.yml config.yml

echo "Writing tokens to config file"
echo ""

# ECHO THE TOKENS TO BOTTOM OF THE CONFIG FILE
echo "po_token: \"${POTOKEN}\"" | tee -a config.yml
echo "visitor_data: \"${VISITORDATA}\"" | tee -a config.yml

# ECHO THE TOKENS TO LOGFILE
TSTAMP=$(date +"[%D][%T]")
echo "" | tee -a ${LOG_FILE} >/dev/null
echo "${TSTAMP} UPDATED TOKENS!" | tee -a ${LOG_FILE} >/dev/null
echo "${TSTAMP} po_token: \"${POTOKEN}\"" | tee -a ${LOG_FILE} >/dev/null
echo "${TSTAMP} visitor_data: \"${VISITORDATA}\"" | tee -a ${LOG_FILE} >/dev/null

echo ""
echo "Restarting Invidious Service"
echo ""

sudo service invidious restart

echo ""
echo "Done. Have a good day :)"
echo ""
