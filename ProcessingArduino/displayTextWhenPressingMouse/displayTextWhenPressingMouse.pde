// tuto  : press boutton, mouve with sensor
// test : "test 1 : X/X/X" => "3, 2, 1, ..., 0!"  / X = senses used
// repeat test 3x
// record data in a file

/* print text */ 

PFont f;
  
void setup() {
  size(640, 360);
  
  // Create the font
  //printArray(PFont.list());
  f = createFont("Yu Gothic UI Semilight", 20);
  textFont(f);
}

void draw() {
  background(102);
  if (mousePressed)
  {
    drawType(width * 0.5, 'd');
  }
  else
  {
    drawType(width * 0.5, 'r');
  }
}

void drawType(float x, char word) {
  textAlign(CENTER);
  if (word == 'd')
  {
    text("Welcome to the tutorial", x, 195);
    fill(51);
  }
  else
  {
    text("Press the button to start", x, 95);
    fill(51);
  }

  
}
