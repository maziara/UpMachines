#!/bin/bash

#This script checks for the machines defined in the 'machines.conf' file and checks if the machine is up.
#For each machine that finds to be up, it creates a file name according to the Label (defined in config file) 
# in the 'UpMachines' subfolder.
#This script better be run as an scheduled cron task

#source $BYOBU_CONFIG_DIR/bin/UpMachines/paths.conf
ProjectPath=`dirname $0`
LabelsPath="$ProjectPath/UpMachines"

while read line
do
  line=`echo $line | sed 's/^#.*//'`
  if [ -n "$line" ]; 
  then
    label=`echo $line | awk -F " " '{print ($1)}'`;
    address=`echo $line | awk -F " " '{print ($2)}'`;
    port=`echo $line | awk -F " " '{print ($3)}'`;
    wait_time=`echo $line | awk -F " " '{print ($4)}'`;

    if nc -z -w $wait_time $address $port; then
      touch $LabelsPath/$label;
    else
      if [ -e $LabelsPath/$label ]; then rm $LabelsPath/$label; fi
    fi

  fi
done < $HOME/.UpMachines.conf
