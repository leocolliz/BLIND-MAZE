uint16_t analog_input_pin = 0;
uint16_t analog_input_val = 0;


void setup() 
{
//initialize serial communications at a 9600 baud rate
  //Serial.end();
  Serial.begin(9600);
}


void loop()
{
  int minVal = 20;
  analog_input_val = analogRead(analog_input_pin);
  if (analog_input_val > minVal)
  {
   Serial.println(analog_input_val);
  }
 

  //wait 100 milliseconds so we don't drive ourselves crazy
  delay(500);

}

// with a 10k Ohm resistor, values are btw 30 and 1100.
