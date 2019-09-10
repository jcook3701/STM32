#!/bin/bash

if [ -z $STM32BASE} ]
then
    SOURCE_FILE_STRING='\e[1;31msource ENV.sh\e[0;31m'
    printf "\n"
    printf "\e[0;31m ========================================= \n"
    printf "\e[0;31m|  STM32-Dev environment variables not set |\n"
    printf "\e[0;31m|      PLEASE run '%b'          |\n" "$SOURCE_FILE_STRING"
    printf "\e[0;31m|                                          |\n"
    printf "\e[0;31m|  'ENV.sh' can be found at the root of    |\n"
    printf "\e[0;31m|       the STM32-Dev Project Folder       |\n"
    printf "\e[0;31m|                                          |\n"
    printf "\e[0;31m|    If 'ENV.sh' doesn't exist run the     |\n"
    printf "\e[0;31m|    setup script in STM32-Dev Project     |\n"
    printf "\e[0;31m ========================================= \n"
    printf "\e[0m\n"
    exit 1
fi
# DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )/../" && pwd )
# PROJECTS=(${STM32BASE}/firmware/Starter/ ${STM32BASE}/firmware/examples/*/)
PROJECTS=(${STM32BASE}/firmware/stm32H743/examples/*/ ${STM32BASE}/firmware/stm32L432/examples/*/)
for PROJECT in ${PROJECTS[@]}
do
    echo "Removing link for: $PROJECT/ENV.sh"
    echo "Removing link for: $PROJECT/Makefile"
    # Place ENV.sh link into project folder
    rm -f "$PROJECT/ENV.sh"
    # # # # Place makefile link into project folder
    rm -f "$PROJECT/Makefile"
done
