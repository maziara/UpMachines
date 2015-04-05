#!/bin/bash

#This script tries to install the files and lines required to run the UpMachines script for byobu.
#A cheduler will be added to cron to run the 'check_UpMachines.sh' script every 5 minutes.
#
#It also creates a symbolic link to 'byobu_show_UpMachines.sh' script in the bin folder of byobu.
#

if [ -e byobu_show_UpMachines.sh ]; then
  if [ ! -e ../120_UpMachines ]; then
    ln -s ./byobu_show_UpMachines.sh ../120_UpMachines ;
    echo "Link created in byobu's bin folder.";
  fi

  if [ ! -e UpMachines ]; then
    mkdir UpMachines;  #folder for the labels
    echo "Label folders created.";
  fi

  line="*/5 * * * * $BYOBU_CONFIG_DIR/bin/UpMachines/check_UpMachines.sh"
  if crontab -l | grep "$line"; then
    echo "Crontab already contains the line for script.";
  else
    (crontab -l; echo "$line") | crontab - ;
    echo "Crontab updated.";
  fi

else
  echo "Cannot find the 'byobu_show_UpMachines.sh' script in the current path!";
  echo "Please run this script from the project's path.";
fi
