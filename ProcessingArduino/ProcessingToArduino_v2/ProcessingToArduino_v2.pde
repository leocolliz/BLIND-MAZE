import processing.serial.*;

Serial myPort;  // Create object from Serial class
static String val;    // Data received from the serial port
int sensorVal = 0;

void setup()
{
  size(400,400);
  noStroke();
  fill(204);
  
  println(Serial.list());
  String portName = Serial.list()[0]; // Change the number (in this case ) to match the corresponding port number connected to your Arduino. 

  myPort = new Serial(this, portName, 9600);
}

void draw()
{
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

  background(0); 
  fill(255);
  ellipse(random(width), random(height), 3, 3);
}  
