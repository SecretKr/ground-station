#include <SparkFunMPU9250-DMP.h>
#include <Adafruit_BMP280.h>
MPU9250_DMP imu;
float aX,aY,aZ,gX,gY,gZ,vec;
Adafruit_BMP280 bmp;

bool bmpflag = 1;
float xcal = 0.07;
float ycal = 0.20;
float zcal = 0.11;

float gxcal = -4.68;
float gycal = -4.05;
float gzcal = 1.56;

void setup() {
  Serial.begin(115200);
  if (!bmp.begin()) {
    Serial.println(F("Could not find a valid BMP280 sensor, check wiring!"));
    bmpflag = 0;
  }
  else{
    bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,     /* Operating Mode. */
                  Adafruit_BMP280::SAMPLING_X2,     /* Temp. oversampling */
                  Adafruit_BMP280::SAMPLING_X16,    /* Pressure oversampling */
                  Adafruit_BMP280::FILTER_X16,      /* Filtering. */
                  Adafruit_BMP280::STANDBY_MS_500);
  }
  randomSeed(analogRead(0));

  imu.setSensors(INV_XYZ_GYRO | INV_XYZ_ACCEL | INV_XYZ_COMPASS);
  imu.setGyroFSR(2000);
  imu.setAccelFSR(2);
  imu.setLPF(20);
  imu.setSampleRate(40);
  imu.setCompassSampleRate(10);
}

String Sout;
int i = 0;

void loop() {
  while ( !imu.dataReady() );
  imu.update(UPDATE_ACCEL | UPDATE_GYRO | UPDATE_COMPASS);
  aX = imu.calcAccel(imu.ax)+xcal;
  aY = imu.calcAccel(imu.ay)+ycal;
  aZ = imu.calcAccel(imu.az)+zcal;
  gX = (imu.calcGyro(imu.gx)+gxcal)*0.07;
  gY = (imu.calcGyro(imu.gy)+gycal)*0.07;
  gZ = (imu.calcGyro(imu.gz)+gzcal)*0.07;
  float vec = sqrt( pow(aX,2) + pow(aY,2) + pow(aZ,2) );




  Sout = "0:TMP:"+(String)(bmp.readTemperature())+" 1:HUM:"+(String)(random(50,100));
  Serial.println(Sout);

  Sout = "2:bPRS:"+(String)(random(10))+" 3:PRS:"+(String)(bmp.readPressure()/100)+" 4:ALT:"+(String)(bmp.readAltitude(1019.66));
  Serial.println(Sout);

  Sout = "5:DIS:"+(String)(random(10))+" 6:LAT:"+(String)(random(10))+" 7:LON:"+(String)(random(10));
  Serial.println(Sout);
  Sout = "8:GALT:"+(String)(random(10))+" 9:NSAT:"+(String)(random(10))+" 10:HDOP:"+(String)(random(10));
  Serial.println(Sout);
  
  Sout = "11:fix:"+(String)(random(10))+" 12:fixq:"+(String)(random(10));
  Serial.println(Sout);
  Sout = "13:spd:"+(String)(random(10))+" 14:bLat:"+(String)(random(10))+" 15:bLon:"+(String)(random(10));
  Serial.println(Sout);
  Sout = "16:hour:"+(String)(16)+" 17:min:"+(String)(45)+" 18:sec:"+(String)(i++);
  Serial.println(Sout);
  Sout = "";
  Sout = "19:AX:"+(String)(aX)+" 20:AY:"+(String)(aY)+" 21:AZ:"+(String)(aZ)+" 31:ACC:"+(String)(vec);
  Serial.println(Sout);
  Sout = "22:GX:"+(String)(gX)+" 23:GY:"+(String)(gY)+" 24:GZ:"+(String)(gZ);
  Serial.println(Sout);
  Sout = "25:MX:"+(String)((float)random(-10,10)/10)+" 26:MY:"+(String)((float)random(-10,10)/10)+" 27:MZ:"+(String)((float)random(-10,10)/10);
  Serial.println(Sout);
  Sout = "28:PIT:"+(String)((float)random(-10,10)/10)+" 29:ROL:"+(String)((float)random(-10,10)/10)+" 30:YAW:"+(String)((float)random(-10,10)/10);
  Serial.println(Sout);

  Sout = "32:c5S:"+(String)(random(10))+" 33:bat:"+(String)(random(10))+" 34:bH:"+(String)(random(10))+" 35:gH:"+(String)(random(10));
  Serial.println(Sout);
  
  delay(1000-millis()%1000);
}
