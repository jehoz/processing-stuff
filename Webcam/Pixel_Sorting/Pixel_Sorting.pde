import processing.video.*;

float MAX_DIFF = 30; // out of 255
int NUM_PASSES = 15;

Capture cam;
PImage img;

void setup() {
  size(480, 360);
  frameRate(30);
  cam = new Capture(this, width, height, 30);
  cam.start();
}


void draw() {
  if (cam.available()) cam.read();

  img = cam.copy();
  
  int passes = floor(random(NUM_PASSES));
  for (int i = 0; i < passes; i++) {
    sortCols(img);
  }
  image(img, 0, 0);
}


/*
 * Single pass of bubblesort over each pixel column in image from top to bottom 
 */
void sortCols(PImage img) {
  for (int x = 0; x < img.width; x++) {
    for (int y = 0; y < img.height-1; y++) {
      color c1 = img.get(x, y);
      color c2 = img.get(x, y+1);
      float diff = brightness(c1) - brightness(c2);
      if (abs(diff) < MAX_DIFF && diff > 0) {
        img.set(x, y, c2);
        img.set(x, y+1, c1);
      }
    }
  }
}
