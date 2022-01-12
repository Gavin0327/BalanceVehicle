%% Data Bound Define
INT8_MAX=intmax('int8');
INT16_MAX=intmax('int16');
INT32_MAX=intmax('int32');
FLINT32_MAX=flintmax('single');

%% Units Convert
const_define('BAR_2_Pa', 1e5, 'single');
const_define('Pa_2_BAR', 1e-5, 'single');

const_define('DEG_2_RAD', pi/180, 'single');
const_define('RAD_2_DEG', 180/pi, 'single');

const_define('XX_2_kXX', 0.001, 'single');
const_define('kXX_2_XX', 1000, 'single');

const_define('KPH_2_MPS', 1/3.6, 'single');
const_define('MPS_2_KPH', 3.6, 'single');

const_define('KPH_2_KNOTS', 0.539956803, 'single');
const_define('KNOTS_2_KPH', 1/0.539956803, 'single');

const_define('M3_2_CC', 1e6, 'single');
const_define('CC_2_M3', 1e-6, 'single');

const_define('CCpREV_2_M3pRAD', 1e-6/(2*pi), 'single');
const_define('M3pRAD_2_CCpREV', 2*pi*1e6, 'single');

const_define('RPM_2_RADpS', pi/30, 'single');
const_define('RADpS_2_RPM', 30/pi, 'single');

const_define('NmRPM_2_KW',RPM_2_RADpS.Value * 1e-3,'single');

const_define('G_2_MPS2', 9.81, 'single');
const_define('MPS2_2_G', 1/9.81, 'single');