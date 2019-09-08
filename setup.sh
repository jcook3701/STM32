#!/bin/bash

#########
# Utils #
#########

# Make sure only non-root users can run our script
if [[ $EUID -eq 0 ]]
then
    echo "STM32 installer script must NOT be run as root! " 1>&2
    exit 1
fi

echo " ──────────────────────────────────────────────────┐"
echo "            Acquiring sudo privileges               "
echo "└────────────────────────────────────────────────── "
sudo echo "" || exit 1
# Stash the tool directory
TOOLDIR=$(dirname "$0")/tools
# Get System Architecture
ARCH=$(uname -m)
# Get System Operating System
OS=$(uname -s)
# Get base path
BASE=`pwd`
# Define name of the arm version we are downloading
ARM_GCC=gcc-arm-none-eabi-8-2019-q3-update
# ARM_GCC=gcc-arm-none-eabi-6-2017-q2-update

echo " ──────────────────────────────────────────────────┐"
echo ""
echo "  Starting STM32-DEV-Linux Environment Setup Script  "
echo ""
echo "└────────────────────────────────────────────────── "
sleep 1
echo " ──────────────────────────────────────────────────┐"
echo "              Detecting your platform               "
echo "└────────────────────────────────────────────────── "
if [[ "$ARCH" != 'x86_64' || "$ARCH" == "amd64" ]]
then
    echo 'Only 64-bit architecture systems are supported!'
    exit 1
fi
echo " ──────────────────────────────────────────────────┐"
echo "               System Dependent Setup               "
echo "└────────────────────────────────────────────────── "
cd $TOOLDIR
case "$OS" in
    Linux) # Debian Linux Case
	echo "Operating System: Linux"
	STMDEV=/dev/ttyUSB0
        echo " ───────────────────────────────────────────────────┐"
        echo "               Updating Apt listings                 "
        echo "└─────────────────────────────────────────────────── "
        sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
        sudo apt update
        echo " ───────────────────────────────────────────────────┐"
        echo "                Installing OpenOCD                   "
        echo "└─────────────────────────────────────────────────── "
        sudo apt -y install openocd
        echo " ───────────────────────────────────────────────────┐"
        echo "        Installing build-essentials (make)           "
        echo "└─────────────────────────────────────────────────── "
        sudo apt -y install build-essential
	echo " ───────────────────────────────────────────────────┐"
	echo "         Updating Git, Python, PIP, and Curl         "
	echo "└─────────────────────────────────────────────────── "
	sudo apt -y install git python python-pip curl
	echo " ──────────────────────────────────────────────────┐"
	echo "      Adding current user to '$GROUP' group         "
	echo "└────────────────────────────────────────────────── "
	THE_GROUP=$(getent group | grep 'dial' | cut -d: -f1)
	sudo adduser $USER $THE_GROUP
	echo " ──────────────────────────────────────────────────┐"
	echo "                Downloading libusb                  "
	echo "└────────────────────────────────────────────────── "
	sudo apt -y install libusb-1.0
	echo " ──────────────────────────────────────────────────┐"
	echo "           Downloading gcc-arm-embedded             "
	echo "└────────────────────────────────────────────────── "
	# ARM GCC Compiler Version 6
	# curl -C - -LO https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/$ARM_GCC-linux.tar.bz2
	# ARM GCC Compiler Version 8
	curl -C - -LO https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/$ARM_GCC-linux.tar.bz2
	GCC_PKG=$ARM_GCC-linux.tar.bz2
	;;
    
    Darwin) # OS X Case
	echo "Operating System: Mac OSX Darwin"
	STMDEV=/dev/tty.usbserial-A503JOLS
        echo " ───────────────────────────────────────────────────┐"
        echo "    Install XCode Command Line Tools (GCC, make)     "
        echo "└─────────────────────────────────────────────────── "
        xcode-select --install &> /dev/null	# Install Command Line tools (make etc...)
        sudo xcodebuild -license accept # Accept User Agreement
	echo " ──────────────────────────────────────────────────┐"
	echo "                Downloading libusb                  "
	echo "└────────────────────────────────────────────────── "
	which -s brew
	if [[ $? != 0 ]] ; then
	    # Install Homebrew
	    # ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	    echo "Please install homebrew"
	else
	    brew update
	    brew install libusb
	fi
	echo " ──────────────────────────────────────────────────┐"
	echo "           Downloading gcc-arm-embedded             "
	echo "└────────────────────────────────────────────────── "
	# ARM GCC Compiler Version 6
	# curl -C - -LO https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/$ARM_GCC-mac.tar.bz2
	# ARM GCC Compiler Version 8
	curl -C - -LO https://developer.arm.com/-/media/Files/downloads/gnu-rm/8-2019q3/$ARM_GCC-mac.tar.bz2
	GCC_PKG=$ARM_GCC-mac.tar.bz2
	;;
    
    *)	# Defa'ult if Operating System other than Mac or Linux
	# I will never be supporing Windows systems as I refuse to pay for trash.
	echo "Only Linux, OSX, and WSL (Windows Subsystem Linux) systems are supported! Exiting..."
	exit 1
	;;
esac

# Currently running commands in the Tools directory.
echo " ──────────────────────────────────────────────────┐"
echo "            Extracting gcc-arm-embedded             "
echo "└────────────────────────────────────────────────── "
tar --extract \
    --verbose \
    --bzip2 \
    --file=$GCC_PKG\
    --exclude='share/doc' 2> /dev/null
echo " ──────────────────────────────────────────────────┐"
echo "            Extracting en.stsw-link007              "
echo "└────────────────────────────────────────────────── "
unzip en.stsw-link007.zip

# Return Back to Head of this repository.
cd $BASE

echo " ───────────────────────────────────────────────────┐"
echo "          Generating Environment Variables           "
echo "└─────────────────────────────────────────────────── "
cat > env.sh <<EOL
#!/bin/bash
# Setup a base directory:
STM32BASE=$BASE
# STM32 Board Settings:
STM32DEV=$STMDEV # Set this to your board ID
STM32BAUD=38400
# Project Target Settings:
# Sets the binary name, defaults to "firmware" (Optional)
STM32PROJ=firmware
# Sets which DBC to generate, defaults to "DBG"
ENTITY=DBG
# Compiler and library settings:
# Selects compiler version to use
PATH=\$PATH:\$STM32BASE/tools/gcc-arm-none-eabi-8-2019-q3-update/bin
STM32_H7XX_LIBDIR="\$STM32BASE/firmware/stm32H743/lib"
STM32_L4XX_LIBDIR="\$STM32BASE/firmware/stm32L432/lib"
# Export everything to the environment
export STM32BASE
export STM32DEV
export STM32BAUD
export STM32PROJ
export ENTITY
export PATH
export STM32_H7XX_LIBDIR
export STM32_L4XX_LIBDIR
EOL

echo " ───────────────────────────────────────────────────┐"
echo "      Linking Files to Firmware Project Folder       "
echo "└─────────────────────────────────────────────────── "
source env.sh
./tools/link_projects.sh
echo " ───────────────────────────────────────────────────┐"
echo "                   SETUP COMPLETE!                   "
echo "                                                     "
echo " IF THIS IS YOUR FIRST TIME RUNNING THE SETUP SCRIPT "
echo "             PLEASE RESTART YOUR SYSTEM              "
echo "         TO LOAD CODE INTO YOUR STM32 BOARD          "
echo "└─────────────────────────────────────────────────── "
