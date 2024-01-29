const int buttonPin = 7;    // the number of the pushbutton pin
const int ledPin = 5;      // the number of the LED 

int ledState = LOW;

//the following variables are unsigned longs because the time, measured in milliseconds,
// will quickly become a bigger number than can be stored in an int.
unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 10;    // the debounce time; increase if the output flickers
// TO DO : add debounce !!!

void setup() {
  // put your setup code here, to run once:
  pinMode(buttonPin, INPUT);
  pinMode(ledPin, OUTPUT);

  digitalWrite(ledPin, ledState);
}

void loop() {
  // put your main code here, to run repeatedly:
  int readingB = digitalRead(buttonPin);
  if (readingB == HIGH)
  {
    digitalWrite(ledPin, HIGH);    
  }
  else
  {
    digitalWrite(ledPin, LOW);    
  }

}
