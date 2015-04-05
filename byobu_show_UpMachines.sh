#!/bin/bash

# This is the script to run via byobu to indicate which of the machines 
# defined in 'machines.conf are up
#Therefore, this script needs to be in the 'bin' subfolder in byobu_config folder.
#Or create a symbolic link to this file in that folder.
#According to byobu's documentation, the name of the script must start with the 
# delayed seconds it will be run. e.g. "10_script.sh" means script will run every 10 seconds.

source $BYOBU_CONFIG_DIR/bin/UpMachines/paths.conf

while read line
do
  line=`echo $line | sed 's/^#.*//'`;
  if [ -n "$line" ]; 
  then
    label=`echo $line | awk -F " " '{print ($1)}'`;

    if [ -e $LabelsPath/$label ]; 
    then 
      text="$text \005{= kg}"$label"\005{-}";
    else
      text="$text \005{= kr}"$label"\005{-}";
    fi

  fi
done < <(cat "$HOME"/.UpMachines.conf)
echo -e $text
