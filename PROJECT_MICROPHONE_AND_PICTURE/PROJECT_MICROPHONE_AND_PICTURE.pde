/* This code reads the values from the serial and trigger changes on the animation
 I'm getting a bunch of zero's mixed with the real data. Need to fix that!
 
 Written by Kelvin Feliz, 2020
 
 */

///LIBRARIES///
import processing.serial.*;

//VARIABLES//
Serial myPort;  // Create object from Serial class
String microphone;
PImage Face1, Boca1;
PImage Face2;


int nl = 10; //ASCII code to pass to next line.

//AVERAGING VARIABLES//
int numReadingsMic = 30; // the higher the numbers, the smoother the movement of the mouth
float[] readingsMic = new  float[numReadingsMic];
int readIndexMic =0;
int totalMic = 0;
int averageMic = 0;

void setup() {
  size(735, 735);
  colorMode(RGB, 100);

  //Initialize port//
  String portName = "COM3";
  myPort = new Serial(this, portName, 9600);

  //Loading Images
  Face1 = loadImage("Face1.png");
  Boca1 = loadImage("Boca1.png");
  
  //initialize Mic Readings to 0:
   for (int thisReading = 0; thisReading < numReadingsMic; thisReading++) {
    readingsMic[thisReading] = 0;
   }

  //frameRate (15);
}

void draw() {
  //background(0);
  imageMode (CORNER);
  image(Face1, 0, 0);
  float mic = 0;

  // read from serial 
  while ( myPort.available() > 0) // while data is available,
  {  
    microphone = myPort.readStringUntil(nl); // read it and store it in microphone
    if (microphone != null)
    {
      mic = float(microphone); //convert String microphone into a float number
    }
  }

//Creating an average from the readings of the microphones to avoid random 0's 
//I was getting mixed with the real data from the sensor.
  // subtract the last reading:
  totalMic= totalMic - int(readingsMic[readIndexMic]);
  // read from the sensor:
  readingsMic[readIndexMic] = mic;
  // add the reading to the total:
  totalMic = totalMic + int(readingsMic[readIndexMic]);
  // advance to the next position in the array:
  readIndexMic = readIndexMic + 1;

  // if we're at the end of the array...
  if (readIndexMic >= numReadingsMic) {
    // ...wrap around to the beginning:
    readIndexMic = 0;
  }
  // calculate the average:
  averageMic = totalMic / numReadingsMic;


  //mapping variables to other variables
  float y = map(averageMic, 0, 40, 0, 200);
  
  //Displaying mouth
  image(Boca1, 0, y);
  
  println(averageMic);
}
