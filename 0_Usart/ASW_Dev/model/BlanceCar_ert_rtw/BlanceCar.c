/*
 * File: BlanceCar.c
 *
 * Code generated for Simulink model 'BlanceCar'.
 *
 * Model version                  : 1.15
 * Simulink Coder version         : 9.0 (R2018b) 24-May-2018
 * C/C++ source code generated on : Sun Dec  6 22:14:07 2020
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "BlanceCar.h"
#include "BlanceCar_private.h"

/* Named constants for Chart: '<Root>/Chart' */
#define BlanceCar_IN_LED_OFF           ((uint8_T)1U)
#define BlanceCar_IN_LED_ON            ((uint8_T)2U)

/* Exported block signals */
CAN_DATATYPE MyCar_Msg;                /* '<Root>/CAN Pack' */

/* Exported data definition */

/* Definition for custom storage class: R_Global */
boolean_T vild_t_EncoderA;             /* Encoder A Input */
boolean_T vold_b_LED_flg;              /* LED Output */
real32_T vold_n_Couter;                /* Encoder A counter */

/* Block signals (default storage) */
B_BlanceCar_T BlanceCar_B;

/* Block states (default storage) */
DW_BlanceCar_T BlanceCar_DW;

/* Real-time model */
RT_MODEL_BlanceCar_T BlanceCar_M_;
RT_MODEL_BlanceCar_T *const BlanceCar_M = &BlanceCar_M_;

/* Model step function */
void BlanceCar_step(void)
{
  int32_T superStepCount;
  boolean_T isStable;

  /* Sum: '<S2>/Sum' incorporates:
   *  Inport: '<Root>/vild_t_EncoderA'
   *  Logic: '<S7>/Logical Operator'
   *  Logic: '<S7>/Logical Operator1'
   *  UnitDelay: '<S2>/Unit Delay'
   *  UnitDelay: '<S7>/Unit Delay'
   */
  BlanceCar_DW.UnitDelay_DSTATE += (real32_T)(vild_t_EncoderA &&
    (!BlanceCar_DW.UnitDelay_DSTATE_b));

  /* Sum: '<S8>/Sum' incorporates:
   *  Constant: '<Root>/Constant9'
   *  UnitDelay: '<S8>/Unit Delay'
   */
  BlanceCar_DW.UnitDelay_DSTATE_c += 0.001F;

  /* Outputs for Enabled SubSystem: '<Root>/Enabled Subsystem' incorporates:
   *  EnablePort: '<S4>/Enable'
   */
  /* UnitDelay: '<Root>/Unit Delay' */
  if (BlanceCar_DW.UnitDelay_DSTATE_e) {
    /* UnitDelay: '<S4>/Unit Delay' */
    BlanceCar_B.UnitDelay = BlanceCar_DW.UnitDelay_DSTATE_f;

    /* Update for UnitDelay: '<S4>/Unit Delay' incorporates:
     *  UnitDelay: '<S8>/Unit Delay'
     */
    BlanceCar_DW.UnitDelay_DSTATE_f = BlanceCar_DW.UnitDelay_DSTATE_c;
  }

  /* End of UnitDelay: '<Root>/Unit Delay' */
  /* End of Outputs for SubSystem: '<Root>/Enabled Subsystem' */

  /* RelationalOperator: '<Root>/Relational Operator' incorporates:
   *  Constant: '<Root>/Constant10'
   *  Sum: '<Root>/Sum1'
   *  UnitDelay: '<S8>/Unit Delay'
   */
  BlanceCar_DW.UnitDelay_DSTATE_e = (BlanceCar_DW.UnitDelay_DSTATE_c -
    BlanceCar_B.UnitDelay >= 1.0F);

  /* Outputs for Enabled SubSystem: '<Root>/Enabled Subsystem1' incorporates:
   *  EnablePort: '<S5>/Enable'
   */
  if (BlanceCar_DW.UnitDelay_DSTATE_e) {
    /* UnitDelay: '<S5>/Unit Delay2' */
    BlanceCar_B.UnitDelay2 = BlanceCar_DW.UnitDelay2_DSTATE;

    /* UnitDelay: '<S5>/Unit Delay1' incorporates:
     *  UnitDelay: '<S5>/Unit Delay2'
     */
    BlanceCar_DW.UnitDelay2_DSTATE = BlanceCar_DW.UnitDelay1_DSTATE;

    /* Update for UnitDelay: '<S5>/Unit Delay1' incorporates:
     *  UnitDelay: '<S2>/Unit Delay'
     */
    BlanceCar_DW.UnitDelay1_DSTATE = BlanceCar_DW.UnitDelay_DSTATE;
  }

  /* End of Outputs for SubSystem: '<Root>/Enabled Subsystem1' */

  /* Switch: '<S1>/Switch' incorporates:
   *  Constant: '<S1>/Constant'
   *  Product: '<S1>/Product'
   *  Product: '<S1>/Product1'
   *  Sum: '<Root>/Sum2'
   *  Sum: '<S1>/Add'
   *  Sum: '<S1>/Add2'
   *  UnitDelay: '<S1>/Unit Delay'
   *  UnitDelay: '<S1>/init'
   *  UnitDelay: '<S2>/Unit Delay'
   */
  if (BlanceCar_DW.init_DSTATE) {
    BlanceCar_DW.UnitDelay_DSTATE_d = BlanceCar_DW.UnitDelay_DSTATE -
      BlanceCar_B.UnitDelay2;
  } else {
    BlanceCar_DW.UnitDelay_DSTATE_d = (BlanceCar_DW.UnitDelay_DSTATE -
      BlanceCar_B.UnitDelay2) * 0.833333373F + 0.166666657F *
      BlanceCar_DW.UnitDelay_DSTATE_d;
  }

  /* End of Switch: '<S1>/Switch' */

  /* Outputs for Enabled SubSystem: '<Root>/Enabled Subsystem2' incorporates:
   *  EnablePort: '<S6>/Enable'
   */
  if (BlanceCar_DW.UnitDelay_DSTATE_e) {
    /* SignalConversion: '<S6>/Signal Conversion' incorporates:
     *  UnitDelay: '<S1>/Unit Delay'
     */
    vold_n_Couter = BlanceCar_DW.UnitDelay_DSTATE_d;
  }

  /* End of Outputs for SubSystem: '<Root>/Enabled Subsystem2' */

  /* Chart: '<Root>/Chart' */
  superStepCount = 0;
  do {
    isStable = true;
    if (BlanceCar_DW.is_c3_BlanceCar == BlanceCar_IN_LED_OFF) {
      if (BlanceCar_DW.timer >= 0.5F) {
        isStable = false;
        BlanceCar_DW.is_c3_BlanceCar = BlanceCar_IN_LED_ON;
        vold_b_LED_flg = false;
        BlanceCar_DW.timer = 0.0F;
      } else {
        BlanceCar_DW.timer += 0.001F;
      }
    } else if (BlanceCar_DW.timer >= 0.5F) {
      isStable = false;
      BlanceCar_DW.is_c3_BlanceCar = BlanceCar_IN_LED_OFF;
      vold_b_LED_flg = true;
      BlanceCar_DW.timer = 0.0F;
    } else {
      BlanceCar_DW.timer += 0.001F;
    }

    superStepCount++;
  } while ((!isStable) && ((uint32_T)superStepCount <= 1000U));

  /* S-Function (scanpack): '<Root>/CAN Pack' incorporates:
   *  Constant: '<Root>/Constant11'
   */
  /* S-Function (scanpack): '<Root>/CAN Pack' */
  MyCar_Msg.ID = 50U;
  MyCar_Msg.Length = 8U;
  MyCar_Msg.Extended = 0U;
  MyCar_Msg.Remote = 0;
  MyCar_Msg.Data[0] = 0;
  MyCar_Msg.Data[1] = 0;
  MyCar_Msg.Data[2] = 0;
  MyCar_Msg.Data[3] = 0;
  MyCar_Msg.Data[4] = 0;
  MyCar_Msg.Data[5] = 0;
  MyCar_Msg.Data[6] = 0;
  MyCar_Msg.Data[7] = 0;

  {
    /* --------------- START Packing signal 0 ------------------
     *  startBit                = 0
     *  length                  = 8
     *  desiredSignalByteLayout = BIGENDIAN
     *  dataType                = SIGNED
     *  factor                  = 0.523
     *  offset                  = 0.0
     *  minimum                 = 0.0
     *  maximum                 = 0.0
     * -----------------------------------------------------------------------*/
    {
      real32_T outValue = 0;

      {
        real32_T result = 390.0F;

        /* no offset to apply */
        result = result * (1 / 0.523F);
        outValue = result;
      }

      {
        int8_T packedValue;
        int32_T scaledValue;
        if (outValue > 2147483647.0) {
          scaledValue = 2147483647;
        } else if (outValue < -2147483648.0) {
          scaledValue = -2147483647 - 1;
        } else {
          scaledValue = (int32_T) outValue;
        }

        if (scaledValue > (int32_T) (127)) {
          packedValue = 127;
        } else if (scaledValue < (int32_T)((-(127)-1))) {
          packedValue = (-(127)-1);
        } else {
          packedValue = (int8_T) (scaledValue);
        }

        {
          uint8_T* tempValuePtr = (uint8_T*)&packedValue;
          uint8_T tempValue = *tempValuePtr;

          {
            MyCar_Msg.Data[0] = MyCar_Msg.Data[0] | (uint8_T)(tempValue);
          }
        }
      }
    }
  }

  /* Update for UnitDelay: '<S7>/Unit Delay' incorporates:
   *  Inport: '<Root>/vild_t_EncoderA'
   */
  BlanceCar_DW.UnitDelay_DSTATE_b = vild_t_EncoderA;

  /* Update for UnitDelay: '<S1>/init' incorporates:
   *  Constant: '<S1>/Constant1'
   */
  BlanceCar_DW.init_DSTATE = false;
}

/* Model initialize function */
void BlanceCar_initialize(void)
{
  /* Registration code */

  /* initialize error status */
  rtmSetErrorStatus(BlanceCar_M, (NULL));

  /* block I/O */
  (void) memset(((void *) &BlanceCar_B), 0,
                sizeof(B_BlanceCar_T));

  /* exported global signals */
  MyCar_Msg = CAN_DATATYPE_GROUND;

  /* states (dwork) */
  (void) memset((void *)&BlanceCar_DW, 0,
                sizeof(DW_BlanceCar_T));

  /* InitializeConditions for UnitDelay: '<S1>/init' */
  BlanceCar_DW.init_DSTATE = true;

  /* SystemInitialize for Enabled SubSystem: '<Root>/Enabled Subsystem' */
  /* InitializeConditions for UnitDelay: '<S4>/Unit Delay' */
  BlanceCar_DW.UnitDelay_DSTATE_f = -1.0F;

  /* End of SystemInitialize for SubSystem: '<Root>/Enabled Subsystem' */

  /* Chart: '<Root>/Chart' */
  BlanceCar_DW.is_c3_BlanceCar = BlanceCar_IN_LED_ON;
  BlanceCar_DW.timer = 0.0F;
}

/* Model terminate function */
void BlanceCar_terminate(void)
{
  /* (no terminate code required) */
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
