#!/bin/bash
# Setup a base directory:
STM32BASE=/home/jcook/Documents/git_repo/STM32
# STM32 Board Settings:
STM32DEV=/dev/ttyUSB0 # Set this to your board ID
STM32BAUD=38400
# Project Target Settings:
# Sets the binary name, defaults to "firmware" (Optional)
STM32PROJ=firmware
# Sets which DBC to generate, defaults to "DBG"
ENTITY=DBG
# Compiler and library settings:
# Selects compiler version to use
PATH=$PATH:$STM32BASE/tools/gcc-arm-none-eabi-8-2019-q3-update/bin
STM32_H7XX_LIBDIR="$STM32BASE/firmware/stm32h743/lib"
STM32_L4XX_LIBDIR="$STM32BASE/firmware/stm32l432/lib"
# Export everything to the environment
export STM32BASE
export STM32DEV
export STM32BAUD
export STM32PROJ
export ENTITY
export PATH
export STM32_H7XX_LIBDIR
export STM32_L4XX_LIBDIR
