#!/bin/bash

#This script tries to install the files and lines required to run the UpMachines script for byobu.
#A cheduler will be added to cron to run the 'check_UpMachines.sh' script every 5 minutes.
#
#It also creates a symbolic link to 'byobu_show_UpMachines.sh' script in the bin folder of byobu.
#

if [ -e byobu_show_UpMachines.sh ]; then
  if [ ! -h ../120_UpMachines ]; then
    ln -s ./UpMachines/byobu_show_UpMachines.sh ../120_UpMachines ;
    echo "Link created in byobu's bin folder.";
  fi

  if [ ! -d UpMachines ]; then
    mkdir UpMachines;  #folder for the labels
    echo "Label folders created.";
  fi

  line="*/5 * * * * $BYOBU_CONFIG_DIR/bin/UpMachines/check_UpMachines.sh >> $BYOBU_CONFIG_DIR/bin/UpMachines/errorlog.txt 2>&1"
  if crontab -l|grep "$BYOBU_CONFIG_DIR/bin/UpMachines/check_UpMachines.sh"; then
    echo "Crontab already contains the line for script.";
  else
    (crontab -l; echo "$line") | crontab - ;
    echo "Crontab updated.";
  fi

  if [ ! -e $HOME/.UpMachines.conf ]; then
    cp machines.conf $HOME/.UpMachines.conf;
    echo "Config file created at '$HOME/.UpMachines.conf'. Please update the file accordingly.";
  fi

else
  echo "Cannot find the 'byobu_show_UpMachines.sh' script in the current path!";
  echo "Please run this script from the project's path.";
fi
