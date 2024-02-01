 int val; // Data received from the serial port
 int LEDPin = 5; // Set the pin to digital I/O 13

 void setup() {
   pinMode(LEDPin, OUTPUT); // Set pin as OUTPUT
   Serial.begin(9600); // Start serial communication at 9600 bps
 }

 void loop() {
   if (Serial.available()) 
   { // If data is available to read,
     val = Serial.read(); // read it and store it in val
     val = val * 4;
    // Serial.print(val);
   }
    //if (val > 75)  
  if ((val < 745) & (val > 245))
    {
      digitalWrite(LEDPin, HIGH); // turn on LED
    }
    else
    {
      digitalWrite(LEDPin, LOW); // turn on LED
    }
    delay(10); // Wait 10 milliseconds for next reading
}
