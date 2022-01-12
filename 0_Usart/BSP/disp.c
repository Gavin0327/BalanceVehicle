//
// Created by Gavin on 2021/12/26.
//
#include "disp.h"



void disp(float value)
{

    int tmp,tmp1,tmp2;
    tmp = (int)value;
    tmp1=(int)((value-tmp)*10)%10;
    tmp2=(int)((value-tmp)*100)%10;
//    tmp3=(int)((value-tmp)*1000)%10;
//    tmp4=(int)((value-tmp)*10000)%10;
//    tmp5=(int)((value-tmp)*100000)%10;
//    tmp6=(int)((value-tmp)*1000000)%10;
    printf("%d.%d%d",tmp,abs(tmp1),abs(tmp2));


}
void disp1(float a)
{
    char tmp[4]={0};
    int i;
    sprintf(tmp, "%f", a);
    for(i=0; i<4; i++)
        printf("%c", tmp[i]);
    printf("\n");
}