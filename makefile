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
	-mfpu= fpv5-sp-d16 \
	-mfloat-abi=hard \
	-mthumb -g -Os -fmessage-length=0 \
	-ffunction-sections -fdata-sections \
	-Wall -Wshadow -Wlogical-op \
	-Wfloat-equal \
	-fabi-version=0 \
	-fno-exceptions \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/Drivers/BSP/STM32H7xx_Nucleo_144" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS" \
	-I"$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/" \
	-I"L2_Drivers" \
	-I"L3_Utils" \
	-I"L4_IO" \
	-I"L5_Application" \
	-I"L5_Assembly" \
	-MMD -MP -c

LINKFLAGS = -mcpu=cortex-m7 \
	-mfpu= fpv5-sp-d16 \
	-mfloat-abi=hard \
	-Os -mthumb \
	-fmessage-length=0 -ffunction-sections -fdata-sections \
	-Wall -Wshadow -Wlogical-op -Wfloat-equal \
	-T $(LIB_DIR_H7XX)//loader.ld \
	-nostartfiles \
	-Xlinker \
	--gc-sections -Wl,-Map,"$(MAP)" \
	-specs=nano.specs

# LIBRARIES			= $(shell find "$(LIB_DIR)" -name '*.c' -o -name '*.cpp')
SOURCES	= $(shell find L5_Application L5_Assembly \
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
	@echo "    telemetry     - will launch telemetry interface"
	@echo "    clean         - cleans project folder"
	@echo "    cleaninstall  - cleans, builds and installs firmware"
	@echo "    show-obj-list - Shows all object files that will be compiled"

build: $(OBJ_DIR) $(BIN_DIR) $(SIZE) $(LIST) $(BINARY) $(HEX)

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
	mkdir $(OBJ_DIR)

$(BIN_DIR):
	@echo 'Creating Binary Folder: $<'
	mkdir $(BIN_DIR)

clean:
	rm -fR $(OBJ_DIR) $(BIN_DIR) 

flash: build
	bash -c "\
	source $(SJBASE)/tools/Hyperload/modules/bin/activate && \
	python2.7 $(SJBASE)/tools/Hyperload/hyperload.py -b 576000 -c 48000000 -a clocks -d $(SJDEV) $(BINARY)"

telemetry:
	@bash -c "\
	source $(SJBASE)/tools/Telemetry/modules/bin/activate && \
	python2.7 $(SJBASE)/tools/Telemetry/telemetry.py"
