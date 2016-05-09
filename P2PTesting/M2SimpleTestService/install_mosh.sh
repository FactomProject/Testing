#!/bin/bash +x

echo "Installing Mosh on all of the machines"

while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "Configuring: $line"
ssh -n $line 'yes | sudo apt-get install mosh'
done < "./leaders.conf"

while IFS='' read -r line || [[ -n "$line" ]]; do
  echo "Configuring: $line"
ssh -n $line 'yes | sudo apt-get install mosh'
done < "./followers.conf"
