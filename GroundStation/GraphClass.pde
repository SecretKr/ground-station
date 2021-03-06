  
/*   =================================================================================       
     The Graph class contains functions and variables that have been created to draw 
     graphs. Here is a quick list of functions within the graph class:
          
       Graph(int x, int y, int w, int h,color k)
       DrawAxis()
       Bar([])
       smoothLine([][])
       DotGraph([][])
       LineGraph([][]) 
     
     =================================================================================*/   

    class Graph 
    {
      
      boolean Dot=false;            // Draw dots at each data point if true
      boolean RightAxis;            // Draw the next graph using the right axis if true
      boolean ErrorFlag=false;      // If the time array isn't in ascending order, make true  
      boolean ShowMouseLines=true;  // Draw lines and give values of the mouse position
    
      int     xDiv=5,yDiv=5;            // Number of sub divisions
      int     xPos,yPos;            // location of the top left corner of the graph  
      int     Width,Height;         // Width and height of the graph

      color   GraphColor;
      color   BackgroundColor=color(20);  
      color   StrokeColor=color(255);     
      
      String  Title="Title";          // Default titles
      String  xLabel="x - Label";
      String  yLabel="y - Label";

      float   yMax=1024, yMin=0;      // Default axis dimensions
      float   xMax=10, xMin=0;
      float   yMaxRight=1024,yMinRight=0;
  
      PFont   Font;                   // Selected font used for text
     
      Graph(int x, int y, int w, int h,color k) {  // The main declaration function
        xPos = x;
        yPos = y;
        Width = w;
        Height = h;
        GraphColor = k;
      }
    
       void DrawAxis(){
       
   /*  =========================================================================================
        Main axes Lines, Graph Labels, Graph Background
       ==========================================================================================  */
        BackgroundColor = colors[1];
        fill(BackgroundColor); color(255);stroke(StrokeColor);strokeWeight(1.5);
        int t=40;
        rect(xPos-t*1.5,yPos-t,Width+t*2,Height+t*2,10);
        textAlign(CENTER);textSize(18);
        float c=textWidth(Title);
        fill(255); color(255);stroke(StrokeColor);strokeWeight(1);
        fill(255);
        text(Title,xPos+Width/2,yPos-15);                            // Heading Title
        textAlign(CENTER);textSize(14);
        text(xLabel,xPos+Width/2,yPos+Height+t/1.2);                     // x-axis Label 
        
        rotate(-PI/2);                                               // rotate -90 degrees
        text(yLabel,-yPos-Height/2,xPos-t*1.5+18);                   // y-axis Label  
        rotate(PI/2);                                                // rotate back
        
        textSize(10); noFill(); stroke(255); smooth();strokeWeight(1);
        line(xPos-3,yPos+Height,xPos-3,yPos);                        // y-axis line 
        line(xPos-3,yPos+Height,xPos+Width+5,yPos+Height);           // x-axis line 
        stroke(255);
          
        for(int x=0; x<=xDiv; x++){
          /*  =========================================================================================
                x-axis
              ==========================================================================================  */
           
        line(float(x)/xDiv*Width+xPos-3,yPos+Height,       //  x-axis Sub devisions    
             float(x)/xDiv*Width+xPos-3,yPos+Height+5);
        textSize(10);                                      // x-axis Labels
        String xAxis=str(xMin+float(x)/xDiv*(xMax-xMin));  // the only way to get a specific number of decimals 
        String[] xAxisMS=split(xAxis,'.');                 // is to split the float into strings 
        text(xAxisMS[0]+"."+xAxisMS[1].charAt(0),          // ...
        float(x)/xDiv*Width+xPos-3,yPos+Height+15);   // x-axis Labels
        }
          
           /*  =========================================================================================
                 left y-axis
               ==========================================================================================  */
          for(int y=0; y<=yDiv; y++){
            line(xPos-3,float(y)/yDiv*Height+yPos,                // ...
                  xPos-7,float(y)/yDiv*Height+yPos);              // y-axis lines 
            textAlign(RIGHT);fill(255);
            float lbl = yMin+float(y)/yDiv*(yMax-yMin);
            String lbls;
            if(lbl >= 1000){
              lbl/=1000; lbls = nf(lbl,0,1) + "k";
            }
            else lbls = nf(lbl,0,1);
            text(lbls,xPos-15,float(yDiv-y)/yDiv*Height+yPos+3);       // y-axis Labels 
            stroke(255);
          }
      }
   /*  =========================================================================================
       Dot graph
       ==========================================================================================  */
        void DotGraph(float[] x ,float[] y) {
         for (int i=0; i<x.length; i++){
                    strokeWeight(2);stroke(GraphColor);noFill();smooth();
           ellipse(
                   xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                   yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                   2,2
                   );
         }
      }
   /*  =========================================================================================
       Streight line graph 
       ==========================================================================================  */
      void LineGraph(float[] x ,float[] y) {
         for (int i=0; i<(x.length-1); i++){
           strokeWeight(2);stroke(GraphColor);noFill();smooth();
           line(xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                                            yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                                            xPos+(x[i+1]-x[0])/(x[x.length-1]-x[0])*Width,
                                            yPos+Height-(y[i+1]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);
         }
      }
      /*  =========================================================================================
             smoothLine
          ==========================================================================================  */
      void smoothLine(float[] x ,float[] y, int GraphColor) {
        float tempyMax=yMax, tempyMin=yMin;
        if(RightAxis){yMax=yMaxRight;yMin=yMinRight;}
        int counter=0;
        int xlocation=0,ylocation=0;
          beginShape(); strokeWeight(1);stroke(GraphColor);noFill();smooth();
            for (int i=0; i<x.length; i++){
           /* ===========================================================================
               Check for errors-> Make sure time array doesn't decrease (go back in time) 
              ===========================================================================*/
              if(i<x.length-1){
                if(x[i]>x[i+1]){
                  ErrorFlag=true;
                }
              }
         /* =================================================================================       
             First and last bits can't be part of the curve, no points before first bit, 
             none after last bit. So a streight line is drawn instead   
            ================================================================================= */
              if(i==0 || i==x.length-2)line(xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                                            yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                                            xPos+(x[i+1]-x[0])/(x[x.length-1]-x[0])*Width,
                                            yPos+Height-(y[i+1]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);
          /* =================================================================================       
              For the rest of the array a curve (spline curve) can be created making the graph 
              smooth.     
             ================================================================================= */ 
              curveVertex( xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                           yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height);
           /* =================================================================================       
              If the Dot option is true, Place a dot at each data point.  
             ================================================================================= */
             if(Dot)ellipse(
                             xPos+(x[i]-x[0])/(x[x.length-1]-x[0])*Width,
                             yPos+Height-(y[i]/(yMax-yMin)*Height)+(yMin)/(yMax-yMin)*Height,
                             2,2
                             );
            }
          endShape(); 
          yMax=tempyMax; yMin=tempyMin;
                float xAxisTitleWidth=textWidth(str(map(xlocation,xPos,xPos+Width,x[0],x[x.length-1])));
           
       if((mouseX>xPos&mouseX<(xPos+Width))&(mouseY>yPos&mouseY<(yPos+Height))){   
        if(ShowMouseLines){
          // if(mouseX<xPos)xlocation=xPos;
          if(mouseX>xPos+Width)xlocation=xPos+Width;
          else xlocation=mouseX;
          stroke(200); strokeWeight(0.5);fill(colors[0]);color(50);
          // Rectangle and x position
          line(xlocation,yPos,xlocation,yPos+Height);
          rect(xlocation-30,yPos+Height-22,60,20);
          
          textAlign(CENTER); fill(color(255));
          text(nf(map(xlocation,xPos,xPos+Width,x[0],x[x.length-1]),0,1),xlocation,yPos+Height-6);
          if(mouseY>yPos+Height)ylocation=yPos+Height;
          else ylocation=mouseY;
           // Rectangle and y position
          stroke(200); strokeWeight(0.5);fill(colors[0]);color(50);
          line(xPos,ylocation,xPos+Width,ylocation);
          int yAxisTitleWidth=int(textWidth(str(map(ylocation,yPos,yPos+Height,y[0],y[y.length-1]))) );
          float lbl = map(ylocation,yPos+Height,yPos,yMin,yMax);
          String lbls;
          if(lbl >= 1000){
            lbl/=1000; lbls = nf(lbl,0,1) + "k";
          }
          else lbls = nf(lbl,0,1);
          rect(xPos-12,ylocation-14, -46 ,22);
          textAlign(RIGHT); fill(color(255));//StrokeColor
          text(lbls,xPos-15,ylocation+4);
          noStroke();noFill();
         }
       }
      }
       //   void smoothLine(float[] x ,float[] y, float[] z, float[] a ) {
       //    GraphColor=color(188,53,53);
       //    smoothLine(x ,y);
       //    GraphColor=color(193-100,216-100,16);
       //    smoothLine(z ,a);
       //}
    }
    
 
