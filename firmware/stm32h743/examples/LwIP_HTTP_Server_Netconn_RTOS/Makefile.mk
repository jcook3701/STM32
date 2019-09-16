# *************************************************************************************************** #
#               This build is specifically for STM32H743 LwIP_HTTP_Server_Netconn_RTOS.               #
# *************************************************************************************************** #

# Note: Below are old linker flags that Might be needed for another project.
#	-mfpu=fpv5-sp-d16
# 	-nostdlib
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
	-I"$(LIB_DIR_H7XX)/Drivers/BSP/Components/" \
	-I"$(LIB_DIR_H7XX)/Drivers/BSP/Components/lan8742" \
	-I"$(LIB_DIR_H7XX)/Drivers/BSP/Components/Common" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS/Device/ST/STM32H7xx/Include" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS/DSP/Include" \
	-I"$(LIB_DIR_H7XX)/Drivers/CMSIS/Include" \
	-I"$(LIB_DIR_H7XX)/Drivers/STM32H7xx_HAL_Driver/Inc" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/include" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM4F" \
	-I"$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/CMSIS_RTOS" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/api" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/apps" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/apps/httpd" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ipv4" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/lwip" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/lwip/apps" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/lwip/priv" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/lwip/prot" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/netif" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/netif/ppp" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/netif/ppp/polarssl" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/posix" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/src/include/posix/sys" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/system" \
	-I"$(LIB_DIR_H7XX)/Middlewares/LwIP/system/arch" \
	-I"$(LIB_DIR_H7XX)/Middlewares/mbedTLS" \
	-I"$(LIB_DIR_H7XX)/Utilities" \
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

LIBRARIES = $(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/MemMang/heap_4.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/CMSIS_RTOS/cmsis_os.c \
	$(LIB_DIR_H7XX)/Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM4F/port.c \
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
	$(LIB_DIR_H7XX)/Middlewares/LwIP/src/core/ip.c \
	application/SW4STM32/startup_stm32h743xx.s \
	application/SW4STM32/syscalls.c



