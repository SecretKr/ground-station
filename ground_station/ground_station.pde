import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*; // http://www.sojamo.de/libraries/controlP5/
import processing.serial.*;

/* SETTINGS BEGIN */

int hTime = 100;
boolean isMac = false;

float gyroMax = 6;
float gyroMin = -6;
float accMax = 1.2;
float accMin = -1.2;
float oriMax = 10;
float oriMin = -10;
float locMax = 5;
float locMin = -5;
float altMax = 1.2;
float altMin = -1.2;
float vvMax = 1;
float vvMin = -1;
float tmpMax = 32;
float tmpMin = 24;

color[] graphColors = new color[10];

// Serial port to connect to
String serial_port = null;

Serial serialPort;
ControlP5 cp5;
DropdownList serialPortsList;
final int BAUD_RATE = 115200;

// graphs
Graph gyroGraph = new Graph(65,45,310,150,color(200,200,200)); // x+65 y+45 -80 -80
Graph accGraph = new Graph(465,45,310,150,color(200));
Graph oriGraph = new Graph(865,45,310,150,color(200));
Graph locGraph = new Graph(1265,45,150,150,color(200));
Graph altGraph = new Graph(465,285,310,150,color(200));
Graph vvGraph = new Graph(865,285,310,150,color(200));
Graph tmpGraph = new Graph(65,525,310,150,color(200));

float[][] gyroGraphValues = new float[3][hTime];
float[][] accGraphValues = new float[3][hTime];
float[][] oriGraphValues = new float[3][hTime];
float[] altGraphValues = new float[hTime];
float[] vvGraphValues = new float[hTime];
float[] tmpGraphValues = new float[hTime];
float[] data = new float[40];
float[] sampleTime = new float[hTime];
//float[] gyroTime = new float[20];

void setup() {
  graphColors[0] = color(214, 86, 103);
  graphColors[1] = color(255, 255, 102);
  graphColors[2] = color(56, 172, 255);
  graphColors[3] = color(56, 172, 255);
  
  surface.setTitle("GroundSatation");
  size(1440, 810);
  if(isMac) pixelDensity(2); // enable for macos
  //fullScreen();
  // gui
  String[] portNames = Serial.list();
  cp5 = new ControlP5(this);
  background(20);
  
  // serial port
  if(isMac) cp5.setFont(createFont("Arial",10));
  else cp5.setFont(createFont("Arial",20));
  serialPortsList = cp5.addDropdownList("serial ports").setPosition(805, 485).setWidth(390);
  serialPortsList.setBackgroundColor(color(20)).setColorBackground(color(40)).setItemHeight(30).setBarHeight(30).setColorActive(color(255));
  serialPortsList.getCaptionLabel().getStyle().setPadding(6,6,6,6);
  for(int i = 0 ; i < portNames.length; i++) serialPortsList.addItem(portNames[i], i);
  
  // button
  cp5.addButton("UP")
     .setPosition(420,500)
     .setSize(90,90)
     .setColorBackground(color(40));
  cp5.addButton("DOWN")
     .setPosition(420,610)
     .setSize(90,90)
     .setColorBackground(color(40));
  cp5.addButton("TEST")
     .setPosition(530,500)
     .setSize(90,90)
     .setColorBackground(color(40));
     
  graphSetting();
  
  gyroGraph.DrawAxis();
  accGraph.DrawAxis();
  vvGraph.DrawAxis();
  altGraph.DrawAxis();
  oriGraph.DrawAxis();
  tmpGraph.DrawAxis();
  locGraph.DrawAxis();
  drawRt(1205,245,230,470);
  drawLt(5,245,390,230);
  
  for (int i = 0;i < 35;i++) data[i] = 0;
  for (int i = 0;i < hTime;i++) sampleTime[i] = i-hTime+1;
}

void draw() {
  /* Read serial and update values */
  if (serialPort != null){
    while (serialPort.available() > 0) {
      String myString = "";
      try {
        myString = serialPort.readStringUntil('\n');
      }
      catch (Exception e) {}
      //print(myString);
      boolean writeGraph = false;
      if(myString != null){
        String[] pack = split(myString, ' ');
        for(int i = 0;i < pack.length;i++){
          try {data[int(split(pack[i], ':')[0])] = float(split(pack[i], ':')[2]);}
          catch (Exception e) {}
          try { if( int(split(pack[i], ':')[0]) == 35) writeGraph = true; }
          catch (Exception e) {}
        }
      }
      
      if(writeGraph){
        // gyro graph
        float min,max;
        /*for(int k = 0;k < gyroGraphValues[0].length - 1;k++){
          gyroGraphValues[0][k] = gyroGraphValues[0][k+1];
          //gyroTime[k] = gyroTime[k+1];
          //if(gyroTime[k] == -1) gyroTime[k] = int(data[18]+data[17]*60+data[16]*3600)-gyroGraphValues[0].length+k;
          if(gyroGraphValues[0][k] > max) max = gyroGraphValues[0][k];
        }
        gyroGraphValues[0][gyroGraphValues[0].length-1] = data[22];
        //gyroTime[gyroGraphValues[0].length-1] = int(data[18]+data[17]*60+data[16]*3600);
        if(max > 0.5) gyroGraph.yMax = max;
        else gyroGraph.yMax = 0.5;*/
        
        // gyro
        min = max = gyroGraphValues[0][0];
        for(int i = 0;i < 3;i++){
          for(int k = 0;k < gyroGraphValues[0].length - 1;k++){
            gyroGraphValues[i][k] = gyroGraphValues[i][k+1];
            if(gyroGraphValues[i][k] > max) max = gyroGraphValues[i][k];
            if(gyroGraphValues[i][k] < min) min = gyroGraphValues[i][k];
          }
          gyroGraphValues[i][gyroGraphValues[0].length-1] = data[i+22];
          if(gyroGraphValues[i][gyroGraphValues[0].length-1] > max) max = gyroGraphValues[i][gyroGraphValues[0].length-1];
          if(gyroGraphValues[i][gyroGraphValues[0].length-1] < min) min = gyroGraphValues[i][gyroGraphValues[0].length-1];
        }
        if(max > gyroMax-1) gyroGraph.yMax = max+2;
        else gyroGraph.yMax = gyroMax;
        if(min < gyroMin+1) gyroGraph.yMin = min-2;
        else gyroGraph.yMin = gyroMin;
        
        // acc
        min = max = accGraphValues[0][0];
        for(int i = 0;i < 3;i++){
          for(int k = 0;k < accGraphValues[0].length - 1;k++){
            accGraphValues[i][k] = accGraphValues[i][k+1];
            if(accGraphValues[i][k] > max) max = accGraphValues[i][k];
            if(accGraphValues[i][k] < min) min = accGraphValues[i][k];
          }
          accGraphValues[i][accGraphValues[0].length-1] = data[i+19];
          if(accGraphValues[i][accGraphValues[0].length-1] > max) max = accGraphValues[i][accGraphValues[0].length-1];
          if(accGraphValues[i][accGraphValues[0].length-1] < min) min = accGraphValues[i][accGraphValues[0].length-1];
        }
        if(max > accMax-0.2) accGraph.yMax = max+0.4;
        else accGraph.yMax = accMax;
        if(min < accMin+0.2) accGraph.yMin = min-0.4;
        else accGraph.yMin = accMin;
        
        // ori
        min = max = oriGraphValues[0][0];
        for(int i = 0;i < 3;i++){
          for(int k = 0;k < oriGraphValues[0].length - 1;k++){
            oriGraphValues[i][k] = oriGraphValues[i][k+1];
            if(oriGraphValues[i][k] > max) max = oriGraphValues[i][k];
            if(oriGraphValues[i][k] < min) min = oriGraphValues[i][k];
          }
          oriGraphValues[i][oriGraphValues[0].length-1] = data[i+28];
          if(oriGraphValues[i][oriGraphValues[0].length-1] > max) max = oriGraphValues[i][oriGraphValues[0].length-1];
          if(oriGraphValues[i][oriGraphValues[0].length-1] < min) min = oriGraphValues[i][oriGraphValues[0].length-1];
        }
        if(max > oriMax-1) oriGraph.yMax = max+2;
        else oriGraph.yMax = oriMax;
        if(min < oriMin+1) oriGraph.yMin = min-2;
        else oriGraph.yMin = oriMin;
        
        // alt
        min = max = altGraphValues[0];
        for(int k = 0;k < altGraphValues.length - 1;k++){
          altGraphValues[k] = altGraphValues[k+1];
          if(altGraphValues[k] > max) max = altGraphValues[k];
          if(altGraphValues[k] < min) min = altGraphValues[k];
        }
        altGraphValues[altGraphValues.length-1] = data[4];
        if(altGraphValues[altGraphValues.length-1] > max) max = altGraphValues[altGraphValues.length-1];
        if(altGraphValues[altGraphValues.length-1] < min) min = altGraphValues[altGraphValues.length-1];
        if(max > altMax-1) altGraph.yMax = max+2;
        else altGraph.yMax = altMax;
        if(min < altMin+1) altGraph.yMin = min-2;
        else altGraph.yMin = altMin;
        
        // vv
        min = max = vvGraphValues[13];
        for(int k = 0;k < vvGraphValues.length - 1;k++){
          vvGraphValues[k] = vvGraphValues[k+1];
          if(vvGraphValues[k] > max) max = vvGraphValues[k];
          if(vvGraphValues[k] < min) min = vvGraphValues[k];
        }
        vvGraphValues[vvGraphValues.length-1] = data[13];
        if(vvGraphValues[vvGraphValues.length-1] > max) max = vvGraphValues[vvGraphValues.length-1];
        if(vvGraphValues[vvGraphValues.length-1] < min) min = vvGraphValues[vvGraphValues.length-1];
        if(max > vvMax-1) vvGraph.yMax = max+2;
        else vvGraph.yMax = vvMax;
        if(min < vvMin+1) vvGraph.yMin = min-2;
        else vvGraph.yMin = vvMin;
        
        // tmp
        min = max = tmpGraphValues[0];
        for(int k = 0;k < tmpGraphValues.length - 1;k++){
          tmpGraphValues[k] = tmpGraphValues[k+1];
          if(tmpGraphValues[k] > max) max = tmpGraphValues[k];
          if(tmpGraphValues[k] < min) min = tmpGraphValues[k];
        }
        tmpGraphValues[tmpGraphValues.length-1] = data[0];
        if(tmpGraphValues[tmpGraphValues.length-1] > max) max = tmpGraphValues[tmpGraphValues.length-1];
        if(tmpGraphValues[tmpGraphValues.length-1] < min) min = tmpGraphValues[tmpGraphValues.length-1];
        if(max > tmpMax-1) tmpGraph.yMax = max+2;
        else tmpGraph.yMax = tmpMax;
        if(min < tmpMin+1) tmpGraph.yMin = min-2;
        else tmpGraph.yMin = tmpMin;
      }
      
      
    }
    // draw graph
    background(20);
    gyroGraph.DrawAxis();
    accGraph.DrawAxis();
    vvGraph.DrawAxis();
    altGraph.DrawAxis();
    oriGraph.DrawAxis();
    tmpGraph.DrawAxis();
    locGraph.DrawAxis();
    drawRt(1205,245,230,470);
    drawLt(5,245,390,230);
    gyroGraph.smoothLine(sampleTime, gyroGraphValues[0],graphColors[0]);
    gyroGraph.smoothLine(sampleTime, gyroGraphValues[1],graphColors[1]);
    gyroGraph.smoothLine(sampleTime, gyroGraphValues[2],graphColors[2]);
    accGraph.smoothLine(sampleTime, accGraphValues[0],graphColors[0]);
    accGraph.smoothLine(sampleTime, accGraphValues[1],graphColors[1]);
    accGraph.smoothLine(sampleTime, accGraphValues[2],graphColors[2]);
    oriGraph.smoothLine(sampleTime, oriGraphValues[0],graphColors[0]);
    oriGraph.smoothLine(sampleTime, oriGraphValues[1],graphColors[1]);
    oriGraph.smoothLine(sampleTime, oriGraphValues[2],graphColors[2]);
    altGraph.smoothLine(sampleTime, altGraphValues,graphColors[1]);
    vvGraph.smoothLine(sampleTime, vvGraphValues,graphColors[1]);
    tmpGraph.smoothLine(sampleTime, tmpGraphValues,graphColors[1]);
  }
  
}

void graphSetting(){
  // graph build
  for (int i=0; i<gyroGraphValues.length; i++) {
    for (int k=0; k<gyroGraphValues[0].length; k++) {
      gyroGraphValues[i][k] = 0;
    }
  }
  gyroGraph.xLabel="Packet";
  gyroGraph.yLabel="deg/s";
  gyroGraph.Title="Gyroscopes";
  gyroGraph.xDiv=5;
  gyroGraph.yDiv=6;
  gyroGraph.xMax=0;
  gyroGraph.xMin=-hTime;
  gyroGraph.yMax=gyroMax;
  gyroGraph.yMin=gyroMin;
  
  accGraph.xLabel="Packet";
  accGraph.yLabel="g-force";
  accGraph.Title="Accelerometers";
  accGraph.xDiv=5;
  accGraph.yDiv=6;
  accGraph.xMax=0;
  accGraph.xMin=-hTime;
  accGraph.yMax=accMax;
  accGraph.yMin=accMin;
  
  vvGraph.xLabel="Packet";
  vvGraph.yLabel="m/s";
  vvGraph.Title="Velocity";
  vvGraph.xDiv=5;
  vvGraph.yDiv=6;
  vvGraph.xMax=0;
  vvGraph.xMin=-hTime;
  vvGraph.yMax=vvMax;
  vvGraph.yMin=vvMin;
  
  altGraph.xLabel="Packet";
  altGraph.yLabel="meters";
  altGraph.Title="Altitude";
  altGraph.xDiv=5;
  altGraph.yDiv=6;
  altGraph.xMax=0;
  altGraph.xMin=-hTime;
  altGraph.yMax=altMax;
  altGraph.yMin=altMin;
  
  oriGraph.xLabel="Packet";
  oriGraph.yLabel="degrees";
  oriGraph.Title="Orientation";
  oriGraph.xDiv=5;
  oriGraph.yDiv=6;
  oriGraph.xMax=0;
  oriGraph.xMin=-hTime;
  oriGraph.yMax=oriMax;
  oriGraph.yMin=oriMin;
  
  tmpGraph.xLabel="Packet";
  tmpGraph.yLabel="Celcius";
  tmpGraph.Title="Temperature";
  tmpGraph.xDiv=5;
  tmpGraph.yDiv=6;
  tmpGraph.xMax=0;
  tmpGraph.xMin=-hTime;
  tmpGraph.yMax=tmpMax;
  tmpGraph.yMin=tmpMin;
  
  locGraph.xLabel="meters";
  locGraph.yLabel="meters";
  locGraph.Title="Position";
  locGraph.xDiv=5;
  locGraph.yDiv=5;
  locGraph.xMax=5;
  locGraph.xMin=-5;
  locGraph.yMax=5;
  locGraph.yMin=-5;
}

void drawRt(int x, int y, int w, int h){
  fill(color(45)); color(255);stroke(color(255));strokeWeight(1.5);
  rect(x,y,w,h,10);
  
  textAlign(CENTER); textSize(18);
  fill(255); color(255); stroke(color(255));strokeWeight(1.5);
  text("Raw Telemetry" ,x+w/2,y+20);                            // Heading Title

  textAlign(LEFT); textSize(15);
  int X = x+10;
  int Y = y+24;
  int S = 24;
  text("TMP:",X,Y+=S); text("HUM:",X,Y+=S); text("bPRS:",X,Y+=S); 
  text("PRS:",X,Y+=S); text("ALT:",X,Y+=S); text("DIS:",X,Y+=S);
  text("LAT:",X,Y+=S); text("LON:",X,Y+=S); text("GALT:",X,Y+=S);
  text("NSAT:",X,Y+=S); text("HDOP:",X,Y+=S); text("fix:",X,Y+=S);
  text("fixq:",X,Y+=S); text("spd:",X,Y+=S); text("bLat:",X,Y+=S);
  text("bLon:",X,Y+=S); text("hour:",X,Y+=S); text("min:",X,Y+=S);
  X = x+w/2+10; Y = y+24;
  text("sec:",X,Y+=S); text("AX:",X,Y+=S); text("AY:",X,Y+=S);
  text("AZ:",X,Y+=S); text("GX:",X,Y+=S); text("GY:",X,Y+=S);
  text("GZ:",X,Y+=S); text("MX:",X,Y+=S); text("MY:",X,Y+=S);
  text("MZ:",X,Y+=S); text("PIT:",X,Y+=S); text("ROL:",X,Y+=S);
  text("YAW:",X,Y+=S); text("ACC:",X,Y+=S); text("c5S:",X,Y+=S);
  text("bat:",X,Y+=S); text("bH:",X,Y+=S); text("gH::",X,Y+=S);
  X = x+60; Y = y+24;
  for(int i = 0;i < 18;i++){
    text(str(data[i]),X,Y+=S);
  }
  X = x+w/2+50; Y = y+24;
  for(int i = 18;i < 36;i++){
    text(str(data[i]),X,Y+=S);
  }
}

void drawLt(int x, int y, int w, int h){
  fill(color(45)); color(255);stroke(color(255));strokeWeight(1.5);
  rect(x,y,w,h,10);
  
  fill(255); color(255); stroke(color(255));strokeWeight(1.5);
  textAlign(LEFT); textSize(16);
  int X = x+20;
  int Y = y+20;
  int S = 34;
  text("Temp:",X,Y+=S); text("Battery:",X,Y+=S);
  text("Hour:",X,Y+=S); text("Minute:",X,Y+=S);
  text("Second:",X,Y+=S);
  X = x+w/2; Y = y+20;
  text("Humidity:",X,Y+=S); text("Latitude:",X,Y+=S);
  text("Longitude:",X,Y+=S); text("GPS Sats:",X,Y+=S);
  text("Pressure:",X,Y+=S);
  
  X = x+80; Y = y+20;
  text(str(data[0]),X,Y+=S); text(str(data[33]),X,Y+=S);
  text(str(data[16]),X,Y+=S); text(str(data[17]),X,Y+=S);
  text(str(data[18]),X,Y+=S);
  X = x+w/2+80; Y = y+20;
  text(str(data[1]),X,Y+=S); text(str(data[6]),X,Y+=S);
  text(str(data[7]),X,Y+=S); text(str(data[9]),X,Y+=S);
  text(str(data[3]),X,Y+=S);
}

public void UP(int theValue){
  if(serialPort != null) serialPort.write("u");
}

public void DOWN(int theValue){
  if(serialPort != null) serialPort.write("d");
}

public void TEST(int theValue){
  if(serialPort != null) serialPort.write("t");
}

void controlEvent(ControlEvent theEvent) {
  if (theEvent.getName() == "serial ports") {
    if(serialPort != null){
      serialPort.stop();
      serialPort = null;
    }
    //open the selected core
    String portName = Serial.list()[(int)theEvent.getController().getValue()];
    try{
      serialPort = new Serial(this,portName,BAUD_RATE);
    }
    catch(Exception e){
      System.err.println("Error opening serial port " + portName);
      e.printStackTrace();
    }
  } 
  else if (theEvent.isController()) {
    println("event from controller : "+theEvent.getController().getValue()+" from "+theEvent.getName());
  }
}
