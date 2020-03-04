# STM32 Build Environment 

### Project Goal
My initial goal is to port FreeRTOS to both the NUCLEO-L432KC & NUCLEO-H743ZI2 STM32 development boards.

### Requirments
#### Mac
1. Home-brew


## Initial Setup
1. Run the setup script to begin using this environment.  
__Note:__ This script is currently only working on Ubuntu and Mac.  I will port to work with RHEL type systems in the future.  
```
./setup.sh
```

## Using the Build environment
1. After the setup script has been run it is expected that a new user will move to the firmware directory and then to either of the examples folders located under the stm32h743 or stm32L432 folders.  
2. After choosing a project to begin using it is required that a user source the ENV.sh before using the Makefile.  
```
source ./ENV.sh
```
3. The final step would be to utilize the Makefile with any of the below options.  
```
List of available targets:

build         - builds firmware project
sym-build     - builds firmware project with embeddeding symbol table
flash         - builds and installs firmware on to SJOne board
sym-flash     - builds and installs firmware on to SJOne board with embeddeding symbol table
clean         - cleans project folder
cleaninstall  - cleans, builds and installs firmware
show-obj-list - Shows all object files that will be compiled
```

# Boards
1. [NUCLEO-L432KC](https://www.st.com/en/evaluation-tools/nucleo-l432kc.html)  
![NUCLEO-L432KC][NUCLEO-L432KC]
2. [NUCLEO-H743ZI2](https://www.st.com/en/evaluation-tools/nucleo-h743zi.html)  
![NUCLEO-H743ZI2][NUCLEO-H743ZI2]

[//]: # (Images)

[NUCLEO-L432KC]: ./images/image.PF263436-medium.jpg
[NUCLEO-H743ZI2]: ./images/image.PF264741-medium.jpg
