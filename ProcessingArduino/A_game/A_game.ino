/* Code for blind search game */

int Received_val; // Data received from the serial port
int LEDPin = 32; // Set the pin to digital 
const int buttonPin = 5;    // the number of the pushbutton pin

int buttonState;             // the current reading from the input pin
int lastButtonState = LOW;   // the previous reading from the input pin

unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 10;    // the debounce time; increase if the output flickers

int sensor_pin = 14;   // sensor connected to analog pin 0
int sensor_val = 0;   // variable to store the read value
int new_sensorVal;
int minVal = 20;      //set minimal value so avoid noise

int motor1_val = 0;
int motor1_pin = 6;
int motor2_val = 0;
int motor2_pin = 7;
int motor3_val = 0;
int motor3_pin = 8;
int motor4_val = 0;
int motor4_pin = 9;

void setup() {
  pinMode(LEDPin, OUTPUT); // Set pin as OUTPUT
  pinMode(buttonPin, INPUT);
  
  Serial.begin(9600); // Start serial communication at 9600 bps
}

void loop() {

  new_sensorVal = analogRead(sensor_pin);  // read the sensor
  if (new_sensorVal > minVal)
  {
    sensor_val = new_sensorVal;
    Serial.println(sensor_val);  
  }
  delay(50); // wait 50 ms to not saturate connexion

  int readButton = digitalRead(buttonPin);
  // If the switch changed, due to noise or pressing:
  if (readButton != lastButtonState) {
    // reset the debouncing timer
    lastDebounceTime = millis();
  }

  if ((millis() - lastDebounceTime) > debounceDelay) {
    // whatever the reading is at, it's been there for longer than the debounce
    // delay, so take it as the actual current state:

    // if the button state has changed:
    if (readButton != buttonState) {
      buttonState = readButton;

      // only send if the new button state is HIGH
      if (buttonState == HIGH) {
        //digitalWrite(LEDPin, HIGH);
        Serial.println(-9);  
      }
       else
      {
        //digitalWrite(LEDPin, LOW);  
      }
    }
  }
  lastButtonState = readButton;

// RECEIVE
  if (Serial.available()) 
  { // If data is available to read,
    Received_val = Serial.read(); // read it and store it in val
    Received_val = Received_val * 4;
  // Serial.print(val);
  }

  controlMotor(Received_val);
}

void controlMotor(int val)
{
  // motor 1 : in front 
  if ((val < 700) & (val > 500))
  {
    motor1_val = 700 - val;
  }
  else if ((val < 500) & (val > 300))
  {
    motor1_val = val - 300;
  }
  else
  {
    motor1_val = 0;
  }
  analogWrite(motor1_pin, motor1_val);

  // motor 2 : left 
  if ((val < 450) & (val > 250))
  {
    motor2_val = 450 - val;
  }
  else if ((val < 250) & (val > 50))
  {
    motor2_val = val - 50;
  }
  else
  {
    motor2_val = 0;
  }
  analogWrite(motor2_pin, motor2_val);

  // motor 3 : right 
  if ((val < 950) & (val > 750))
  {
    motor3_val = 950 - val;
  }
  else if ((val < 750) & (val > 550))
  {
    motor3_val = val - 300;
  }
  else
  {
    motor3_val = 0;
  }
  analogWrite(motor3_pin, motor3_val);

  // motor 4 : back
  if ((val < 200) & (val > 0))
  {
    motor4_val = 200 - val;
  }
  else if ((val < 1000) & (val > 800))
  {
    motor4_val = val - 800;
  }
  else
  {
    motor4_val = 0;
  }
  analogWrite(motor4_pin, motor4_val);
 
}
 

