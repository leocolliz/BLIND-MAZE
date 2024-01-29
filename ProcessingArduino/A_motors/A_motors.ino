/* control PWM with sensor */

int LED_pin = 5;  
int sensor_pin = 0;   // potentiometer connected to analog pin 0
int val = 0;         // variable to store the read value
int MOTORval = 0;

void setup() {
  Serial.begin(9600);
}

void loop() {

  val = analogRead(sensor_pin);  // read the input pin
  int minVal = 20; // set to 0 for noise
  if (val < minVal)
  {
    val = 0;
  }

  MOTORval = val / 5;
  //Serial.println(MOTORval);

  analogWrite(LED_pin, MOTORval);

}