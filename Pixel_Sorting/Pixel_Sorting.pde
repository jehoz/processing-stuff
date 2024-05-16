
float MAX_DIFF = 30; // out of 255


PImage img;

void setup() {
  size(612, 800);
  img = loadImage("Eyck.jpg");
}


void draw() {
   image(img, 0, 0);
   sortCols(img);
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
