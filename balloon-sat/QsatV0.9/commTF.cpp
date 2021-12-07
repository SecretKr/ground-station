#include"commTF.h"




/**************************
data

0:airT	1:airH	

2:baseP	3:pres	4:alti

5:distance	6:latitude	7:longitude	8:altitude	9:sat	10:HDOP

11:AX	12:AY	13:AZ	14:GX	15:GY	16:GZ	17:MX	18:MY	19:MZ	20:PITCH	21:ROLL	22:YAW



**************************/










Sd2Card card;

File dataFile;

char logData[10];

#define chipSelect 5 
//#define SER2OUT 

void tfInit(){

 if (!SD.begin(chipSelect)) {
	 
    Serial1.print("Card failed to initialize, or not present");
  }   
  else {
    Serial1.println("card initialized.");
  }
  
}


void preFile(String *a){
  
  strcpy(logData, "log00.txt");
  
  for (int i = 0; i < 100; i++) {
    logData[3] = '0' + i/10;
    logData[4] = '0' + i%10;
    
    if (! SD.exists(logData)) {
        break;
      }
  }
	  

  *a = logData;
  dataFile = SD.open(logData, FILE_WRITE);  	  
}

void openFile(){
    dataFile = SD.open(logData, FILE_WRITE);  
}


void iwriteData(int a){ 
#ifdef SER2OUT  
Serial2.print(a);
#endif

	dataFile.print(a);	
} 
void iwriteDataLn(int a){ 
#ifdef SER2OUT  
Serial2.println(a);
#endif 
	dataFile.println(a);	
} 
void writeData(float a){  
#ifdef SER2OUT  
Serial2.print(a);
#endif 
	dataFile.print(a);	
} 
void writeDataLn(float a){ 
#ifdef SER2OUT  
Serial2.println(a);
#endif 
	dataFile.println(a);	
} 
void SwriteData(String a){ 
#ifdef SER2OUT  
Serial2.print(a);
#endif  

	dataFile.print(a);	
} 
void SwriteDataLn(String a){  
#ifdef SER2OUT  
Serial2.println(a);
#endif 

	dataFile.println(a);	
} 

void closeFile(){
	dataFile.close();
}
