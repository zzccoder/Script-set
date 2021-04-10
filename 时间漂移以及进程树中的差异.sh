#!/bin/bash

oldTime="$(date +%s)"
oldPsOutput="$(ps faux)"
while true; do
  sleep 1;
  currentTime="$(date +%s)"
  oldTimeplusfive="$((($oldTime+5)))"
  currentPsOutput="$(ps faux)"
  if [[ "$currentTime" -lt "$oldTime" ||  "$currentTime" -gt "$oldTimeplusfive"  ]]
  then
    (
        echo -e '\n\n======================='
        echo "currentTime=$currentTime oldTime=$oldTime oldTimeplusfive=$oldTimeplusfive"
        echo '-----------------------'
        echo "$oldPsOutput"
        echo '::::::::::::::::::::::::::'
        echo "$currentPsOutput"
    ) | tee -a timedrift.log
  fi
  oldPsOutput=$currentPsOutput
  oldTime=$currentTime
done