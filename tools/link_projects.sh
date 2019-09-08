#!/bin/bash

if [ -z $ESP32BASE} ]
then
    SOURCE_FILE_STRING='\e[1;31msource env.sh\e[0;31m'
    printf "\n"
    printf "\e[0;31m ========================================= \n"
    printf "\e[0;31m|  ESP32-Dev environment variables not set |\n"
    printf "\e[0;31m|      PLEASE run '%b'          |\n" "$SOURCE_FILE_STRING"
    printf "\e[0;31m|                                          |\n"
    printf "\e[0;31m|  'env.sh' can be found at the root of    |\n"
    printf "\e[0;31m|       the ESP32-Dev Project Folder       |\n"
    printf "\e[0;31m|                                          |\n"
    printf "\e[0;31m|    If 'env.sh' doesn't exist run the     |\n"
    printf "\e[0;31m|    setup script in ESP32-Dev Project     |\n"
    printf "\e[0;31m ========================================= \n"
    printf "\e[0m\n"
    exit 1
fi
# DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )
# PROJECTS=(${ESP32BASE}/firmware/Starter/ ${ESP32BASE}/firmware/examples/*/)
PROJECTS=(${ESP32BASE}/firmware/stm32H743/examples/*/ ${ESP32BASE}/firmware/stm32L432/examples/*/)
for PROJECT in ${PROJECTS[@]}
do
    echo "Creating link for: $PROJECT/env.sh"
    echo "Creating link for: $PROJECT/makefile"
    # Place env.sh link into project folder
    rm -f "$PROJECT/env.sh"
    ln -s -f "${ESP32BASE}/env.sh" "$PROJECT/env.sh"
    # # # # Place makefile link into project folder
    rm -f "$PROJECT/makefile"
    ln -s -f "${ESP32BASE}/makefile" "$PROJECT/makefile"
done
