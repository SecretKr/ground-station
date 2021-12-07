#ifndef __COMMTF_H__
#define __COMMTF_H__

#include <Arduino.h>
#include <SPI.h>
#include <SD.h>

void tfInit();
void preFile(String *a);

void openFile();
void iwriteData(int a);
void iwriteDataLn(int a);

void writeData(float a);
void writeDataLn(float a);
void SwriteData(String a);
void SwriteDataLn(String a);
void closeFile();

#endif




/**************************
data

0:airT	1:airH	

2:baseP	3:pres	4:alti

5:distance	6:latitude	7:longitude	8:altitude	9:sat	10:HDOP

11:fix	12:fixq	13:gSpe	14:bLa	15:bLo	16:hour	17:min	18:sec	

19:AX	20:AY	21:AZ	22:GX	23:GY	24:GZ	25:MX	26:MY	27:MZ	28:PITCH	29:ROLL	30:YAW	31:G

32：batteryValtage	33：takeOffInfo

34：RTChour 35：RTCmin	36：RTCsec






0:气压温度	1:气压湿度	

2:基准气压	3:当前气压值	4:距离基准面气压高度

5:GPS地面距离	6:纬度	7:经度	8:海拔高度	9:星数sat	10:水平定位因子HDOP

11:定位	12:3D定位	13:地速	14:基准纬度	15:基准经度	16:UTC时间 小时	17:分钟	18:秒	

19:加速度X	20:加速度Y	21:加速度Z	22:角速度X	23:角速度Y	24:角速度Z	25:磁力X	26:磁力Y	27:磁力Z	28:俯仰角	29:横滚角	30:偏航角	31:全局加速度

32：电池电压	33：释放信息

34：UTC年 35：月	36：日









**************************/