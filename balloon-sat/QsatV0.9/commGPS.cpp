#include "commGPS.h"

#include <Adafruit_GPS.h>

#define GPSSerial Serial3
#define debugSerial Serial1 

#if ENBALE_UHF2
#define debugSerial2 Serial2
#endif

Adafruit_GPS GPS(&GPSSerial);

#define GPSECHO false




 unsigned char  engga[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x00,0x00,0x01,0x00,0x00,0xFE,0x18 // 使能GGA  
};  
 unsigned char  disgga[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x00,0x00,0x00,0x00,0x00,0xFD,0x15 // 取消GGA  
};  
 unsigned char  engll[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x01,0x00,0x01,0x00,0x00,0xFF,0x1D // 使能GLL  
};  
 unsigned char  disgll[14]={  
0xB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x01,0x00,0x00,0x00,0x00,0xFE,0x1A // 取消GLL  
};  
 unsigned char  engsa[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x02,0x00,0x01,0x00,0x00,0x00,0x22 // 使能GSA  
};  
 unsigned char  disgsa[14]={  
0xB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x02,0x00,0x00,0x00,0x00,0xFF,0x1F // 取消GSA  
};  
 unsigned char  engsv[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x03,0x00,0x01,0x00,0x00,0x01,0x27 // 使能GSV  
};  
 unsigned char  disgsv[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x03,0x00,0x00,0x00,0x00,0x00,0x24 // 取消GSV  
};  
 unsigned char  enrmc[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x04,0x00,0x01,0x00,0x00,0x02,0x2C // 使能RMC  
};  
 unsigned char  disrmc[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x04,0x00,0x00,0x00,0x00,0x01,0x29 // 取消RMC   
};  
 unsigned char  envtg[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x05,0x00,0x01,0x00,0x00,0x03,0x31 // 使能VTG  
};  
 unsigned char  disvtg[14]={  
0xB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x05,0x00,0x00,0x00,0x00,0x02,0x2E // 取消VTG  
};  
 unsigned char  engrs[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x06,0x00,0x01,0x00,0x00,0x04,0x36 // 使能GRS  
};  
 unsigned char  disgrs[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x06,0x00,0x00,0x00,0x00,0x03,0x33 // 取消GRS  
};  
 unsigned char  engst[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x07,0x00,0x01,0x00,0x00,0x05,0x3B // 使能GST 
};  
 unsigned char  disgst[14]={  
0xB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x07,0x00,0x00,0x00,0x00,0x04,0x38 // 取消GST  
};  
 unsigned char  enzda[14]={  
0xB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x08,0x00,0x01,0x00,0x00,0x06,0x40 // 使能ZDA 
};  
 unsigned char  diszda[14]={  
0XB5,0x62,0x06,0x01,0x06,0x00,0xF0,0x08,0x00,0x00,0x00,0x00,0x05,0x3D // 取消ZDA  
};  
 unsigned char  setbud960[28]={
0xB5,0x62,0x06,0x00,0x14,0x00,0x01,0x00,0x00,0x00,0xD0,0x08,0x00,0x00,
0x80,0x25,0x00,0x00,0x07,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0xA2,0xB5 // 设置波特率为9600
};
 unsigned char  setbud192[28]={
0xB5,0x62,0x06,0x00,0x14,0x00,0x01,0x00,0x00,0x00,0xD0,0x08,0x00,0x00,
0x00,0x4B,0x00,0x00,0x07,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0x48,0x57 // 设置波特率为19200
};
 unsigned char  setbud576[28]={
0xB5,0x62,0x06,0x00,0x14,0x00,0x01,0x00,0x00,0x00,0xD0,0x08,0x00,0x00,
0x00,0xE1,0x00,0x00,0x07,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0xDE,0xC9 // 设置波特率为57600
};
 unsigned char  setbud115[28]={
0xB5,0x62,0x06,0x00,0x14,0x00,0x01,0x00,0x00,0x00,0xD0,0x08,0x00,0x00,
0x00,0xC2,0x01,0x00,0x07,0x00,0x03,0x00,0x00,0x00,0x00,0x00,0xC0,0x7E // 设置波特率为115200
};
 unsigned char  set10hz[14]={
0xB5,0x62,0x06,0x08,0x06,0x00,0x64,0x00,0x01,0x00,0x01,0x00,0x7A,0x12 // 设置输出频率为10Hz
};


uint32_t timer = millis();



void GPS_init(void) {
  GPSSerial.begin(9600);
  GPSSerial.write(disgsa, 14); //DIS GSA
  GPSSerial.write(disgsv, 14); //DIS GSV
  GPSSerial.write(disgll, 14); //DIS GLL
  GPSSerial.write(disvtg, 14); //DIS VTG
  GPSSerial.write(enrmc, 14);  // EN RMC
  GPSSerial.write(engga, 14);  // EN GGA
  GPSSerial.write(setbud960, 28);  // SET buad: 9600
  delay(1000);
  GPSSerial.begin(9600);
  // Ask for firmware version
  GPSSerial.println(PMTK_Q_RELEASE);
  
  timer = millis();
}


uint16_t gps_timeout_cnt = 0;
uint8_t gps_timeout_flag = 0;

bool getLocal(struct commGD *commGPS){
  char c = GPS.read();
  
  if (GPSECHO)
    if (c) Serial.print(c);

  if (GPS.newNMEAreceived()) {
    //debugSerial.println(GPS.lastNMEA());
    if (!GPS.parse(GPS.lastNMEA()))
      return 0; // we can fail to parse a sentence in which case we should just wait for another
  }
  
  
  // if millis() or timer wraps around, we'll just reset it
  if (timer > millis()) timer = millis();
     
  // approximately every 2 seconds or so, print out the current stats
  if (millis() - timer > 2000) {
    timer = millis(); // reset the timer

  gps_timeout_cnt++;
  if (gps_timeout_cnt > GPS_TIMEOUT)
  {
      gps_timeout_cnt = 0;
      
      gps_timeout_flag += 2;//超时  0还未超时  1定位成功精度还不够,从1退出达到高精度  2未定位超时 3定位成功精度不够超时
      return 0;
  }
  
  
  
	commGPS->sat = GPS.satellites;
	commGPS->fix = GPS.fix;
	commGPS->fixq = GPS.fixquality;
	commGPS->HDOP = GPS.HDOP;
	
      debugSerial.print("sat = ");
      debugSerial.print(commGPS->sat);
      debugSerial.print("\t");
      debugSerial.print("fix = ");
      debugSerial.print(commGPS->fix);
      debugSerial.print("\t");
      debugSerial.print("fixq = ");
      debugSerial.print(commGPS->fixq);
      debugSerial.print("\t");
      debugSerial.print("hdop = ");
      debugSerial.print(commGPS->HDOP);
      debugSerial.println("\t"); 
      
      #if ENBALE_UHF2
          debugSerial2.print("sat = ");
          debugSerial2.print(commGPS->sat);
          debugSerial2.print("\t");
          debugSerial2.print("fix = ");
          debugSerial2.print(commGPS->fix);
          debugSerial2.print("\t");
          debugSerial2.print("fixq = ");
          debugSerial2.print(commGPS->fixq);
          debugSerial2.print("\t");
          debugSerial2.print("hdop = ");
          debugSerial2.print(commGPS->HDOP);
          debugSerial2.println("\t");   
      #endif	
	
	
  if( commGPS->fix > 0 && commGPS->fixq > 0) {
	commGPS->latitude = GPS.latitude;
	commGPS->longitude = GPS.longitude;
	commGPS->altitude = GPS.altitude;
	commGPS->speed = GPS.speed;
	
	commGPS->hour = GPS.hour;
	commGPS->minu = GPS.minute;
	commGPS->sece = GPS.seconds;

	commGPS->year = GPS.year;
	commGPS->month = GPS.month;
	commGPS->day = GPS.day;
	

      gps_timeout_flag = 1;//定位成功 初始化为1 
      debugSerial.print("la = ");
      debugSerial.print(commGPS->latitude);
      debugSerial.print("\t");
      debugSerial.print("lo = ");
      debugSerial.print(commGPS->longitude);
      debugSerial.print("\t"); 
      debugSerial.print("al = ");
      debugSerial.print(commGPS->altitude);
      debugSerial.println("\t");
      debugSerial.print(commGPS->hour);
      debugSerial.print(":"); 	
      debugSerial.print(commGPS->minu);
      debugSerial.print(":"); 	
      debugSerial.println(commGPS->sece);	
      
      #if ENBALE_UHF2  
      debugSerial2.print("la = ");
      debugSerial2.print(commGPS->latitude);
      debugSerial2.print("\t");
      debugSerial2.print("lo = ");
      debugSerial2.print(commGPS->longitude);
      debugSerial2.print("\t"); 
      debugSerial2.print("al = ");
      debugSerial2.print(commGPS->altitude);
      debugSerial2.println("\t");
      debugSerial2.print(commGPS->hour);
      debugSerial2.print(":");   
      debugSerial2.print(commGPS->minu);
      debugSerial2.print(":");   
      debugSerial2.println(commGPS->sece); 
      #endif 
      return 1;
    }
  else{
      return 0;
    }
  }
  else
    return 0;
}



void location(struct commGD *commGPS, uint8_t test_falg){
	do {
     if (test_falg == 1)
     {
      break; 
     }
    
    while(getLocal(commGPS)==0)
    {
      if ((gps_timeout_flag == 2) || (gps_timeout_flag == 3))
      {
        break;  
      }
    }
    if ((gps_timeout_flag == 2) || (gps_timeout_flag == 3))
      {
        break;  
      }
	}while(commGPS->HDOP  > 3 || commGPS->HDOP <= 0);

}

double DM2DD(double a){
  return (int)a/100 + fmod(a,100)/60;
  }

void GPS_Parsing(struct commGD *test) {

  char c = GPS.read();
  
  if (GPSECHO)
    if (c) Serial.print(c);

  if (GPS.newNMEAreceived()) {
//    Serial.println(GPS.lastNMEA());
    if (!GPS.parse(GPS.lastNMEA()))
      return; // we can fail to parse a sentence in which case we should just wait for another
  }
  
  // if millis() or timer wraps around, we'll just reset it
  if (timer > millis()) timer = millis();

	
	 
  // approximately every 2 seconds or so, print out the current stats
  if (millis() - timer > 200) {
    timer = millis(); // reset the timer     
	test->sat = GPS.satellites;
	test->fix = GPS.fix;
	test->fixq = GPS.fixquality;
	test->HDOP = GPS.HDOP; 
    if( test->fix > 0 && test->fixq > 0) {
		if(test->HDOP < 7 && test->HDOP > 0){
			test->latitude = GPS.latitude;
			test->longitude = GPS.longitude;
			test->altitude = GPS.altitude;
			test->speed = GPS.speed;
			test->hour = GPS.hour;
			test->minu = GPS.minute;
			test->sece = GPS.seconds;	
			test->year = GPS.year;
			test->month = GPS.month;
			test->day = GPS.day;

		}
    }
  }
}


 double rad(double d) {
    return d * PI / 180.0;
 }
  double CalGPSDistance(double lat1, double lng1, double lat2, double lng2) {
    double radLat1 = rad(lat1);
    double radLat2 = rad(lat2);
    double a = radLat1 - radLat2;
    double b = rad(lng1) - rad(lng2);
    double s = 2 * asin(sqrt(pow(sin(a/2),2) +
     cos(radLat1)*cos(radLat2)*pow(sin(b/2),2)));
    s = s * 6371393;
    return s;
 } 
