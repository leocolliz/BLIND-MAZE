// serial stuff
import processing.serial.*;
Serial myPort;         // Create object from Serial class
static String val;     // Data received from the serial port
int sensorVal = 0;     // store data form serial port

// variables for text messages
PFont f;

// general stuff
boolean tutorial = false; 
boolean game = false;
boolean mode1 = true;  // sound + haptic + visual
boolean mode2 = false; // sound + haptic
boolean mode3 = false; // visual
boolean buttonPushed = false; 

int time = millis();
int roundNumber = 0;
int[] mode = {};

// variables for obj
int cx, cy, Diameter; 
int cx_new = -300;


// variables for the record file
String[] lines;
PrintWriter output;

// variables for communicating with PD
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddress myRemoteLocation;
  
/*************************** initialisation ***************************/
void setup() {
  size(1000, 500);
  
  // Create the font
  f = createFont("Yu Gothic UI Semilight", 20);
  textFont(f);
  
  // set serial channel
  String portName = Serial.list()[0]; // match port number to Arduino
  myPort = new Serial(this, portName, 9600);
  
  // variable for the object
  cy = height / 2;
  cx = 0; 
  Diameter = 150;
  
  // open record file to save data
  lines = loadStrings("/../../data/recordFile.txt");
  output = createWriter("/../../data/recordFile.txt");

  for (int i = 0; i < lines.length; i++) {
    output.println(lines[i]); 
  }
  
  // PD
  frameRate(25);
  // start oscP5, listening for incoming messages at port 12000
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 8000); // careful check number !!!
}


/*************************** programm ***************************/
void draw() {
  
  int x = ListenSerial();

  if (game)
  {
    drawType(width * 0.5, 'g');
    //fill(255, 204);
    gameRound(x, output);
  }
  else if (tutorial)
  {
    
    // TO DO : send to pd "start"
    drawType(width * 0.5, 't');
    if (buttonPushed == true)
    {
      buttonPushed = false; // reset flag value
      tutorial = false;
      game = true;
      startRound(); // start a round in a certain mode
    }
    else
    {
      gameRound(x, output);
    }
  }
  else
  {
    background(102);
    if (buttonPushed == true)
    {
      buttonPushed = false; // reset flag value
      tutorial = true;
      // send start to pd 
      OscMessage myMessage = new OscMessage("/start");
      myMessage.add(1); /* add an int to the osc message */
      /* send the message */
      oscP5.send(myMessage, myRemoteLocation);
    }
    else
    {
      drawType(width * 0.5, 's');
    }
  }  
}


int ListenSerial() {
  int x_val = -1;
  if ( myPort.available() > 0) {  // If data is available,
    val = myPort.readStringUntil('\n'); 
    try {
       sensorVal = Integer.valueOf(val.trim());
    }
    catch(Exception e) {
      ;
    }
    println(sensorVal); // read it and store it in vals!
    if (sensorVal==-9)
    {
      buttonPushed = true;
    }
    else
    {
      x_val = sensorVal;
    }
  }
  //println("x dans la fonciton listen:", x_val);
  return x_val; // pb : send back zero when button pushed...
}

void drawType(float x, char word) {
  textAlign(CENTER);
  
    switch(word) {
    case 't':
    background(0);
    text("Welcome to the tutorial, you can try the sensor\nWhen you are ready, press the button", x, 95);
    fill(150);
    break;
    case 's':
    text("Press button to start tutorial", x, height / 2);
    fill(51);
    break;
    case 'g':
    background(0); // reset the screen
    if (mode1){
      text("Round " + roundNumber + "/3 : sound + haptic + visual", x, 95);
    }
    else if (mode2){
      text("Round " + roundNumber + "/3 : sound + haptic", x, 95);
    }
    else if (mode3){
      text("Round " + roundNumber + "/3 : visual", x, 95);
    }
    fill(150);
    break;
  }
}

void startRound()
{
  int newMode;
  int startSound;
  roundNumber += 1;
  if (roundNumber < 4)
  {
    newMode = int(random(3));
    for (int i = 0; i < mode.length; i++) 
    {
      if(mode[i] == newMode)
      {
        newMode = int(random(3));
      }
    }
    mode = append(mode, newMode);
    chooseMode(newMode);
    if ((mode1) | (mode2) | (tutorial))
    {
      startSound = 1;
    }
    else
    {
      startSound = 0;
    }
    
    // send start to pd 
    OscMessage myMessage = new OscMessage("/start");
    myMessage.add(startSound); /* add an int to the osc message */
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
    
    cx = randomVal(); // set the obj to a random position
    time = millis(); // set new time
  } 
  else
  {
    output.close(); // close data file
    
    // stops sound PD
    OscMessage myMessage = new OscMessage("/start");
    myMessage.add(0); /* add an int to the osc message */
    /* send the message */
    oscP5.send(myMessage, myRemoteLocation);
    exit();
  }
}

void chooseMode(int modeNumber)
{
    mode1 = false;
    mode2 = false;
    mode3 = false;
  switch(modeNumber) {
    case 0:
    mode1 = true;
    break;
    case 1:
    mode2 = true;
    break;
    case 2:
    mode3 = true;
    break;
  }
}

void gameRound(int cx_val, PrintWriter file){
  float accuracy = 0;
  int timeOfTest;
  int c_angle = 0;
   
  if ((mode1) | (mode3))
  {
    ellipse(cx, cy, Diameter, Diameter); // draw the oval to the new coordonates
    fill(255, 200); 
    ellipse(width/2, cy, Diameter/30, Diameter/30); // add a pointer to set the center
    fill(150,150);
  }
  
  if (!buttonPushed) // if user push button stop exercise
  {
    if(cx_val>-1)
    {
      cx = cx + computeShift(cx_val);
      
      if (cx < -500)
      {
        cx = 1500;
      }
      else if  (cx > 1500)
      {
        cx = -500;
      }

      
      if ((mode1) | (mode2))
      {
        c_angle = (cx+500)/2;
        sendAngleToPD(c_angle);  // send value to PD
        myPort.write(c_angle/4);
        println(c_angle + " here!");
      }
      
    }
  }
  else // if the button is pushed save values and start a new round
  {
    accuracy = 100 - (abs(cx - 500)/10); // compute accuracy in %
    timeOfTest = millis() - time;
    
    println(timeOfTest + "ms" + accuracy );
    buttonPushed = false; // reset flag

    if (tutorial == false) // if we are not in tutorial, save the data
    {
      if (mode1)
      { file.println("SHV" + ";" + accuracy + ";" + timeOfTest + ";"); }
      else if (mode2)
      { file.println("SH" + ";" + accuracy + ";" + timeOfTest + ";"); }
      else if (mode3)
      { file.println("V" + ";" + accuracy + ";" + timeOfTest + ";"); }
      file.flush();
      startRound();
    }
  }
}

void sendAngleToPD(int angle) {
  OscMessage myMessage = new OscMessage("/angle");
  if (angle > 1000) // put a limit on 1000
  {
    angle = 1000;
  }
  myMessage.add(angle); /* add an int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation); 
}

int randomVal()
{
  int newValue = 0;
  newValue = int(random(-500, 1500));  
  return newValue;
}

int computeShift(int sensorValue)
{
  int shiftValue = 0;
  shiftValue = (sensorValue-500)/10;
  
  return shiftValue;
}
