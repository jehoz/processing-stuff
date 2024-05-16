import processing.video.*;

Capture cam;

PImage prevFrame;


void setup() {
  size(480, 360);
  frameRate(30);
  cam = new Capture(this, 480, 360, 30);
  cam.start();
  
}


void draw() {
  if (cam.available()) cam.read();

  PImage frame = cam;
  if (prevFrame == null) prevFrame = frame.copy();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      if (!passesThreshold(prevFrame, frame, x, y)) {
        frame.set(x, y, lerpColor(prevFrame.get(x, y), frame.get(x, y), 0.15));
      }
    }
  }
  prevFrame = frame.copy();
  
  image(frame, 0, 0);
}


boolean passesThreshold(PImage a, PImage b, int x, int y) {
  return abs(saturation(a.get(x, y)) - saturation(b.get(x, y))) > 40;
}
