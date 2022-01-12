/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f1xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "retarget.h"
#include "bsp_delay.h"
#include "bsp_iic.h"
#include "math.h"
#include "stdlib.h"
#include "string.h"
#include "bsp_inv_mpu.h"
#include "bsp_inv_mpu_dmp_motion_driver.h"
#include "bsp_dmpKey.h"
#include "dsp_dmpmap.h"
#include "bsp_mpu6050.h"
#include "disp.h"
#include "dsp_filter.h"
//#include "BlanceCar.h"

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define EncoderA_A_Pin GPIO_PIN_0
#define EncoderA_A_GPIO_Port GPIOA
#define EncoderA_B_Pin GPIO_PIN_1
#define EncoderA_B_GPIO_Port GPIOA
#define Get_Voltage_Pin GPIO_PIN_4
#define Get_Voltage_GPIO_Port GPIOA
#define Motor_A_neg_Pin GPIO_PIN_12
#define Motor_A_neg_GPIO_Port GPIOB
#define Motor_A_pos_Pin GPIO_PIN_13
#define Motor_A_pos_GPIO_Port GPIOB
#define Motor_B_neg_Pin GPIO_PIN_14
#define Motor_B_neg_GPIO_Port GPIOB
#define Motor_B_pos_Pin GPIO_PIN_15
#define Motor_B_pos_GPIO_Port GPIOB
#define PWMB_Pin GPIO_PIN_8
#define PWMB_GPIO_Port GPIOA
#define PWMA_Pin GPIO_PIN_11
#define PWMA_GPIO_Port GPIOA
#define LED2_Pin GPIO_PIN_12
#define LED2_GPIO_Port GPIOA
#define S2_KEY_Pin GPIO_PIN_15
#define S2_KEY_GPIO_Port GPIOA
#define EncoderB_A_Pin GPIO_PIN_6
#define EncoderB_A_GPIO_Port GPIOB
#define EncoderB_B_Pin GPIO_PIN_7
#define EncoderB_B_GPIO_Port GPIOB
#define SCL_Pin GPIO_PIN_8
#define SCL_GPIO_Port GPIOB
#define SDA_Pin GPIO_PIN_9
#define SDA_GPIO_Port GPIOB
/* USER CODE BEGIN Private defines */
#define PI 3.14159265
#define ZHONGZHI 3
extern uint8_t Flag_Stop,Flag_Show,Way_Angle;
extern float Angle_Balance,Gyro_Balance,Gyro_Turn,Acceleration_Z;
extern float Balance_Kp,Balance_Kd,Velocity_Kp,Velocity_Ki;
extern int Moto1,Moto2;
//extern TIM_HandleTypeDef htim1;
/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
