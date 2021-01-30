/*
 * File: main.c
 *
 * Code generated for Simulink model :Test.
 *
 * Model version      : 1.0
 * Simulink Coder version    : 9.2 (R2019b) 18-Jul-2019
 * TLC version       : 9.2 (Aug 22 2019)
 * C/C++ source code generated on  : Tue Oct 22 12:30:45 2019
 *
 * Target selection: stm32.tlc
 * Embedded hardware selection: STM32CortexM
 * Code generation objectives:
 *    1. Execution efficiency
 *    2. RAM efficiency
 * Validation result: Not run
 *
 *
 *
 * ******************************************************************************
 * * attention
 * *
 * * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
 * * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
 * * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
 * * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
 * * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
 * * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
 * *
 * ******************************************************************************
 */

/* USER CODE BEGIN 0 */
#include <stdio.h>
#include "Test.h"                      /* Model's header file */
#include "rtwtypes.h"                  /* MathWorks types */

/* Real-time model */
extern RT_MODEL *const rt_M;

/* Set which subrates need to run this base step (base rate always runs).*/
/* Defined in Test.c file */
extern void Test_SetEventsForThisBaseStep(boolean_T*);

/* Flags for taskOverrun */
static boolean_T OverrunFlags[1];

/* Number of auto reload timer rotation computed */
static volatile uint32_t autoReloadTimerLoopVal_S = 1;

/* Remaining number of auto reload timer rotation to do */
volatile uint32_t remainAutoReloadTimerLoopVal_S = 1;

/* USER CODE END 0 */

/****************************************************
   main function
   Example of main :
   - Clock configuration
   - call Initialize
   - Wait for systick (infinite loop)
 *****************************************************/
int main (void)
{
  /* USER CODE BEGIN 1 */
  /* Data initialization */
  int_T i;

  /* USER CODE END 1 */

  /* USER CODE BEGIN 2 */
  /* Systick configuration and enable SysTickHandler interrupt */
  if (SysTick_Config((uint32_t)(SystemCoreClock / 1000.0))) {
    autoReloadTimerLoopVal_S = 1;
    do {
      autoReloadTimerLoopVal_S++;
    } while ((uint32_t)(SystemCoreClock / 1000.0)/autoReloadTimerLoopVal_S >
             SysTick_LOAD_RELOAD_Msk);

    SysTick_Config((uint32_t)(SystemCoreClock / 1000.0)/autoReloadTimerLoopVal_S);
  }

  /* Set number of loop to do. */
  remainAutoReloadTimerLoopVal_S = autoReloadTimerLoopVal_S;

  /* USER CODE END 2 */

  /* USER CODE BEGIN WHILE */
  for (i=0;i<1;i++) {
    OverrunFlags[i] = 0;
  }

  /* Model initialization call */
  Test_initialize();

  /* Infinite loop */
  /* Real time from systickHandler */
  while (1) {
    /*Process tasks every solver time*/
    if (remainAutoReloadTimerLoopVal_S == 0) {
      remainAutoReloadTimerLoopVal_S = autoReloadTimerLoopVal_S;

      /* Check base rate for overrun */
      if (OverrunFlags[0]) {
        rtmSetErrorStatus(Test_M, "Overrun");
      }

      OverrunFlags[0] = true;

      /* Step the model for base rate */
      Test_step();

      /* Get model outputs here */

      /* Indicate task for base rate complete */
      OverrunFlags[0] = false;
    }
  }

  /* USER CODE END WHILE */

  /* USER CODE BEGIN 3 */
  /* USER CODE END 3 */
}

/* File trailer for Real-Time Workshop generated code.
 *
 * [EOF] main.c
 */
