#include "commRTC.h"
#include "Arduino.h"

#include <Wire.h>
#include "DS1307.h"

DS1307 clock;//define a object of DS1307 class


void RTCinit(){
    clock.begin();
  }

void adjTime(int y,int m,int d,int h,int mi,int s){
  clock.fillByYMD(y,m,d);
  clock.fillByHMS(h,mi,s);
//  clock.fillDayOfWeek(MON);//Saturday
  clock.setTime();//write time to the RTC chip
  }

void getTime(int * year,int * mon ,int * day ,int * hour ,int * min ,int * sec){
	
  clock.getTime();
  
	*year = clock.year+2000;	
	*mon = clock.month;	
	*day = clock.dayOfMonth;
	*hour = clock.hour;
	*min = clock.minute;
	*sec = clock.second;
}  
  
  
/*Function: Display time on the serial monitor*/
void printTime()
{
  clock.getTime();

  
  Serial.print(clock.year+2000, DEC);
  Serial.print("/");
  Serial.print(clock.month, DEC);
  Serial.print("/");
  Serial.print(clock.dayOfMonth, DEC);
  Serial.print("/");
  Serial.print(clock.hour, DEC);
  Serial.print(":");
  Serial.print(clock.minute, DEC);
  Serial.print(":");
  Serial.println(clock.second, DEC);

}