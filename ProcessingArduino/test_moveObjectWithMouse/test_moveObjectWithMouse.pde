// --------------------------------------------------------------
// This fonction is making moving the oval thanks to the mouse
// --------------------------------------------------------------

int cx, cy, Diameter;

void setup() {
  size(1000, 500);  // size of the window
  //noStroke();
 // rectMode(CENTER);
  
  cy = height / 2;
  Diameter = 150;
}

void draw() {
  background(0); 
  fill(255, 204);

  int x = mouseX-500; // we shift mouseX to have 0 in the middle
  cx = (x*2)+500; // multiplied by 2 so that it match the dimension (oval goes out of vision)

  ellipse(cx, cy, Diameter, Diameter); // draw the oval to the new coordonates
  fill(255, 204); 
}
