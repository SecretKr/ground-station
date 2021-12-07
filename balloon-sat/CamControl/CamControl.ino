#include <SoftwareSerial.h>
#include <Servo.h>
Servo servo;
int servoAngle = 0;
SoftwareSerial mySerial(2, 3);

void setup() {
  Serial.begin(115200);
  mySerial.begin(115200);
  servo.attach(4);
}

void loop() {
  while(mySerial.available()){
    char s = mySerial.read();
    Serial.print(s);
    if(s == 'u') servoAngle+=45;
    if(s == 'd') servoAngle-=45;
    if(servoAngle > 180) servoAngle = 180;
    if(servoAngle < 0) servoAngle = 0;
    servo.write(servoAngle);
  }
}
