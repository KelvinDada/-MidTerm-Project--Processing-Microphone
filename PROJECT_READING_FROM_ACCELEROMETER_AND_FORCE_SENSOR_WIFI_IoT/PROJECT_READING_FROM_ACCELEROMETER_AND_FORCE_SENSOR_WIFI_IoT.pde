/*
After adding the microphone data to this code, 
 sometiemes its giving an unknown IndexOutOfBoundException on the DataNoCommas[]
 
 
 [FIXED on Arduino] Also, after adding the microphone data from Arduino, the accelerometer visualization seems to run slower.
 */


import processing.serial.*;
  
import processing.net.*; 

Client myClient; 
int dataIn; 



String Sensors;
float accelerometerX, accelerometerY, mic, force, bottom;
float x, y, x1;
boolean status;
float bottomCounter = 0;



void setup() {
  size(2000, 2000);
  // colorMode(RGB, 100);
 
  myClient = new Client(this, "192.168.1.52",55181 );
}

void draw () { 
  background(0);
  while ( myClient.available() > 0) {  // If data is available,
    Sensors = myClient.readStringUntil(10);         // read it and store it in accelerometer
    if (Sensors != null) {
      // separate by commas
      String[] DataNoCommas = split(Sensors, ','); 
      accelerometerX = float (DataNoCommas[0]); // x axis
      accelerometerY = float(DataNoCommas[1]); // y axis
      force = float (DataNoCommas[2]); // FSR sensor data 
      bottom = float (DataNoCommas[3]); // FSR to change status
    }
  }


  //setting to bottom state to change status on the program. 
  if (bottom == 2) {
    status = true;
  } 




  //testing the Status and interaction with other variables
  if (status == true) {
    float Color = map(force, 0, 1024, 0, 255);
    background(Color, Color, Color);
    bottomCounter = bottomCounter + bottom*2; 
    }
 
      //example to visualize Accelerometer data
      x = map(accelerometerX, 1, -1, 0, width);
      x1 = map(accelerometerX, -4, 4, 0, width/2);
      y = map(accelerometerY, -4, 4, 1, height/2);
      fill(255);
      ellipse(x, height/2, x1, y);

      //example to visualize bottomCounter
      float x2 = bottomCounter;
      float y2 = bottomCounter;
      fill(255, 0, 0);
      ellipse(width/3, height/3, x2, y2);

   
      if (accelerometerX <= -2 || accelerometerX >= 2) {
        bottomCounter = 0;
        status = false;
      }




      print(accelerometerX);
      print(',');
      print(accelerometerY);
      print(',');
      print(mic);
      print(',');
      print(force);
      print(',');
      print(status);
      println (bottomCounter);

      textSize(50);
      text(frameRate, 50, 50);
    }
