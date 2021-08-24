/**
  ******************************************************************************
  * @file    FreeRTOS/FreeRTOS_CLI/Src/main.cpp
  * @author  MCD Application Team  
  * @brief   Main Program file of the FreeRTOS CLI application.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2017 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
/* Scheduler includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

//#include "gpio_init.h"
//#include "uart_init.h"

#include "main.h"

#include "string.h"



/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/	
static void SystemClock_Config(void);
static void CPU_CACHE_Enable(void);

/* Private variables ---------------------------------------------------------*/

/*
 * Prototype for the two test tasks, which execute in User mode.
 * Amongst other things, Both tasks execute at the idle priority so will get 
 * preempted regularly. Each task repeatedly sends a
 * message on a queue to a 'check' task so the check task knows the test task 
 * is still executing and has not detected any errors.  If an error
 * is detected within the task the task is simply deleted so it no longer sends
 * messages.
 *
 * Both tasks obtain access to the queue handle in different ways; 
 * Test1Task() is created in Privileged mode and copies the queue handle to 
 * its local stack before setting itself to User mode, and Test2Task() receives 
 * the task handle using its parameter.
 */
static void BSP_Init(void);
static void vStrobeLED2Task( void *pvParameters );
static void vStrobeLED3Task( void *pvParameters );
static void vHelloWorldTask( void *pvParameters );


// Uart
UART_HandleTypeDef s_UARTHandle;

/* Private functions ---------------------------------------------------------*/
int main( void )
{ 
  /* Enable the CPU Cache */
  CPU_CACHE_Enable(); 
  
  /* STM32H7xx HAL library initialization:
       - TIM6 timer is configured by default as source of HAL time base, but user
         can eventually implement his proper time base source (another general purpose
         timer for application or other time source), keeping in mind that Time base
         duration should be kept 1ms since PPP_TIMEOUT_VALUEs are defined and
         handled in milliseconds basis.
         This application uses FreeRTOS, the RTOS initializes the systick to generate an interrupt each 1ms. 
         The systick is then used for FreeRTOS time base.  
       - Set NVIC Group Priority to 4
       - Low Level Initialization: global MSP (MCU Support Package) initialization
   */
  HAL_Init();
  
  /* Configure the system clock to 400 MHz */
  SystemClock_Config();	

  BSP_Init();

  /*  */
  // uart3_init();
  
  /* Create the task that starts the FreeRTOS Hello World Task. */
  xTaskCreate( vHelloWorldTask, "vHelloWorldTask", 100, NULL, 2 | portPRIVILEGE_BIT, NULL);

    /* Create the task that strobes LED3. */
  xTaskCreate( vStrobeLED2Task, "vStrobeLED2Task", 100, NULL, 3, NULL);
  xTaskCreate( vStrobeLED3Task, "vStrobeLED3Task", 100, NULL, 4, NULL);

  /* Create the task that starts the FreeRTOS Command Console. */
  // xTaskCreate( vCommandConsoleTask, "vCommandConsoleTask", 100,	NULL, 3, NULL );  
  
  /* Start the scheduler. */
  vTaskStartScheduler();
  
  /* Will only get here if there was insufficient memory to create the idle
  task. */
  for( ;; );
}
/*-----------------------------------------------------------*/

#define MAX_INPUT_LENGTH    50
#define MAX_OUTPUT_LENGTH   100

static void BSP_Init(void)
{
  BSP_LED_Init(LED1);
  BSP_LED_Init(LED2);
  BSP_LED_Init(LED3);

  /* GPIO Ports Clock Enable */
  __HAL_RCC_GPIOD_CLK_ENABLE();  
  
  s_UARTHandle.Instance = USART2;
  s_UARTHandle.Init.BaudRate = 9600;
  s_UARTHandle.Init.WordLength = UART_WORDLENGTH_8B;
  s_UARTHandle.Init.StopBits = UART_STOPBITS_1;
  s_UARTHandle.Init.Parity = UART_PARITY_NONE;
  s_UARTHandle.Init.Mode = UART_MODE_TX_RX;
  s_UARTHandle.Init.HwFlowCtl = UART_HWCONTROL_NONE;
  s_UARTHandle.Init.OverSampling = UART_OVERSAMPLING_16;
  s_UARTHandle.Init.OneBitSampling = UART_ONE_BIT_SAMPLE_DISABLE;
  //s_UARTHandle.Init.ClockPrescaler = UART_PRESCALER_DIV1;
  s_UARTHandle.AdvancedInit.AdvFeatureInit = UART_ADVFEATURE_NO_INIT;
  if(HAL_UART_Init(&s_UARTHandle) != HAL_OK)
  {
      // Error Handling with LED
      BSP_LED_Toggle(LED1);
  }
  if (HAL_UARTEx_SetTxFifoThreshold(&s_UARTHandle, UART_TXFIFO_THRESHOLD_1_8) != HAL_OK)
  {
      BSP_LED_Toggle(LED1);
  }
  if (HAL_UARTEx_SetRxFifoThreshold(&s_UARTHandle, UART_RXFIFO_THRESHOLD_1_8) != HAL_OK)
  {
      BSP_LED_Toggle(LED1);
  }
  if (HAL_UARTEx_DisableFifoMode(&s_UARTHandle) != HAL_OK)
  {
      BSP_LED_Toggle(LED1);
  }

}

static void vStrobeLED2Task( void *pvParameters )
{
    for(;;){
	BSP_LED_Toggle(LED2);
	vTaskDelay( 250 / portTICK_PERIOD_MS );
    }

}

static void vStrobeLED3Task( void *pvParameters )
{
    for(;;){
	BSP_LED_Toggle(LED3);
	vTaskDelay( 500 / portTICK_PERIOD_MS );
    }

}

static void vHelloWorldTask( void *pvParameters )
{
    char message[] = "hello world";
    for(;;) {
	if(HAL_UART_Transmit(&s_UARTHandle, (uint8_t*)message, strlen(message), 1000) != HAL_OK)
	    {
		BSP_LED_Toggle(LED1);
	    }
	vTaskDelay( 250 / portTICK_PERIOD_MS );
    }
}

/*-----------------------------------------------------------*/
/**
  * @brief  System Clock Configuration
  *         The system Clock is configured as follow : 
  *            System Clock source            = PLL (HSE BYPASS)
  *            SYSCLK(Hz)                     = 400000000 (CPU Clock)
  *            HCLK(Hz)                       = 200000000 (AXI and AHBs Clock)
  *            AHB Prescaler                  = 2
  *            D1 APB3 Prescaler              = 2 (APB3 Clock  100MHz)
  *            D2 APB1 Prescaler              = 2 (APB1 Clock  100MHz)
  *            D2 APB2 Prescaler              = 2 (APB2 Clock  100MHz)
  *            D3 APB4 Prescaler              = 2 (APB4 Clock  100MHz)
  *            HSE Frequency(Hz)              = 8000000
  *            PLL_M                          = 4
  *            PLL_N                          = 400
  *            PLL_P                          = 2
  *            PLL_Q                          = 4
  *            PLL_R                          = 2
  *            VDD(V)                         = 3.3
  *            Flash Latency(WS)              = 4
  * @param  None
  * @retval None
  */
static void SystemClock_Config(void)
{
  RCC_ClkInitTypeDef RCC_ClkInitStruct;
  RCC_OscInitTypeDef RCC_OscInitStruct;
  HAL_StatusTypeDef ret = HAL_OK;
  
  /*!< Supply configuration update enable */
  HAL_PWREx_ConfigSupply(PWR_LDO_SUPPLY);

  /* The voltage scaling allows optimizing the power consumption when the device is
     clocked below the maximum system frequency, to update the voltage scaling value
     regarding system frequency refer to product datasheet.  */
  __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

  while(!__HAL_PWR_GET_FLAG(PWR_FLAG_VOSRDY)) {}
  
  /* Enable HSE Oscillator and activate PLL with HSE as source */
  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
  RCC_OscInitStruct.HSEState = RCC_HSE_BYPASS;
  RCC_OscInitStruct.HSIState = RCC_HSI_OFF;
  RCC_OscInitStruct.CSIState = RCC_CSI_OFF;
  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;

  RCC_OscInitStruct.PLL.PLLM = 4;
  RCC_OscInitStruct.PLL.PLLN = 400;
  RCC_OscInitStruct.PLL.PLLFRACN = 0;
  RCC_OscInitStruct.PLL.PLLP = 2;
  RCC_OscInitStruct.PLL.PLLR = 2;
  RCC_OscInitStruct.PLL.PLLQ = 4;

  RCC_OscInitStruct.PLL.PLLVCOSEL = RCC_PLL1VCOWIDE;
  RCC_OscInitStruct.PLL.PLLRGE = RCC_PLL1VCIRANGE_2;
  ret = HAL_RCC_OscConfig(&RCC_OscInitStruct);
  if(ret != HAL_OK)
  {
    while(1);
  }
  
/* Select PLL as system clock source and configure  bus clocks dividers */
  RCC_ClkInitStruct.ClockType = (RCC_CLOCKTYPE_SYSCLK | RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_D1PCLK1 | RCC_CLOCKTYPE_PCLK1 | \
                                 RCC_CLOCKTYPE_PCLK2  | RCC_CLOCKTYPE_D3PCLK1);

  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.SYSCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_HCLK_DIV2;
  RCC_ClkInitStruct.APB3CLKDivider = RCC_APB3_DIV2;  
  RCC_ClkInitStruct.APB1CLKDivider = RCC_APB1_DIV2; 
  RCC_ClkInitStruct.APB2CLKDivider = RCC_APB2_DIV2; 
  RCC_ClkInitStruct.APB4CLKDivider = RCC_APB4_DIV2; 
  ret = HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_4);
  if(ret != HAL_OK)
  {
    while(1);
  }	
}



/**
* @brief  CPU L1-Cache enable.
* @param  None
* @retval None
*/
static void CPU_CACHE_Enable(void)
{
  /* Enable I-Cache */
  SCB_EnableICache();

  /* Enable D-Cache */
  SCB_EnableDCache();
} 

#ifdef  USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t *file, uint32_t line)
{
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
 

