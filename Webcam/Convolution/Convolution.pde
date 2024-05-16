import processing.video.*;

Capture cam;

int[][] board;


int[][] KERNEL = {
  {1, 1, 1}, 
  {1, -8, 1}, 
  {1, 1, 1}
};



void setup() {
  size(480, 360);
  frameRate(30);
  cam = new Capture(this, width, height, 30);
  cam.start();
}


void draw() {
  if (cam.available()) cam.read();

  PImage frame = cam.copy();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      frame.set(x, y, convolute(cam, x, y));
    }
  }
  image(frame, 0, 0);
}


color convolute(PImage img, int x, int y) {
  int r = 0, g = 0, b = 0;
  for (int j = -1; j <= 1; j++) {
    for (int i = -1; i <= 1; i++) {
      int tx = (x + i + width) % width;
      int ty = (y + i + height) % height;

      color neighbor = img.get(tx, ty);
      r += red(neighbor) * KERNEL[j+1][i+1];
      g += green(neighbor) * KERNEL[j+1][i+1];
      b += blue(neighbor) * KERNEL[j+1][i+1];
    }
  }

  return color(r, g, b);
}
