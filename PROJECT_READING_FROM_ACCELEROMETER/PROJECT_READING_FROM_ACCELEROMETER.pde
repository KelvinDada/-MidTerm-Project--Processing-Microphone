
import processing.serial.*;

Serial myPort;  // Create object from Serial class
String accelerometer;
float accelerometerX, accelerometerY;
float x, y, x1;



void setup() {
  size(2000, 2000);
 // colorMode(RGB, 100);
  String portName = "COM3";
  myPort = new Serial(this, portName, 9600);
}

void draw () { 
background(0);
  while ( myPort.available() > 0) {  // If data is available,
    accelerometer = myPort.readStringUntil(10);         // read it and store it in accelerometer
    if (accelerometer != null) {
      // separate by commas
      String[] AcceNoCommas = split(accelerometer, ','); 
      accelerometerX = float (AcceNoCommas[0]); // x axis
      accelerometerY = float(AcceNoCommas[1]); // y axis
      
   
    }
  }
     
     x = map(accelerometerX, -4,4, 1,width/2);
     x1 = map(accelerometerX, -4,4,0,width);
     y = map(accelerometerY, -4,4,1,height/2);
     
      ellipse(x1,height/2,x,y);
      print(accelerometerX);
      print(',');
      println(accelerometerY);
}
