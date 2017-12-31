#!/bin/sh

# loop target files
for file in `\find ${HANDBRAKECLI_INPUT_PATH} -maxdepth 1 -name '*.MOV'`; do
    # get file name
    INPUT_FILE_PATH_INCLUDE_EXTENSION=${file}
    echo ${INPUT_FILE_PATH_INCLUDE_EXTENSION}
    INPUT_FILE_PATH_EXCLUDE_EXTENSION=$(echo ${file} | sed 's/\.[^\.]*$//')
    echo ${INPUT_FILE_PATH_EXCLUDE_EXTENSION}

    # execute encoding by HandBrake-CLI
    #HandBrake-CLI -i ${input_file_include_extension} -o ${input_file}.mp4

    # move to finished directory
    mv ${INPUT_FILE_PATH_INCLUDE_EXTENSION} ${HANDBRAKECLI_INPUT_PATH}/finished/

done

# send to Slack
echo "Start send to Slack"
echo "Succesful HandBrake-CLI encoding batch" | bash ./sendResultToSlack.sh
echo "Finished send to Slack"

