# Allow settiing a project name from the environment, default to firmware.
# Only affects the name of the generated binary.
# TODO: Set this from the directory this makefile is stored in
PROJ 			?= firmware

ENTITY			?= DBG

# IMPORTANT: Must be accessible via the PATH variable!!!
CC			= arm-none-eabi-gcc
CPPC			= arm-none-eabi-g++
OBJDUMP			= arm-none-eabi-objdump
SIZEC			= arm-none-eabi-size
OBJCOPY			= arm-none-eabi-objcopy
NM	        	= arm-none-eabi-nm

# Internal build directories
OBJ_DIR			= build/obj
BIN_DIR			= build/bin
LIB_DIR_H7XX		= $(STM32_H7XX_LIBDIR)
LIB_DIR_L4XX		= $(STM32_L4XX_LIBDIR)

define n

endef

ifndef STM32DEV
$(error $n$n=============================================$nSTM32 environment variables not set.$nPLEASE run "source env.sh"$n=============================================$n$n)
endif

CFLAGS = -mcpu=cortex-m7 \
	-mfpu=fpv5-sp-d16 \
	-mfloat-abi=hard \
	-mthumb -g -Os -fmessage-length=0 \
	-ffunction-sections -fdata-sections \
	-Wall -Wshadow -Wlogical-op \
	-Wfloat-equal \
	-fabi-version=0 \
	-fno-exceptions \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/Drivers/BSP/STM32H7xx_Nucleo_144" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS/Device/ST/STM32H7xx/Include" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS/DSP/Include" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS/Include" \
	-I"$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Inc" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/include" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM4F" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/CMSIS_RTOS" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/apps/httpd" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/lwip" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/lwip/apps" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/lwip/priv" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/lwip/prot" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/netif" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/netif/ppp" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/netif/ppp/polarssl" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/posix" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/posix/sys" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/system/arch" \
	-I"$(LIB_DIR_H7XX)/Middlewares/mbedTLS" \
	-I"application" \
	-I"application/lib" \
	-MMD -MP -c

LINKFLAGS = -mcpu=cortex-m7 \
	-mfpu=fpv5-sp-d16 \
	-mfloat-abi=hard \
	-Os -mthumb \
	-fmessage-length=0 -ffunction-sections -fdata-sections \
	-Wall -Wshadow -Wlogical-op -Wfloat-equal \
	-T $(LIB_DIR_H7XX)/SW4STM32/STM32H743ZI_Nucleo/STM32H743ZITx_FLASH.ld \
	-nostartfiles \
	-Xlinker \
	--gc-sections -Wl,-Map,"$(MAP)" \
	-specs=nano.specs

# LIBRARIES = $(shell find "$(LIB_DIR)" -name '*.c' -o -name '*.cpp')

LIBRARIES = $(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/MemMang/heap_4.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/CMSIS_RTOS/cmsis_os.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/RVDS/ARM_CM4F/port.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/netif/ethernet.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/system/OS/sys_arch.c \
	$(LIB_DIR_H7XX)/Drivers/BSP/Components/lan8742/lan8742.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rcc.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_tim_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_sdram.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i2c_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_ltdc.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_gpio.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_flash.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_eth_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_cortex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_tim.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rcc_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_pwr.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i2c.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_mdma.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_eth.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_flash_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_ll_fmc.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma2d.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_uart.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_adc_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_adc.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_pwr_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_uart_ex.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/apps/httpd/httpd.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/apps/httpd/fs.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4/ip4.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4/ip4_frag.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4/etharp.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4/icmp.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4/ip4_addr.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4/igmp.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4/dhcp.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4/autoip.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api/err.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api/netdb.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api/tcpip.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api/netifapi.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api/netbuf.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api/api_lib.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api/api_msg.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api/sockets.c \
	$(LIB_DIR_H7XX)/Drivers/BSP/STM32H7xx_Nucleo_144/stm32h7xx_nucleo_144.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/queue.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/timers.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/tasks.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/list.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/croutine.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/tcp_out.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/inet_chksum.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/tcp.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/init.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/udp.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/dns.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/netif.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/mem.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/raw.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/def.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/stats.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/pbuf.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/sys.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/timeouts.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/tcp_in.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/memp.c \
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ip.c


SOURCES	= $(shell find application/src \
	-name '*.c' -o\
	-name '*.s' -o \
	-name '*.S' -o \
	-name '*.cpp' \
	-not -path './test/*' \
	2> /dev/null)

COMPILABLES = $(LIBRARIES) $(SOURCES)

# $(patsubst %.cpp,%.o, LIST) 		: Replace .cpp -> .o
# $(patsubst %.c,%.o, LIST)			: Replace .c -> .o
# $(patsubst src/%,%, LIST) 		: Replace src/path/file.o -> path/file.o
# $(addprefix $(OBJ_DIR)/, LIST) 	: Add OBJ DIR to path (path/file.o -> obj/path/file.o)

OBJECT_FILES = 	$(addprefix $(OBJ_DIR)/, \
			$(patsubst %.S,%.o, \
				$(patsubst %.s,%.o, \
					$(patsubst %.c,%.o, \
						$(patsubst %.cpp,%.o, \
							$(COMPILABLES) \
						) \
					) \
				) \
			) \
		)

EXECUTABLE	    = $(BIN_DIR)/$(PROJ).elf
SYMBOL_TABLE	    = $(BIN_DIR)/symbol-table.c
BINARY              = $(EXECUTABLE:.elf=.bin)
HEX                 = $(EXECUTABLE:.elf=.hex)
SYMBOLS_HEX	    = $(EXECUTABLE:.elf=.symbols.hex)
LIST                = $(EXECUTABLE:.elf=.lst)
SYMBOLS_LIST        = $(EXECUTABLE:.elf=.symbols.lst)
SIZE                = $(EXECUTABLE:.elf=.siz)
SYMBOLS_SIZE        = $(EXECUTABLE:.elf=.symbols.siz)
MAP                 = $(EXECUTABLE:.elf=.map)
SYMBOLS_MAP         = $(EXECUTABLE:.elf=.symbols.map)
SYMBOLS             = $(EXECUTABLE:.elf=.sym)
SYMBOLS_EXECUTABLE  = $(EXECUTABLE:.elf=.symbols.elf)
SYMBOLS_OBJECT      = $(SYMBOLS).o

.DELETE_ON_ERROR:
.PHONY: sym-build build cleaninstall telemetry monitor show-obj-list clean sym-flash flash telemetry

default:
	@echo "List of available targets:"
	@echo "    build         - builds firmware project"
	@echo "    sym-build     - builds firmware project with embeddeding symbol table"
	@echo "    flash         - builds and installs firmware on to SJOne board"
	@echo "    sym-flash     - builds and installs firmware on to SJOne board with embeddeding symbol table"
	@echo "    clean         - cleans project folder"
	@echo "    cleaninstall  - cleans, builds and installs firmware"
	@echo "    show-obj-list - Shows all object files that will be compiled"

# $(BINARY)
build: $(OBJ_DIR) $(BIN_DIR) $(SIZE) $(LIST) $(HEX)

sym-build: $(OBJ_DIR) $(BIN_DIR) $(SYMBOLS_SIZE) $(SYMBOLS_LIST) $(SYMBOLS_HEX)

cleaninstall: clean build flash

show-obj-list:
	@echo $(OBJECT_FILES)

print-%  : ; @echo $* = $($*)

$(SYMBOLS_HEX): $(SYMBOLS_EXECUTABLE)
	@echo ' '
	@echo 'Invoking: Cross ARM GNU Create Symbol Linked Flash Image'
	@$(OBJCOPY) -O ihex "$<" "$@"
	@echo 'Finished building: $@'
	@echo ' '

$(BINARY): $(EXECUTABLE)
	@printf '$(YELLOW)Generating Binary Image $(RESET): $@ '
	@$(OBJCOPY) -O binary "$<" "$@"
	@printf '$(GREEN)Binary Generated!$(RESET)\n'

$(HEX): $(EXECUTABLE)
	@echo ' '
	@echo 'Invoking: Cross ARM GNU Create Flash Image'
	@$(OBJCOPY) -O ihex "$<" "$@"
	@echo 'Finished building: $@'
	@echo ' '

$(SYMBOLS_SIZE): $(SYMBOLS_EXECUTABLE)
	@echo ' '
	@echo 'Invoking: Cross ARM GNU Print Size'
	@$(SIZEC) --format=berkeley "$<"
	@echo 'Finished building: $@'
	@echo ' '

$(SIZE): $(EXECUTABLE)
	@echo ' '
	@echo 'Invoking: Cross ARM GNU Print Size'
	@$(SIZEC) --format=berkeley "$<"
	@echo 'Finished building: $@'
	@echo ' '

$(SYMBOLS_LIST): $(SYMBOLS_EXECUTABLE)
	@echo ' '
	@echo 'Invoking: Cross ARM GNU Create Assembly Listing'
	@$(OBJDUMP) --source --all-headers --demangle --line-numbers --wide "$<" > "$@"
	@echo 'Finished building: $@'
	@echo ' '

$(LIST): $(EXECUTABLE)
	@echo ' '
	@echo 'Invoking: Cross ARM GNU Create Assembly Listing'
	@$(OBJDUMP) --source --all-headers --demangle --line-numbers --wide "$<" > "$@"
	@echo 'Finished building: $@'
	@echo ' '

$(SYMBOLS_EXECUTABLE): $(SYMBOLS_OBJECT)
	@echo ' '
	@echo 'Linking: FINAL Symbol Table Linked EXECUTABLE'
	@mkdir -p "$(dir $@)"
	@$(CPPC) $(LINKFLAGS) -o "$@" $(SYMBOLS_OBJECT) $(OBJECT_FILES)
	@echo 'Finished building target: $@'
	@echo ' '

$(SYMBOLS_OBJECT): $(SYMBOL_TABLE)
	@echo 'Invoking: Cross ARM GNU Generating Symbol Table Object File'
	@$(CC) $(CFLAGS) -std=gnu11 -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $@'
	@echo ' '

$(SYMBOL_TABLE): $(SYMBOLS)
	@echo 'Generating: Symbol Table C file'
	# Copying firmware.sym to .c file
	@echo '________' > "$@"
	@cat "$<" >> "$@"
	# Remove everything that is not a function (text/code) symbols
	@perl -p -i -e 's;^.* [^T] .*\n;;' "$@"
	@perl -p -i -e 's;^.* T __.*\n;;' "$@"
	@perl -p -i -e 's;^.* T _.*\n;;' "$@"
	@perl -p -i -e 's;^.* T operator .*\n;;' "$@"
	@perl -p -i -e 's;^.* T typeinfo for.*\n;;' "$@"
	@perl -p -i -e 's;^.* T typeinfo name for .*\n;;' "$@"
	@perl -p -i -e 's;^.* T typeinfo name for .*\n;;' "$@"
	@perl -p -i -e 's;^.* T vtable for .*\n;;' "$@"
	@perl -p -i -e 's;^.* T vtable for .*\n;;' "$@"
	# Prepend " to each line
	@perl -p -i -e 's;^;\t";' "$@"
	# Append " to each line
	@perl -p -i -e 's;$$;\\n\";' "$@"
	# Append variable declaration
	@perl -p -i -e 's;^.*________.*;__attribute__((section(".symbol_table"))) const char APP_SYM_TABLE[] =;' "$@"
	# append it with a curly brace and semicolon
	@echo ";" >> "$@"
	@echo ' '

$(SYMBOLS): $(EXECUTABLE)
	@echo 'Generating: Cross ARM GNU NM Generate Symbol Table'
	@$(NM) -C "$<" > "$@"
	@echo 'Finished building: $@'
	@echo ' '

$(EXECUTABLE): $(OBJECT_FILES)
	@echo 'Invoking: Cross ARM C++ Linker'
	@mkdir -p "$(dir $@)"
	@$(CPPC) $(LINKFLAGS) -o "$@" $(OBJECT_FILES)
	@echo 'Finished building target: $@'

$(OBJ_DIR)/%.o: %.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C++ Compiler'
	@mkdir -p "$(dir $@)"
	@$(CPPC) $(CFLAGS) -std=gnu++17 -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(OBJ_DIR)/%.o: %.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	@mkdir -p "$(dir $@)"
	@$(CC) $(CFLAGS) -std=gnu11 -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(OBJ_DIR)/%.o: %.s
	@echo 'Building Assembly file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	@mkdir -p "$(dir $@)"
	@$(CC) $(CFLAGS) -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(OBJ_DIR)/%.o: %.S
	@echo 'Building Assembly file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	@mkdir -p "$(dir $@)"
	@$(CC) $(CFLAGS) -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(OBJ_DIR)/%.o: $(LIB_DIR)/%.cpp
	@echo 'Building C++ file: $<'
	@echo 'Invoking: Cross ARM C++ Compiler'
	@mkdir -p "$(dir $@)"
	@$(CPPC) $(CFLAGS) -std=gnu++17 -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(OBJ_DIR)/%.o: $(LIB_DIR)/%.c
	@echo 'Building C file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	@mkdir -p "$(dir $@)"
	@$(CC) $(CFLAGS) -std=gnu11 -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

$(OBJ_DIR):
	@echo 'Creating Objects Folder: $<'
	mkdir -p $(OBJ_DIR)

$(BIN_DIR):
	@echo 'Creating Binary Folder: $<'
	mkdir -p $(BIN_DIR)

clean:
	rm -fR $(OBJ_DIR) $(BIN_DIR) 

flash: # build
	bash -c "\
	java -jar $(STM32BASE)/tools/stsw-link007/AllPlatforms/./STLinkUpgrade.jar \
	"
