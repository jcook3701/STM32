CFLAGS = -mcpu=cortex-m7 \
	-mfpu=fpv5-d16 \
	-mfloat-abi=hard \
	-mlittle-endian \
	-D STM32H743xx \
	-D USE_HAL_DRIVER \
	-D USE_STM32H7XX_NUCLEO_144_MB1364 \
	-mthumb -g -Os -fmessage-length=0 \
	-ffunction-sections -fdata-sections \
	-Wall -Wshadow -Wlogical-op \
	-Wfloat-equal \
	-fabi-version=0 \
	-fno-exceptions \
	-I"$(LIB_DIR_H7XX)/" \
	-I"$(LIB_DIR_H7XX)/Drivers/BSP/STM32H7xx_Nucleo_144" \
	-I"$(LIB_DIR_H7XX)/Drivers/BSP/Components/Common" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS/Include" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS/Device/ST/STM32H7xx/Include" \
	-I"$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Inc" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM4_MPU" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/include" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS-Plus-CLI" \
	-I"application" \
	-I"application/lib" \
	-MMD -MP -c

# Note: Below are old linker flags that Might be needed for another project.
# Note: -specs=nosys.specs should be used if there is no syscalls.c file. If there is a syscalls.c file
#       then -specs=nano.specs flag should be used.
#	-specs=nano.specs
#	-specs=nosys.specs
# Note: This could be the correct mfpu however I will need to check that out later.
#	-mfpu=fpv5-sp-d16
# Note: I have problems linking the libc _init until I removed these flags.
# 	-nostdlib
#	-nostartfiles

LINKFLAGS = -mcpu=cortex-m7 \
	-mfpu=fpv5-d16 \
	-mfloat-abi=hard \
	-mlittle-endian \
	-Os -mthumb \
	-fmessage-length=0 -ffunction-sections -fdata-sections \
	-Wall -Wshadow -Wlogical-op -Wfloat-equal \
	-T application/SW4STM32/STM32H743ZI_Nucleo/STM32H743ZITx_FLASH.ld \
	-Xlinker \
	--gc-sections -Wl,-Map,"$(MAP)" \
	-specs=nano.specs

LIBRARIES = $(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/timers.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/queue.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/tasks.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/event_groups.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/croutine.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/list.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/stream_buffer.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS-Plus-CLI/FreeRTOS_CLI.c \
	$(LIB_DIR_H7XX)/Drivers/BSP/STM32H7xx_Nucleo_144/stm32h7xx_nucleo_144.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_dma_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i2c_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rcc.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_tim.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_pwr.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_pwr_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_rcc_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_adc.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_tim_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_uart_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_adc_ex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_gpio.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_cortex.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_uart.c \
	$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Src/stm32h7xx_hal_i2c.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/MemMang/heap_4.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM4_MPU/port.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/Common/mpu_wrappers.c \
	application/SW4STM32/startup_stm32h743xx.s

# $(LIB_DIR_H7XX)/SW4STM32/syscalls.c
