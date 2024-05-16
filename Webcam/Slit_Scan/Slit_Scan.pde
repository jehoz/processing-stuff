import processing.video.*;

Capture cam;

ArrayList<PImage> frameBuf;
final int MAX_BUFFER_LEN = 60; 

void setup() {
  size(480, 360);
  frameRate(60);
  cam = new Capture(this, 480, 360, 30);
  cam.start();
  
  frameBuf = new ArrayList<PImage>();
}


void draw() {
  if (cam.available()) cam.read();
  
  frameBuf.add(cam.copy());
  while (frameBuf.size() > MAX_BUFFER_LEN) {
    frameBuf.remove(0);
  }

  PImage frame = cam.copy();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      
      float[] xyz = mapPixel(((float) x) / width, ((float) y) / height);
      
      float zf = constrain(xyz[2] * frameBuf.size(), 0, frameBuf.size()-1);
      int z0 = floor(zf);
      int z1 = ceil(zf);
      float dz = zf - z0;
      
      PImage img0 = frameBuf.get(z0);
      PImage img1 = frameBuf.get(z1);
      
      float xf = constrain(xyz[0] * width, 0, width-1);
      float yf = constrain(xyz[1] * height, 0, height-1);
      
      
      color c0 =  getInterp(img0, xf, yf);
      color c1 =  getInterp(img1, xf, yf);
      
      color c = lerpColor(c0, c1, dz); 
      
      frame.set(x, y, c);
    }
  }
  
  image(frame, 0, 0);
}

float[] mapPixel(float x, float y) {
  float z = 1 - abs((y - 0.5) * 2);
  
  float[] pt = {x, y, z};
  return pt;
}

// bilinearly interpolate pixels to get smooth color at any point
color getInterp(PImage img, float x, float y) {
  int x0 = floor(x);
  int x1 = ceil(x);
  int y0 = floor(y);
  int y1 = ceil(y);
  
  float dx = x - x0;
  float dy = y - y0;
  
  color c00 = img.get(x0, y0);
  color c10 = img.get(x1, y0);
  color c01 = img.get(x0, y1);
  color c11 = img.get(x1, y1);
  
  color c0 = lerpColor(c00, c10, dx);
  color c1 = lerpColor(c01, c11, dx);
  
  color c = lerpColor(c0, c1, dy);
  
  return c;
}
