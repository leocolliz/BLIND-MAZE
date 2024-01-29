import processing.serial.*;

Serial myPort;  // Create object from Serial class
static String val;    // Data received from the serial port
int sensorVal = 0;
boolean buttonPushed = false;

int time;

int cx_old = 0;

int cx, cy, Diameter; // variables for obj

void setup() {
  size(1000, 500);  // size of the window
  noStroke();
  
  println(Serial.list());
  String portName = Serial.list()[0]; // match port number to Arduino

  myPort = new Serial(this, portName, 9600);
  cy = height / 2;
  cx = 0;
  Diameter = 150;
  time = millis();
}

void draw() {
  int accuracy = 0;
  int timeOfTest;
  int x = 0;
  
  background(0); 
  fill(255, 204);
  
  ellipse(cx, cy, Diameter, Diameter); // draw the oval to the new coordonates
  fill(255, 200); 
  
  ellipse(width/2, cy, Diameter/30, Diameter/30); // add a pointer to set the center
  fill(150,150);
  
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n'); 
    try {
       sensorVal = Integer.valueOf(val.trim());
    }
    catch(Exception e) {
      ;
    }
    //println(sensorVal); // read it and store it in vals!
    if (sensorVal==-9)
    {
      buttonPushed = true;
    }
    else
    {
      x = sensorVal;
    }
  }  

  if (!buttonPushed) // if user push button stop exercise
  {
    x = x-500; // we shift mouseX to have 0 in the middle
    cx_old = cx;
    cx = (x*2)+500; // multiplied by 2 so that it match the dimension (oval goes out of vision)

    if (cx != cx_old) // if the value has changed
    {
      myPort.write(cx); // send new value to arduino
      // TO DO : send value to pd
    }
  }
  else
  {
      accuracy = abs(cx - 500); // compute accuracy
      timeOfTest = millis() - time;
      println(timeOfTest, "ms");
      buttonPushed = false; // reset flag
      // TO DO : save in data file
  } 
}
