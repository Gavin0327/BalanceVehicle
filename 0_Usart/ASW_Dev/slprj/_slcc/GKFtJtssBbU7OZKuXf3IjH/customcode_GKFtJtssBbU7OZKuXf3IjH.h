#ifndef __customcode_GKFtJtssBbU7OZKuXf3IjH_h__
#define __customcode_GKFtJtssBbU7OZKuXf3IjH_h__

/* Include files */
#include "mex.h"
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "tmwtypes.h"


/* Helper definitions for DLL support */
#if defined _WIN32 
  #define DLL_EXPORT_CC __declspec(dllexport)
#else
  #if __GNUC__ >= 4
    #define DLL_EXPORT_CC __attribute__ ((visibility ("default")))
  #else
    #define DLL_EXPORT_CC
  #endif
#endif
/* Custom Code from Simulation Target dialog */
defined(STM32F103x6);

/* Function Declarations */
#ifdef __cplusplus
extern "C" {
#endif
#define customcode_GKFtJtssBbU7OZKuXf3IjH_initializer()

#define customcode_GKFtJtssBbU7OZKuXf3IjH_terminator()
#ifdef __cplusplus
}
#endif

#endif

