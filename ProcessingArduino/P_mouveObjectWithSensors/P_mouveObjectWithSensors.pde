import processing.serial.*;

Serial myPort;  // Create object from Serial class
static String val;    // Data received from the serial port
int sensorVal = 0;

int cx, cy, Diameter; // variables for obj

void setup() {
  size(1000, 500);  // size of the window
  noStroke();
  
  println(Serial.list());
  String portName = Serial.list()[0]; // Change the number (in this case ) to match the corresponding port number connected to your Arduino. 

  myPort = new Serial(this, portName, 9600);
  cy = height / 2;
  Diameter = 150;
}

void draw() {
  background(0); 
  fill(255, 204);
  
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n'); 
    try {
       sensorVal = Integer.valueOf(val.trim());
    }
    catch(Exception e) {
      ;
    }
    println(sensorVal); // read it and store it in vals!
  }  

  int x = sensorVal-500; // we shift mouseX to have 0 in the middle
  cx = (x*2)+500; // multiplied by 2 so that it match the dimension (oval goes out of vision)

  ellipse(cx, cy, Diameter, Diameter); // draw the oval to the new coordonates
  fill(255, 204); 
}
