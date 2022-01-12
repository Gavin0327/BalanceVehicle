/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * File Name          : freertos.c
  * Description        : Code for freertos applications
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "FreeRTOS.h"
#include "task.h"
#include "main.h"
#include "cmsis_os.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "gpio.h"
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */
TIM_HandleTypeDef htim1;
TIM_HandleTypeDef htim2;
TIM_HandleTypeDef htim4;
UART_HandleTypeDef huart1;
/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
#define MAX_RECV_LEN 1024
uint8_t msg_buff[1024];
uint8_t * msg = msg_buff;
static int flag = (int)0;

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */
float Get_Angle(void);
int balance(float Angle,float Gyro);
int velocity(int encoder_left,int encoder_right);
int Read_Encoder(uint8_t TIMX);
int myabs(int a);
void Set_Pwm(int moto1,int moto2);
/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN Variables */
float Accel_Y,Angle_Balance,Gyro_Balance,Gyro_Turn,Acceleration_Z,buff_ax,buff_ay,buff_az;
//Balance_Kp = (float)300;
//Balance_Kd = (float)1;
float Velocity_Kp=80,Velocity_Ki=0.4,angleX,Gyro_X,Gyo_Raw,Gyo_Rate_Raw,VehSpd_Left,VehSpd_Right;
int Moto1,Moto2;
int Balance_Pwm,Velocity_Pwm,Turn_Pwm;
uint32_t enc1,enc2;
uint8_t aRxBuffer[1];
//int Encoder_Left,Encoder_Right;
/* USER CODE END Variables */
osThreadId Task_50msHandle;
osThreadId Task_5msHandle;
osSemaphoreId myBinarySem01Handle;

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN FunctionPrototypes */

/* USER CODE END FunctionPrototypes */

void Task50ms(void const * argument);
void Task5ms(void const * argument);

void MX_FREERTOS_Init(void); /* (MISRA C 2004 rule 8.1) */

/* GetIdleTaskMemory prototype (linked to static allocation support) */
void vApplicationGetIdleTaskMemory( StaticTask_t **ppxIdleTaskTCBBuffer, StackType_t **ppxIdleTaskStackBuffer, uint32_t *pulIdleTaskStackSize );

/* USER CODE BEGIN GET_IDLE_TASK_MEMORY */
static StaticTask_t xIdleTaskTCBBuffer;
static StackType_t xIdleStack[configMINIMAL_STACK_SIZE];

void vApplicationGetIdleTaskMemory( StaticTask_t **ppxIdleTaskTCBBuffer, StackType_t **ppxIdleTaskStackBuffer, uint32_t *pulIdleTaskStackSize )
{
  *ppxIdleTaskTCBBuffer = &xIdleTaskTCBBuffer;
  *ppxIdleTaskStackBuffer = &xIdleStack[0];
  *pulIdleTaskStackSize = configMINIMAL_STACK_SIZE;
  /* place for user code */
}
/* USER CODE END GET_IDLE_TASK_MEMORY */

/**
  * @brief  FreeRTOS initialization
  * @param  None
  * @retval None
  */
void MX_FREERTOS_Init(void) {
  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* USER CODE BEGIN RTOS_MUTEX */
  /* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* Create the semaphores(s) */
  /* definition and creation of myBinarySem01 */
  osSemaphoreDef(myBinarySem01);
  myBinarySem01Handle = osSemaphoreCreate(osSemaphore(myBinarySem01), 1);

  /* USER CODE BEGIN RTOS_SEMAPHORES */
  /* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* USER CODE BEGIN RTOS_TIMERS */
  /* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* USER CODE BEGIN RTOS_QUEUES */
  /* add queues, ... */
  /* USER CODE END RTOS_QUEUES */

  /* Create the thread(s) */
  /* definition and creation of Task_50ms */
  osThreadDef(Task_50ms, Task50ms, osPriorityNormal, 0, 128);
  Task_50msHandle = osThreadCreate(osThread(Task_50ms), NULL);

  /* definition and creation of Task_5ms */
  osThreadDef(Task_5ms, Task5ms, osPriorityNormal, 0, 128);
  Task_5msHandle = osThreadCreate(osThread(Task_5ms), NULL);

  /* USER CODE BEGIN RTOS_THREADS */
  /* add threads, ... */
  /* USER CODE END RTOS_THREADS */

}

/* USER CODE BEGIN Header_Task50ms */
/**
  * @brief  Function implementing the Task_50ms thread.
  * @param  argument: Not used
  * @retval None
  */
/* USER CODE END Header_Task50ms */
void Task50ms(void const * argument)
{
  /* USER CODE BEGIN Task50ms */
  /* Infinite loop */
  for(;;)
  {
    osDelay(200);
////      HAL_UART_Receive_IT(&huart1, (uint8_t *)msg, 1); //开启第一次中断
//    HAL_GPIO_TogglePin(LED2_GPIO_Port,LED2_Pin);
//    printf("angleX:");
//        disp(Angle_Balance);
//    printf("  BalancePWM：");
//    disp(Balance_Pwm);
//      printf("  VelPWM：");
//      disp(Velocity_Pwm);
//    printf(" Moto1:");
//    disp(Moto1);
//    printf(" Encoder:");
//    disp(Encoder_Right);
//        printf("\n");
  }
  /* USER CODE END Task50ms */
}

/* USER CODE BEGIN Header_Task5ms */
/**
* @brief Function implementing the Task_5ms thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_Task5ms */
void Task5ms(void const * argument)
{
  /* USER CODE BEGIN Task5ms */
    uint32_t enc1_buff,enc2_buff;
  /* Infinite loop */
  for(;;)
  {
    osDelay(5);
      Get_Angle();
//
//
      Balance_Pwm =balance(angle,Gyro_Balance);
//
      VehSpd_Left = -Read_Encoder(2);
      VehSpd_Right = Read_Encoder(4);
      Velocity_Pwm=velocity(VehSpd_Left,VehSpd_Right);
      Moto1=Balance_Pwm+Velocity_Pwm;//Target_Voltage;//*(-0.65);
      Moto2=Balance_Pwm+Velocity_Pwm;//Target_Voltage;//*(-0.65);

      Set_Pwm(Moto1,Moto1);
      enc1 = (uint32_t)(__HAL_TIM_GET_COUNTER(&htim2));//获取定时器的值
      enc2 = (uint32_t)(__HAL_TIM_GET_COUNTER(&htim4));//获取定时器的值
  }
  /* USER CODE END Task5ms */
}

/* Private application code --------------------------------------------------*/
/* USER CODE BEGIN Application */
float Get_Angle(void) {
    float Accel_Y, Accel_X, Accel_Z, Gyro_Y, Gyro_Z,Accel_Y_Raw, Accel_X_Raw, Accel_Z_Raw,angleY,Gyro_X_Raw;
    Gyro_X_Raw = (I2C_ReadOneByte(devAddr, MPU6050_RA_GYRO_XOUT_H) << 8) +
                 I2C_ReadOneByte(devAddr, MPU6050_RA_GYRO_XOUT_L);    //读取X轴陀螺仪
    Gyro_Y = (I2C_ReadOneByte(devAddr, MPU6050_RA_GYRO_YOUT_H) << 8) +
             I2C_ReadOneByte(devAddr, MPU6050_RA_GYRO_YOUT_L);    //读取Y轴陀螺仪
    Gyro_Z = (I2C_ReadOneByte(devAddr, MPU6050_RA_GYRO_ZOUT_H) << 8) +
             I2C_ReadOneByte(devAddr, MPU6050_RA_GYRO_ZOUT_L);    //读取Z轴陀螺仪
    Accel_X_Raw = (I2C_ReadOneByte(devAddr, MPU6050_RA_ACCEL_XOUT_H) << 8) +
                  I2C_ReadOneByte(devAddr, MPU6050_RA_ACCEL_XOUT_L); //读取X轴加速度计
    Accel_Y_Raw = (I2C_ReadOneByte(devAddr, MPU6050_RA_ACCEL_YOUT_H) << 8) +
                  I2C_ReadOneByte(devAddr, MPU6050_RA_ACCEL_YOUT_L); //读取X轴加速度计
    Accel_Z_Raw = (I2C_ReadOneByte(devAddr, MPU6050_RA_ACCEL_ZOUT_H) << 8) +
                  I2C_ReadOneByte(devAddr, MPU6050_RA_ACCEL_ZOUT_L); //读取Z轴加速度计
    if (Gyro_X_Raw > 32768) Gyro_X_Raw -= 65536;                       //数据类型转换  也可通过short强制类型转换
    if (Gyro_Y > 32768) Gyro_Y -= 65536;                       //数据类型转换  也可通过short强制类型转换
    if (Gyro_Z > 32768) Gyro_Z -= 65536;                       //数据类型转换
    if (Accel_X_Raw > 32768) Accel_X_Raw -= 65536;                      //数据类型转换
    if (Accel_Y_Raw > 32768) Accel_Y_Raw -= 65536;                      //数据类型转换
    if (Accel_Z_Raw > 32768) Accel_Z_Raw -= 65536;                      //数据类型转换

//    Gyro_Balance = -Gyro_Y;                                  //更新平衡角速度
//    Accel_Y = atan2(Accel_X, Accel_Z) * 180 / PI;                 //计算倾角
//    Gyro_Y = Gyro_Y / 16.4;                                    //陀螺仪量程转换
//    Kalman_Filter(Accel_Y,-Gyro_Y);//卡尔曼滤波
    Accel_X = Accel_X_Raw/16384.0;
    Accel_Y = Accel_Y_Raw/16384.0;
    Accel_Z = Accel_Z_Raw/16384.0;
    Gyro_X = Gyro_X_Raw/16.4;
    Gyro_X = Gyro_X + 0.56;

    angleX = (atan(Accel_Y / sqrt(pow(Accel_X, 2) + pow(Accel_Z, 2))) * 180 / PI);
    angleY = (atan(-1 * Accel_X / sqrt(pow(Accel_Y, 2) + pow(Accel_Z, 2))) * 180 / PI) + 1.58; // AccErrorY ~(-1.58)     //陀螺仪量程转换
    Kalman_Filter(angleX,Gyro_X);//卡尔曼滤波
    Angle_Balance=angle;                                   //更新平衡倾角
    Gyro_Balance = Gyro_X;
    Gyro_Turn=Gyro_Z;                                      //更新转向角速度
    Acceleration_Z=Accel_Z;                                //===更新Z轴加速度计
}

int balance(float Angle,float Gyro)
{
    float Bias;
    int balance;
    Bias=Angle-0;       //===求出平衡的角度中值 和机械相关
    balance=14*Bias+Gyro*0.3;   //===计算平衡控制的电机PWM  PD控制   kp是P系数 kd是D系数 10 0.3 8 0.026
    return balance;
}

void Set_Pwm(int moto1,int moto2)
{
    if(moto1<0)
    {
        HAL_GPIO_WritePin(Motor_A_neg_GPIO_Port,Motor_A_neg_Pin,GPIO_PIN_RESET);
        HAL_GPIO_WritePin(Motor_A_pos_GPIO_Port,Motor_A_pos_Pin,GPIO_PIN_SET);
    }
    else
    {
        HAL_GPIO_WritePin(Motor_A_neg_GPIO_Port,Motor_A_neg_Pin,GPIO_PIN_SET);
        HAL_GPIO_WritePin(Motor_A_pos_GPIO_Port,Motor_A_pos_Pin,GPIO_PIN_RESET);
    }
            __HAL_TIM_SetCompare(&htim1, TIM_CHANNEL_4, myabs(moto1));
    if(moto2<0)
    {
        HAL_GPIO_WritePin(Motor_B_neg_GPIO_Port,Motor_B_neg_Pin,GPIO_PIN_SET);
        HAL_GPIO_WritePin(Motor_B_pos_GPIO_Port,Motor_B_pos_Pin,GPIO_PIN_RESET);
    }
    else
    {
        HAL_GPIO_WritePin(Motor_B_neg_GPIO_Port,Motor_B_neg_Pin,GPIO_PIN_RESET);
        HAL_GPIO_WritePin(Motor_B_pos_GPIO_Port,Motor_B_pos_Pin,GPIO_PIN_SET);
    }
            __HAL_TIM_SetCompare(&htim1, TIM_CHANNEL_1, myabs(moto2));
//    PWMA_Pin=myabs(moto1);


//    if(moto2<0)	{Motor_B_neg_Pin=0,			Motor_B_pos_Pin=1;}
//    else        {Motor_B_neg_Pin=1,			Motor_B_pos_Pin=0;}
//    PWMB_Pin=myabs(moto2);
}

int myabs(int a)
{
    int temp;
    if(a<0)  temp=(int)100 + a;
    else temp=(int)100 - a;
    return temp;
}
void HAL_UART_RxCpltCallback(UART_HandleTypeDef *UartHandle)
{
    uint8_t ret = HAL_OK;
    msg++;
    if( msg == msg_buff + MAX_RECV_LEN)
    {
        msg = msg_buff;
    }
    do
    {
        ret = HAL_UART_Receive_IT(UartHandle,(uint8_t *)msg,1);
    }while(ret != HAL_OK);

    if(*(msg-1) == '\n')   //接收以\n为结尾字符，则表示接收完成
    {
        flag  =(int)1;
    }
}

int velocity(int encoder_left,int encoder_right)
{
    static float Velocity,Encoder_Least,Encoder,Movement;
    static float Encoder_Integral,Target_Velocity;
    //=============速度PI控制器=======================//
    Encoder_Least =(encoder_left+encoder_right)-0;                    //===获取最新速度偏差==测量速度（左右编码器之和）-目标速度（此处为零）
    Encoder *= 0.8;		                                                //===一阶低通滤波器
    Encoder += Encoder_Least*0.2;	                                    //===一阶低通滤波器
    Encoder_Integral +=Encoder;                                       //===积分出位移 积分时间：10ms
//    Encoder_Integral=Encoder_Integral-Movement;                       //===接收遥控器数据，控制前进后退
    if(Encoder_Integral>10000)  	Encoder_Integral=10000;             //===积分限幅
    if(Encoder_Integral<-10000)	Encoder_Integral=-10000;              //===积分限幅
    Velocity=Encoder*1.2+Encoder_Integral*(1.2/200);                          //===速度控制 0.5 0.025
//    if(Turn_Off(Angle_Balance,Voltage)==1||Flag_Stop==1)   Encoder_Integral=0;      //===电机关闭后清除积分
    if(angle<-40||angle>40)   Encoder_Integral=0;
    return Velocity;
}
int Read_Encoder(uint8_t TIMX)
{
    int Encoder_TIM;
    switch(TIMX)
    {
        case 2:  Encoder_TIM= (short)__HAL_TIM_GET_COUNTER(&htim2);  __HAL_TIM_SET_COUNTER(&htim2,0);break;//TIM2 -> CNT=0;break;
//        case 3:  Encoder_TIM= (short)TIM3 -> CNT;  TIM3 -> CNT=0;break;
        case 4:  Encoder_TIM= (short)__HAL_TIM_GET_COUNTER(&htim4);   __HAL_TIM_SET_COUNTER(&htim4,0);break;;
        default:  Encoder_TIM=0;
    }
    return Encoder_TIM;
}


/* USER CODE END Application */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
