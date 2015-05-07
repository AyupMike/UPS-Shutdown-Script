#!/bin/bash
clear

#************************************************#
#               ups_shutdown.sh                  #
#           written by Mike Stephens             #
#                 ayup.agency                    #
#                Jan 05, 2011                    #
#                                                #
#          UPS Remote Shutdown Script            #
#                                                #
#   This script is to be executed on a server    #
#   with a UPS attached. It will connect to      #
#   remote servers via SSH and send appropriate  #
#   commands. Finally, it will shutdown the      #
#   server executing the script.                 #
#                                                #
#   NOTE: Using SSH key auth so don't have to    #
#   enter credentials.                           #
#************************************************#

MSG="Shutting down due to power loss!"

echo "Running UPS shutdown script..."

# -------------------------------------- #
#  svr01 commands                        #
# -------------------------------------- #

echo "Connecting to server 'svr01' via SSH..."

#Connect to 'svr01'
ssh root@192.168.100.10 -T <<\EOF

  echo "Attempting to close FileMaker Pro Server and databases"

  #Force close all open databases
  fmsadmin close -m 'Power disruption. FileMaker Pro closing immediately.' -y -u admin -p password

  #Stop FMP Server
  fmsadmin stop -m 'Power disruption. FileMaker Pro shutting down immediately.' -y -u admin -p password

  echo "FileMaker Pro Server databases closed and server stopped"

  #Send shutdown command
  shutdown -h now "${MSG}"

  #Logout
  logout

EOF

echo "Server 'svr01' has been sent the shutdown command"

# -------------------------------------- #
#  svr02 commands                        #
# -------------------------------------- #

sleep 2

echo "Connecting to server 'svr02' via SSH..."

#Connect to 'svr02'
ssh root@192.168.100.11 -T <<\EOF

  #Send shutdown command
  shutdown -h now "${MSG}"

  #Logout
  logout

EOF

echo "Server 'svr02' has been sent the shutdown command"

# -------------------------------------- #
#  svr03 commands                        #
# -------------------------------------- #

sleep 2

#Send echo before we shut down this server...
echo "Server 'svr03' has been sent the shutdown command"

#Send shutdown command to THIS server
shutdown -h now "${MSG}"
