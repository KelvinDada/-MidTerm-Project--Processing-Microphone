/*
After adding the microphone data to this code, sometiemes its giving an unknown IndexOutOfBoundException on the DataNoCommas[]

INPUTS:
LDR Sensor - Using it like a Buttom
FSR sensor - Using it as a button
Accelerometer - Mapping X and Y axis.
Computer Microphone
 
 
 [FIXED on Arduino] Also, after adding the microphone data from Arduino, the accelerometer visualization seems to run slower.
 [MICROPHONE] No longer using the one on the arduinoBLE, because it burnt!
 */

//IMPORTING LIBRARIES
import processing.serial.*;
import processing.sound.*;

//AUDIO OBJECTS
AudioIn input;
Amplitude loudness;

//SERIAL COMMUNICATION
Serial myPort;  // Create object from Serial class

//SENSOR VARIABLES
String Sensors;
float accelerometerX, accelerometerY, mic, force, fsrButtom, ldrButtom;
float x, y, x1;
boolean status;
float fsrButtomCounter = 0; 
float ldrButtomCounter = 0; 



void setup() {
  size(2000, 2000);

//SETTING SERIAL PORT
  String portName = "COM12";
  myPort = new Serial(this, portName, 9600);
  
  //SETTING AUDIO INPUT
  // Create an Audio input and grab the 1st channel
  input = new AudioIn(this, 0);

  // Begin capturing the audio input
  input.start();

  // Create a new Amplitude analyzer
  loudness = new Amplitude(this);

  // Patch the input to the volume analyzer
  loudness.input(input);
  
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
      ldrButtom = float (DataNoCommas[2]); // LDR readings
      force = float (DataNoCommas[3]); // FSR sensor data 
      fsrButtom = float (DataNoCommas[4]); // using FSR to change status
    }
  }


  //setting to bottom state to change status on the program. 
  if (fsrButtom == 2) {
    status = true;
  } 

  float Color = map(force, 0, 1024, 0, 255);
    background(Color, Color, Color);


  //testing the Status and interaction with other variables
  if (status == true) {
  
    fsrButtomCounter = fsrButtomCounter + fsrButtom*2; 
    }
 
      //example to visualize Accelerometer data
      x = map(accelerometerX, 1, -1, 0, width);
      x1 = map(accelerometerX, -4, 4, 0, width/2);
      y = map(accelerometerY, -4, 4, 1, height/2);
      fill(255);
      ellipse(x, height/2, x1, y);

      //example to visualize bottomCounter
      float x2 = fsrButtomCounter;
      float y2 = fsrButtomCounter;
      fill(255, 0, 0);
      ellipse(width/3, height/3, x2, y2);

   
      if (ldrButtom ==1023) {
        fsrButtomCounter = 0;
        status = false;
        background(255,0,0);
      }
   
      
      // Adjust the volume of the audio input based on mouse position
  float inputLevel = 1;
  input.amp(inputLevel);

  // loudness.analyze() return a value between 0 and 1. To adjust
  // the scaling and mapping of an ellipse we scale from 0 to 0.5
  float volume = loudness.analyze();
  int size = int(map(volume, 0, 0.5, 1, 20000));

  
  noStroke();
  fill(0);
  // We draw a circle whose size is coupled to the audio analysis
  ellipse(width/2, height/2, size, size);

//printing for debugging
      print(accelerometerX);
      print(',');
      print(accelerometerY);
      print(',');
      print(mic);
      print(',');
      print(force);
      print(',');
      print(status);
      println (fsrButtomCounter);

fill(255);
      textSize(50);
      text(frameRate, 50, 50);
    }
