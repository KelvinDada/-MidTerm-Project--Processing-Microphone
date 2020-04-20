/*
After adding the microphone data to this code, 
sometiemes its giving an unknown IndexOutOfBoundException on the DataNoCommas[]


[FIXED on Arduino] Also, after adding the microphone data from Arduino, the accelerometer visualization seems to run slower.
*/


import processing.serial.*;

Serial myPort;  // Create object from Serial class
String Sensors;
float accelerometerX, accelerometerY, mic, force, bottom;
float x, y, x1;
boolean status;
int bottomCounter;


void setup() {
  size(2000, 2000);
 // colorMode(RGB, 100);
  String portName = "COM3";
  myPort = new Serial(this, portName, 115200);
}

void draw () { 
background(0);
  while ( myPort.available() > 0) {  // If data is available,
    Sensors = myPort.readStringUntil(10);         // read it and store it in accelerometer
    if (Sensors != null) {
      // separate by commas
      String[] DataNoCommas = split(Sensors, ','); 
      accelerometerX = float (DataNoCommas[0]); // x axis
      accelerometerY = float(DataNoCommas[1]); // y axis
    mic = float (DataNoCommas[2]); // Mic data 
    force = float (DataNoCommas[3]); // FSR sensor data
    bottom = float (DataNoCommas[4]);
    }
  }
  
  //setting to bottom state to change status on the program. 
 if (bottom == 1.0) {
   status = true;
 } else { status = false; }
 
 //testing the Status and interaction with other variables
   if (status == true) {
   float Color = map(force, 0,1024,0,255);
      background(Color,Color,Color);
   }
   
     //example to visualize Accelerometer data
     x = map(accelerometerX, -1,1, 0,width);
     x1 = map(accelerometerX, -4,4,0,width/2);
     y = map(accelerometerY, -4,4,1,height/2);
   fill(255);
     ellipse(x,height/2,x1,y);
     
   //example to visualize the Mic data
     float x2 = map (mic, 0,60,0,1000);
    float y2 = map (mic, 0,60,0,1000);
    fill(255,0,0);
        ellipse(width/3, height/3, x2, y2);
    
   
     
  
      
      print(accelerometerX);
      print(',');
      print(accelerometerY);
       print(',');
      print(mic);
      print(',');
      print(force);
      print(',');
      println(status);
      
      
      textSize(50);
      text(frameRate, 50, 50);
}
