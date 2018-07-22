#!/bin/sh

cd `dirname $0`

ENCODED_FILE_COUNT=0
COMPLETE_FILE_LIST="
"

# loop target files
for file in `\find ${HANDBRAKECLI_INPUT_PATH} -maxdepth 3 -name '*.MOV'`;
do
  # If it is the maximum processing number, exit the loop
  if [ $ENCODED_FILE_COUNT -ge ${HANDBRAKECLI_MAX_FILE_COUNT} ]; then
    echo "exit loop"
    break
  fi
  
  # get file name
  INPUT_FILE_PATH_INCLUDE_EXTENSION=${file}
  echo ${INPUT_FILE_PATH_INCLUDE_EXTENSION}
  INPUT_FILE_PATH_EXCLUDE_EXTENSION=$(echo ${file} | sed 's/\.[^\.]*$//')
  echo ${INPUT_FILE_PATH_EXCLUDE_EXTENSION}

  # execute encoding by HandBrakeCLI
  if [ ! -e ${INPUT_FILE_PATH_EXCLUDE_EXTENSION}.mp4 ]; then
    # if include "rotate" character in file name, add rotate option
    if [ `echo ${INPUT_FILE_PATH_EXCLUDE_EXTENSION} | grep 'rotate5'` ]; then
      #It's not working
      HandBrakeCLI -i ${INPUT_FILE_PATH_INCLUDE_EXTENSION} -o ${INPUT_FILE_PATH_EXCLUDE_EXTENSION}.mp4 --rotate 5
    else
      HandBrakeCLI -i ${INPUT_FILE_PATH_INCLUDE_EXTENSION} -o ${INPUT_FILE_PATH_EXCLUDE_EXTENSION}.mp4
    fi
    # increment ENCODED_FILE_COUNT
    ENCODED_FILE_COUNT=$(( ENCODED_FILE_COUNT + 1 ))

    # add to complete file list
    COMPLETE_FILE_LIST+="
    - $(echo ${INPUT_FILE_PATH_INCLUDE_EXTENSION} | sed 's/\\/\//g')"

    # echo progress
    echo "########################################################"
    echo "#"
    echo "#"
    echo "# ENCODED_FILE_COUNT : ${ENCODED_FILE_COUNT}"
    echo "#"
    echo "#"
    echo "########################################################"

  fi
done

# send to Slack
if (( ${ENCODED_FILE_COUNT}>0 )) ;
then
  echo "Start send to Slack"
  echo "Succesful HandBrake-CLI encoding batch. Total encoded files counts:${ENCODED_FILE_COUNT}${COMPLETE_FILE_LIST}" | bash ./sendResultToSlack.sh
  echo "Finished send to Slack"
fi
