import java.awt.Frame;
import java.awt.BorderLayout;
import controlP5.*; // http://www.sojamo.de/libraries/controlP5/
import processing.serial.*;

/* SETTINGS BEGIN */

float hTime = 20;

// Serial port to connect to
String serial_port = null;

Serial serialPort;
ControlP5 cp5;
DropdownList serialPortsList;
final int BAUD_RATE = 115200;

// graphs
Graph gyroGraph = new Graph(65,45,230,150,color(200,200,200));
Graph accGraph = new Graph(385,45,230,150,color(200));
Graph vvGraph = new Graph(705,45,230,150,color(200));
Graph altGraph = new Graph(65,525,230,150,color(200));

float[][] gyroGraphValues = new float[3][20];
float[] data = new float[40];
float[] gyroTime = new float[20];
//float[] lineGraphSampleNumbers = new float[20];

void setup() {
  surface.setTitle("GroundSatation");
  size(1440, 810);
  pixelDensity(2); // enable for macos
  fullScreen();
  // gui
  String[] portNames = Serial.list();
  cp5 = new ControlP5(this);
  background(20);
  
  // serial port
  cp5.setFont(createFont("Arial",10));
  serialPortsList = cp5.addDropdownList("serial ports").setPosition(500, 300).setWidth(400);
  serialPortsList.setBackgroundColor(color(20)).setColorBackground(color(40)).setItemHeight(30).setBarHeight(30).setColorActive(color(255));
  serialPortsList.getCaptionLabel().getStyle().setPadding(6,6,6,6);
  //serialPortsList.ListBoxItem().getStyle();
  for(int i = 0 ; i < portNames.length; i++) serialPortsList.addItem(portNames[i], i);
  
  // cam button
  cp5.addButton("UP")
     .setPosition(400,400)
     .setSize(50,50)
     .setColorBackground(color(40))
     .setColorForeground(color(20));
     
  // graph build
  for (int i=0; i<gyroGraphValues.length; i++) {
    for (int k=0; k<gyroGraphValues[0].length; k++) {
      gyroGraphValues[i][k] = 0;
    }
  }
  gyroGraph.xLabel="Time (sec)";
  gyroGraph.yLabel="deg/s";
  gyroGraph.Title="Gyroscopes";
  gyroGraph.xDiv=5;
  gyroGraph.yDiv=6;
  gyroGraph.xMax=0;
  gyroGraph.xMin=-hTime;
  gyroGraph.yMax=6;
  gyroGraph.yMin=-6;
  
  accGraph.xLabel="Time (sec)";
  accGraph.yLabel="g-force";
  accGraph.Title="Accelerometers";
  accGraph.xDiv=5;
  accGraph.yDiv=6;
  accGraph.xMax=0;
  accGraph.xMin=-hTime;
  accGraph.yMax=1.2;
  accGraph.yMin=-1.2;
  
  vvGraph.xLabel="Time (sec)";
  vvGraph.yLabel="m/s";
  vvGraph.Title="Vertical Velocity";
  vvGraph.xDiv=5;
  vvGraph.yDiv=6;
  vvGraph.xMax=0;
  vvGraph.xMin=-hTime;
  vvGraph.yMax=0.2;
  vvGraph.yMin=-0.2;
  
  altGraph.xLabel="Time (sec)";
  altGraph.yLabel="meters";
  altGraph.Title="Altitude";
  altGraph.xDiv=5;
  altGraph.yDiv=6;
  altGraph.xMax=0;
  altGraph.xMin=-hTime;
  altGraph.yMax=1.2;
  altGraph.yMin=-1.2;
  
  gyroGraph.DrawAxis();
  accGraph.DrawAxis();
  vvGraph.DrawAxis();
  altGraph.DrawAxis();
  drawRt(965,245,310,470);
  
  for (int i = 0;i < 35;i++) data[i] = 0;
  for (int i = 0;i < 20;i++) gyroTime[i] = -1;
}

void draw() {
  /* Read serial and update values */
  if (serialPort != null){
    if (serialPort.available() > 0) {
      String myString = "";
      try {
        myString = serialPort.readStringUntil('\n');
      }
      catch (Exception e) {}
      //print(myString);
      boolean writeGraph = false;
      String[] pack = split(myString, ' ');
      for(int i = 0;i < pack.length;i++){
        try {data[int(split(pack[i], ':')[0])] = float(split(pack[i], ':')[2]);}
        catch (Exception e) {}
        try { if( int(split(pack[i], ':')[0]) == 35) writeGraph = true; }
        catch (Exception e) {}
      }
      
      // gyro graph
      if(writeGraph){
        float max = -100;
        for(int k = 0;k < gyroGraphValues[0].length - 1;k++){
          gyroGraphValues[0][k] = gyroGraphValues[0][k+1];
          gyroTime[k] = gyroTime[k+1];
          if(gyroTime[k] == -1) gyroTime[k] = int(data[18]+data[17]*60+data[16]*3600)-gyroGraphValues[0].length+k;
          if(gyroGraphValues[0][k] > max) max = gyroGraphValues[0][k];
        }
        gyroGraphValues[0][gyroGraphValues[0].length-1] = data[22];
        gyroTime[gyroGraphValues[0].length-1] = int(data[18]+data[17]*60+data[16]*3600);
        if(max > 0.5) gyroGraph.yMax = max;
        else gyroGraph.yMax = 0.5;
      }
      
      
      
      // draw graph
      background(20);
      gyroGraph.DrawAxis();
      //gyroGraph.LineGraph(gyroTime, gyroGraphValues[0]);
      gyroGraph.smoothLine(gyroTime, gyroGraphValues[0]);
    }
  }
}

void drawRt(int x, int y, int w, int h){
  fill(color(45)); color(255);stroke(color(255));strokeWeight(2);
  
  rect(x,y,w,h,10);
  textAlign(CENTER);textSize(18);
  fill(255); color(255);stroke(color(255));strokeWeight(1);
  
  fill(255);
  text("Raw Telemetry" ,x+w/2,y+20);                            // Heading Title
  textAlign(CENTER);
}

public void UP(int theValue){
  if(serialPort != null) serialPort.write("hello\r\n");
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
