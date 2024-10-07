#!/usr/bin/bash

# Absolute path to this script. /home/user/bin/foo.sh
SCRIPT=$(readlink -f $0)

# Absolute path this script is in. /home/user/bin
export SCRIPT_PATH=`dirname $SCRIPT`

. ${SCRIPT_PATH}/config.cfg

echo ""
echo "Updating tokens, please wait..."
echo ""

# CLEAR OLD PROXY VARS
export http_proxy=
export https_proxy=

# TEST WHAT CURRENT IP IS
oldip=$(curl -s ipinfo.io/ip)
echo "OLD EXTERNAL IP: ${oldip}"

echo "Setting proxy ${YOUR_HTTP_PROXY}"

# LEAVE THIS UNLESS YOU NEED SEPERATE PROXY FOR EACH (most users do not)
export http_proxy=${YOUR_HTTP_PROXY}
export https_proxy=${YOUR_HTTP_PROXY}

# TEST WHAT NEW CURRENT IP IS
newip=$(export HTTP_PROXY=${YOUR_HTTP_PROXY} ; export HTTPS_PROXY=${YOUR_HTTP_PROXY} ; curl -s ipinfo.io/ip)
echo "NEW EXTERNAL IP: ${newip}"

echo ""
echo "Generating visitordata & potoken..."
echo ""

# THIS IS THE ACTUAL COMMAND, WILL TAKE TIME TO PROCESS
rawOutput=$(sudo docker run --rm quay.io/invidious/youtube-trusted-session-generator)

# This is a test output
#rawOutput="[INFO] internally launching GUI (X11 environment) [INFO] starting Xvfb [INFO] launching chromium instance [INFO] launching browser. visitor_data: TESTINGOUTPUTONLY-CgtqX3B3M3k2QklmRIEGgAgUg%3D%3D po_token: TESTINGOUTPUTONLY-jCQOtGaJ4KediLqyCsdGqZmU7_0NuXQe-_7s9zNndWofD0quLZnoqft8zDg6ZyApcHLrnPwbdB3dIW1vAfty9Wo-CWMMDCSMGs9u2j4yG5qFSbJQNg4K9PB26tbFBjKqPPKA== successfully removed temp profile /tmp/uc_v4yrv40b"

# EXTRACT THE TOKENS
VISITORDATA=$(echo ${rawOutput} | sed -n "s/^.*visitor_data:\s*\(\S*\).*$/\1/p")
POTOKEN=$(echo ${rawOutput} | sed -n "s/^.*po_token:\s*\(\S*\).*$/\1/p")

# DISPLAY TO $USER
echo "po_token: \"${POTOKEN}\""
echo "visitor_data: \"${VISITORDATA}\""




# MAKE THE CONFIGURATION MODIFICATIONS

echo ""
echo "Editing invidious config file"

sed -i 's/^.*po_token.*/po_token: \"'${POTOKEN}'\"/g' ${INV_INSTALL_DIR}config/config.yml
sed -i 's/^.*visitor_data.*/visitor_data: \"'${VISITORDATA}'\"/g' ${INV_INSTALL_DIR}config/config.yml

# ECHO THE TOKENS TO LOGFILE
TSTAMP=$(date +"[%D][%T]")
echo "" | tee -a ${ITU_LOG_FILE} >/dev/null
echo "${TSTAMP} UPDATED TOKENS!" | tee -a ${ITU_LOG_FILE} >/dev/null
echo "${TSTAMP} po_token: \"${POTOKEN}\"" | tee -a ${ITU_LOG_FILE} >/dev/null
echo "${TSTAMP} visitor_data: \"${VISITORDATA}\"" | tee -a ${ITU_LOG_FILE} >/dev/null




echo ""
echo "Random search to wake up YT ${SCRIPT_PATH}/searches.txt"
echo ""
YT_QUERY=$(shuf -n 1 ${SCRIPT_PATH}/searches.txt)
YT_QUERY=${YT_QUERY//[$'\t\r\n']}
YT_QUERY=${YT_QUERY// /+}
echo "Querying for '${YT_QUERY}'"
curl https://www.youtube.com/results?search_query=${YT_QUERY} > /dev/null
echo "${TSTAMP} YT_QUERY: \"${YT_QUERY}\"" | tee -a ${ITU_LOG_FILE} >/dev/null

echo ""
if [[ ${ISH_ISDOCKER} ]]; then
  echo "Restarting inv_sig_helper docker..."
  sudo docker restart ${INV_SIG_HELPER_CONTAINER_NAME}
else
  echo "Restarting inv_sig_helper service..."  
  sudo service ${ISH_CONT_SERVICE_NAME} restart
fi

sleep 2

echo ""
echo "Restarting Invidious service..."
sudo service ${INVIDIOUS_SERVICE_NAME} restart

echo "${TSTAMP} Restarted docker / invidious service" | tee -a ${ITU_LOG_FILE} >/dev/null

echo ""
echo "Done. Have a good day :)"
echo ""
