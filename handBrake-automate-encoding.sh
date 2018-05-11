#!/bin/sh

ENCODED_FILE_COUNT=0

# loop target files
for file in `\find ${HANDBRAKECLI_INPUT_PATH} -maxdepth 3 -name '*.MOV'`;
do
  # If it is the maximum processing number, exit the loop
  if [ ENCODED_FILE_COUNT -ge ${HANDBRAKECLI_MAX_FILE_COUNT} ]; then
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
    # if you want to move the source to finished directory, remove the comment out.
    #mv ${INPUT_FILE_PATH_INCLUDE_EXTENSION} ${HANDBRAKECLI_INPUT_PATH}/finished/

    # increment ENCODED_FILE_COUNT
    ENCODED_FILE_COUNT=$(( ENCODED_FILE_COUNT + 1 ))
  fi
done

# send to Slack
if (( ${ENCODED_FILE_COUNT}>0 )) ;
then
  echo "Start send to Slack"
  echo "Succesful HandBrake-CLI encoding batch. Total encoded files counts:${ENCODED_FILE_COUNT}" | bash ./sendResultToSlack.sh
  echo "Finished send to Slack"
fi
