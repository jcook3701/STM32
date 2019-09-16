CFLAGS = -mcpu=cortex-m4 \
	-mfpu=fpv4-sp-d16 \
	-mfloat-abi=hard \
	-mlittle-endian \
	-D  STM32L432xx \
	-D  USE_HAL_DRIVER \
	-mthumb -g -Os -fmessage-length=0 \
	-ffunction-sections -fdata-sections \
	-Wall -Wshadow -Wlogical-op \
	-Wfloat-equal \
	-fabi-version=0 \
	-fno-exceptions \
	-I"$(LIB_DIR_L4XX)/" \
	-I"$(LIB_DIR_L4XX)/Drivers/BSP/STM32L4xx_Nucleo_32" \
	-I"$(LIB_DIR_L4XX)/Drivers/CMSIS/Include" \
	-I"$(LIB_DIR_L4XX)/Drivers/CMSIS/Device/ST/STM32L4xx/Include" \
	-I"$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Inc" \
	-I"$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source" \
	-I"$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/include" \
	-I"$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM4F" \
	-I"$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/CMSIS_RTOS" \
	-I"application" \
	-I"application/lib" \
	-MMD -MP -c

LINKFLAGS = -mcpu=cortex-m4 \
	-mfpu=fpv4-sp-d16 \
	-mfloat-abi=hard \
	-mlittle-endian \
	-Os -mthumb \
	-fmessage-length=0 -ffunction-sections -fdata-sections \
	-Wall -Wshadow -Wlogical-op -Wfloat-equal \
	-T application/SW4STM32/STM32L432KC_NUCLEO/STM32L432KCUx_FLASH.ld \
	-Xlinker \
	--gc-sections -Wl,-Map,"$(MAP)" \
	-specs=nano.specs

LIBRARIES = $(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/queue.c \
	$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/list.c \
	$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/tasks.c \
	$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/timers.c \
	$(LIB_DIR_L4XX)/Drivers/BSP/STM32L4xx_Nucleo_32/stm32l4xx_nucleo_32.c \
	$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM4F/port.c \
	$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/portable/MemMang/heap_4.c \
	$(LIB_DIR_L4XX)/Middlewares/FreeRTOS/Source/CMSIS_RTOS/cmsis_os.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_gpio.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_rcc_ex.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_tim.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_pwr_ex.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_dma.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_cortex.c \
	$(LIB_DIR_L4XX)/Drivers/STM32L4xx_HAL_Driver/Src/stm32l4xx_hal_tim_ex.c \
	application/SW4STM32/startup_stm32l432xx.s

# application/SW4STM32/syscalls.c
