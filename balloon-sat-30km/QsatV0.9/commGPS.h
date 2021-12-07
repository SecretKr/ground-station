#ifndef _COMMGPS_H
#define _COMMGPS_H

#include <Adafruit_GPS.h>


#define ENBALE_UHF2 1

#define GPS_TIMEOUT_MIN (1) 
#define GPS_TIMEOUT (2*GPS_TIMEOUT_MIN)  

//#define GPS_TIMEOUT_MIN (15) 
//#define GPS_TIMEOUT (30*GPS_TIMEOUT_MIN)  //(30*GPS_TIMEOUT_MIN) 


extern uint16_t gps_timeout_cnt;
extern uint8_t gps_timeout_flag;

struct commGD{
		float  latitude;
		float  longitude;
		float  altitude;
		uint8_t fix;
		uint8_t fixq;
		
		
		float speed;
		float  HDOP = 100;
		uint8_t sat = 0;
		
		uint8_t minu = 0;
		uint8_t hour = 0;
		uint8_t sece = 0;
		
		uint8_t year = 0;
		uint8_t month = 0;
		uint8_t day = 0;
		
};
double DM2DD(double a);
void GPS_init();
//void location(struct commGD *commGPS);
void location(struct commGD *commGPS, uint8_t test_falg);//test_falg == 1测试模式,其它为工作模式
void GPS_Parsing(struct commGD *commGPS);

double rad(double d);
double CalGPSDistance(double lata, double lona, double latb, double lonb);//m


bool getLocal(struct commGD *commGPS);

#endif
