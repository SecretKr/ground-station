#include <Arduino.h>
#include <Wire.h>
#include "MPU9250.h"
#include <Adafruit_BMP280.h>
float aX,aY,aZ,gX,gY,gZ,vec,p,y,r;
Adafruit_BMP280 bmp;
#include "Adafruit_SHT31.h"
#include "commGPS.h"
#include <Servo.h>
#define UHFser Serial1
#define GPSser Serial3
String UHFout = "";

uint8_t poweron_gps_flag = 0;
float baseLat = 4315.00,baseLon = 11142.10;
struct commGD gpsData;
float baseBa;
float distance = 0,disbuf = 0,altbuf = 500;
int servoAngle = 0;
MPU9250 mpu;
Servo servo;

Adafruit_SHT31 sht31 = Adafruit_SHT31();
float data[40];
float axyz[3], gxyz[3], mxyz[3];

void setup() {
  Serial.begin(115200);
  UHFser.begin(115200);
  Serial.println("start");
  if (!sht31.begin(0x44)) {   // Set to 0x45 for alternate i2c addr
    Serial.println("Couldn't find SHT31");
  }
  
  if (!bmp.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor, check wiring!"));
  }
  else{
    bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating Mode. */
                  Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                  Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                  Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                  Adafruit_BMP280::STANDBY_MS_500);
  }
  baseBa = bmp.readPressure();  
  GPS_init();
  delay(200);
  mpu.setup();
  delay(300);//5000
  mpu.calibrateAccelGyro();
  
  servo.attach(6);
}

void loop() {
  servoCheck();
  data[0] = sht31.readTemperature();
  data[1] = sht31.readHumidity();
  data[2] = baseBa;
  data[3] = bmp.readPressure();
  data[4] = bmp.readAltitude(1019.66);

  unsigned long timeoutGps;
  double degLat,degLon,degBaseLat,degBaseLon;
  
  timeoutGps = millis();
  while(GPSser.available() && (millis() - timeoutGps < 100)){
    GPS_Parsing(&gpsData);
  }

  servoCheck();
  if ((gps_timeout_flag == 1)||(gps_timeout_flag ==3))
  {
    float gpsHight =gpsData.altitude;
    degBaseLat = DM2DD(baseLat);
    degBaseLon = DM2DD(baseLon);
    degLat = DM2DD(gpsData.latitude);
    degLon = DM2DD(gpsData.longitude);
    
    distance = CalGPSDistance(degBaseLat,degBaseLon,degLat,degLon);

    if(distance - disbuf > 100)
      distance = disbuf;
    else
      disbuf = distance;
    if(gpsData.altitude -altbuf > 1000)     
      gpsData.altitude = altbuf;
    else
      altbuf = gpsData.altitude;
  }
  else
  {
      if (gpsData.fix > 0)
      { 
        if (poweron_gps_flag == 0)
        {
          poweron_gps_flag = 1;
          baseLat = gpsData.latitude;
          baseLon = gpsData.longitude;
          baseBa = gpsData.altitude;
        }
        if ((gpsData.HDOP > 3) && (gpsData.HDOP < 7))
        {
          gps_timeout_flag = 3;
        }
        else if ((gpsData.HDOP > 0)&&(gpsData.HDOP <= 3))
        {
          gps_timeout_flag = 1;
        }
      }
  }
  data[5] = distance;
  data[6] = gpsData.latitude;
  data[7] = gpsData.longitude;
  data[8] = gpsData.altitude;
  data[9] = gpsData.sat;
  data[10] = gpsData.HDOP;
  data[11] = gpsData.fix;
  data[12] = gpsData.fixq;
  data[13] = gpsData.speed;
  data[14] = baseLat;
  data[15] = baseLon;
  data[16] = gpsData.hour;
  data[17] = gpsData.minu;
  data[18] = gpsData.sece;

  mpu.update();
  mpu.getRawData(axyz, gxyz, mxyz);
  
  float allAcc = sqrt( axyz[0] * axyz[0] + axyz[1] * axyz[1] + axyz[2] * axyz[2]);

  data[19] = axyz[0];
  data[20] = axyz[1];
  data[21] = axyz[2];
  data[22] = gxyz[0];
  data[23] = gxyz[1];
  data[24] = gxyz[2];
  data[25] = mxyz[0];
  data[26] = mxyz[1];
  data[27] = mxyz[2];
  data[28] = mpu.getPitch();
  data[29] = mpu.getRoll();
  data[30] = mpu.getYaw();
  data[31] = allAcc;
  servoCheck();

  UHFout = "0:"+(String)(data[0])+" 1:"+(String)(data[1]);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "2:"+(String)(data[2])+" 3:"+(String)(data[3])+" 4:"+(String)(data[4]);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "5:"+(String)(distance)+" 6:"+(String)(gpsData.latitude)+" 7:"+(String)(gpsData.longitude);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "8:"+(String)(gpsData.altitude)+" 9:"+(String)(gpsData.sat)+" 10:"+(String)(gpsData.HDOP);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "11:"+(String)(gpsData.fix)+" 12:"+(String)(gpsData.fixq);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "13:"+(String)(gpsData.speed)+" 14:"+(String)(baseLat)+" 15:"+(String)(baseLon);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "16:"+(String)(gpsData.hour)+" 17:"+(String)(gpsData.minu)+" 18:"+(String)(gpsData.sece);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "19:"+(String)(data[19])+" 20:"+(String)(data[20])+" 21:"+(String)(data[21])+" 31:"+(String)(0);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "22:"+(String)(data[22])+" 23:"+(String)(data[23])+" 24:"+(String)(data[24]);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "25:"+(String)(data[25])+" 26:"+(String)(data[26])+" 27:"+(String)(data[27]);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "28:"+(String)(data[28])+" 29:"+(String)(data[29])+" 30:"+(String)(data[30]);
  UHFser.println(UHFout); Serial.println(UHFout);
  UHFout = "32:"+(String)(0)+" 33:"+(String)(0)+" 34:"+(String)(0)+" 35:"+(String)(0);
  UHFser.println(UHFout); Serial.println(UHFout);
  
  //servo.write(0);
  //Serial.print("Temp *C = "); Serial.println(t);
  //Serial.print("Hum. % = "); Serial.println(h);
  
  servoCheck();
  delay(400);
  //servo.write(180);
  //delay(1000);
}

void servoCheck(){
  while(UHFser.available()){
    char s = UHFser.read();
    Serial.print(s);
    if(s == 'u') servoAngle+=90;
    if(s == 'd') servoAngle-=90;
    if(servoAngle > 180) servoAngle = 180;
    if(servoAngle < 0) servoAngle = 0;
    servo.write(servoAngle);
  }
  //Serial.println(servoAngle);
}
