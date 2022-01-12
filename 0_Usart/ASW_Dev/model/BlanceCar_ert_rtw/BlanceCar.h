/*
 * File: BlanceCar.h
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

#ifndef RTW_HEADER_BlanceCar_h_
#define RTW_HEADER_BlanceCar_h_
#include <stddef.h>
#include <string.h>
#ifndef BlanceCar_COMMON_INCLUDES_
# define BlanceCar_COMMON_INCLUDES_
#include <string.h>
#include "rtwtypes.h"
#include "can_message.h"
#endif                                 /* BlanceCar_COMMON_INCLUDES_ */

#include "BlanceCar_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* user code (top of export header file) */
#include "can_message.h"

/* Block signals (default storage) */
typedef struct {
  real32_T UnitDelay2;                 /* '<S5>/Unit Delay2' */
  real32_T UnitDelay;                  /* '<S4>/Unit Delay' */
} B_BlanceCar_T;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  real32_T UnitDelay_DSTATE;           /* '<S2>/Unit Delay' */
  real32_T UnitDelay_DSTATE_c;         /* '<S8>/Unit Delay' */
  real32_T UnitDelay_DSTATE_d;         /* '<S1>/Unit Delay' */
  real32_T UnitDelay2_DSTATE;          /* '<S5>/Unit Delay2' */
  real32_T UnitDelay1_DSTATE;          /* '<S5>/Unit Delay1' */
  real32_T UnitDelay_DSTATE_f;         /* '<S4>/Unit Delay' */
  real32_T timer;                      /* '<Root>/Chart' */
  int_T CANPack_ModeSignalID;          /* '<Root>/CAN Pack' */
  boolean_T UnitDelay_DSTATE_b;        /* '<S7>/Unit Delay' */
  boolean_T UnitDelay_DSTATE_e;        /* '<Root>/Unit Delay' */
  boolean_T init_DSTATE;               /* '<S1>/init' */
  uint8_T is_c3_BlanceCar;             /* '<Root>/Chart' */
} DW_BlanceCar_T;

/* Constant parameters (default storage) */
typedef struct {
  /* Computed Parameter: Constant11_Value
   * Referenced by: '<Root>/Constant11'
   */
  real32_T Constant11_Value;
} ConstP_BlanceCar_T;

/* Real-time Model Data Structure */
struct tag_RTM_BlanceCar_T {
  const char_T * volatile errorStatus;
};

/* Block signals (default storage) */
extern B_BlanceCar_T BlanceCar_B;

/* Block states (default storage) */
extern DW_BlanceCar_T BlanceCar_DW;

/* Constant parameters (default storage) */
extern const ConstP_BlanceCar_T BlanceCar_ConstP;

/*
 * Exported Global Signals
 *
 * Note: Exported global signals are block signals with an exported global
 * storage class designation.  Code generation will declare the memory for
 * these signals and export their symbols.
 *
 */
extern CAN_DATATYPE MyCar_Msg;         /* '<Root>/CAN Pack' */

/* Model entry point functions */
extern void BlanceCar_initialize(void);
extern void BlanceCar_step(void);
extern void BlanceCar_terminate(void);

/* Exported data declaration */

/* Declaration for custom storage class: R_Global */
extern boolean_T vild_t_EncoderA;      /* Encoder A Input */
extern boolean_T vold_b_LED_flg;       /* LED Output */
extern real32_T vold_n_Couter;         /* Encoder A counter */

/* Real-time Model object */
extern RT_MODEL_BlanceCar_T *const BlanceCar_M;

/*-
 * These blocks were eliminated from the model due to optimizations:
 *
 * Block '<Root>/Constant12' : Unused code path elimination
 * Block '<Root>/Constant13' : Unused code path elimination
 * Block '<Root>/Constant2' : Unused code path elimination
 * Block '<Root>/Divide' : Unused code path elimination
 * Block '<Root>/Product' : Unused code path elimination
 * Block '<Root>/Product2' : Unused code path elimination
 * Block '<S1>/Data Type Conversion' : Eliminate redundant data type conversion
 * Block '<S1>/Data Type Conversion1' : Eliminate redundant data type conversion
 * Block '<S1>/Data Type Conversion2' : Eliminate redundant data type conversion
 * Block '<S1>/Data Type Conversion3' : Eliminate redundant data type conversion
 * Block '<S9>/Switch' : Eliminated due to constant selection input
 * Block '<S9>/Switch1' : Eliminated due to constant selection input
 * Block '<S5>/Signal Conversion' : Eliminate redundant signal conversion block
 * Block '<S10>/Switch' : Eliminated due to constant selection input
 * Block '<S10>/Switch1' : Eliminated due to constant selection input
 * Block '<Root>/Constant3' : Unused code path elimination
 * Block '<Root>/Constant4' : Unused code path elimination
 * Block '<Root>/Constant5' : Unused code path elimination
 * Block '<Root>/Constant7' : Unused code path elimination
 * Block '<Root>/Constant8' : Unused code path elimination
 * Block '<S8>/Constant' : Unused code path elimination
 * Block '<S8>/Data Type Conversion' : Unused code path elimination
 */

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'BlanceCar'
 * '<S1>'   : 'BlanceCar/1st Order Filter'
 * '<S2>'   : 'BlanceCar/Accumulator'
 * '<S3>'   : 'BlanceCar/Chart'
 * '<S4>'   : 'BlanceCar/Enabled Subsystem'
 * '<S5>'   : 'BlanceCar/Enabled Subsystem1'
 * '<S6>'   : 'BlanceCar/Enabled Subsystem2'
 * '<S7>'   : 'BlanceCar/Rising_Detect'
 * '<S8>'   : 'BlanceCar/Timer'
 * '<S9>'   : 'BlanceCar/Accumulator/Selector'
 * '<S10>'  : 'BlanceCar/Timer/Selector'
 */
#endif                                 /* RTW_HEADER_BlanceCar_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
