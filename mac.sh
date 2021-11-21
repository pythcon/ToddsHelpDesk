#!/bin/bash
TPUT=/usr/bin/tput
ECHORED=$($TPUT setaf 1)
ECHOGRN=$($TPUT setaf 2)
ECHORST=$($TPUT sgr0)
PRINTF=/usr/bin/printf
ECHO=/usr/bin/echo
CLEAR=/usr/bin/clear
SSH=/usr/bin/ssh

$CLEAR
echo "${ECHOGRN}##############################################################################################${ECHORST}"
echo "${ECHOGRN}#                                 ${ECHORED}Welcome to Todd's Helpdesk                                 ${ECHOGRN}#${ECHORST}"
echo "${ECHOGRN}#                     ${ECHORED}This script will allow me to control your computer                     ${ECHOGRN}#${ECHORST}"
echo "${ECHOGRN}##############################################################################################${ECHORST}"
echo ""

# Escelate Privileges #
echo "Please enter your computer password (note: nothing will show up, just type it and press enter)"

sudo su <<EOF

# Enable Remote Managment #
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate >/dev/null 2>&1
$PRINTF "\n\nEnabled Remote Management (1/2)..."

# Set VNC Password
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -clientopts -setvnclegacy -vnclegacy yes -setvncpw -vncpw password >/dev/null 2>&1
$PRINTF "\nEnabled Remote Management (2/2)...\n\n"

# Start SSH Connection #
echo "Please enter the verification code (note: nothing will show up, just type it and press enter)"
$SSH -o StrictHostKeychecking=no -R 12345:localhost:5900 -N <user>@<host>

# Disable Remote Management
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate >/dev/null 2>&1

EOF

# Cleanup #
$CLEAR
$PRINTF "\n\nDisabled Remote Management..."
$PRINTF "\n\n${ECHORED}Thanks for using Todd's Helpdesk!${ECHORST}\n\n"
