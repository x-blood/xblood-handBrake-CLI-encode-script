#!/bin/sh

ENCODED_FILE_COUNT=0

# loop target files
for file in `\find ${HANDBRAKECLI_INPUT_PATH} -maxdepth 1 -name '*.MOV'`; do
    # get file name
    INPUT_FILE_PATH_INCLUDE_EXTENSION=${file}
    echo ${INPUT_FILE_PATH_INCLUDE_EXTENSION}
    INPUT_FILE_PATH_EXCLUDE_EXTENSION=$(echo ${file} | sed 's/\.[^\.]*$//')
    echo ${INPUT_FILE_PATH_EXCLUDE_EXTENSION}

    # execute encoding by HandBrake-CLI
    HandBrakeCLI -i ${INPUT_FILE_PATH_INCLUDE_EXTENSION} -o ${INPUT_FILE_PATH_EXCLUDE_EXTENSION}.mp4

    # move to finished directory
    mv ${INPUT_FILE_PATH_INCLUDE_EXTENSION} ${HANDBRAKECLI_INPUT_PATH}/finished/

    # increment ENCODED_FILE_COUNT
    ENCODED_FILE_COUNT=$(( ENCODED_FILE_COUNT + 1 ))
done

# send to Slack
if (( ${ENCODED_FILE_COUNT}>0 )) ;
then
    echo "Start send to Slack"
    echo "Succesful HandBrake-CLI encoding batch. Total encoded files counts:${ENCODED_FILE_COUNT}" | bash ./sendResultToSlack.sh
    echo "Finished send to Slack"
fi

