
int NUM_OCTAVES = 15;

void setup() {
  size(512, 512);
  noiseDetail(10);
}

void draw() {
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      set(x, y, sample(float(x)/width, float(y)/height));
    }
  }
}


color sample(float x, float y) {
  float qx = fbm(x, y);
  float qy = fbm(x + 5.2, y + 1.3);
  float rx = fbm(x + 4*qx + 1.7, y + 4*qy + 9.2);
  float ry = fbm(x + 4*qx + 8.3, y + 4*qy + 2.8);
  float f = fbm(x + 4*rx, y + 4*ry);
  return color(f*64, f*127, f*255);
  
}


float warp(float x, float y) {
  float qx = fbm(x, y);
  float qy = fbm(x + 5.2, y + 1.3);
  float rx = fbm(x + 4*qx + 1.7, y + 4*qy + 9.2);
  float ry = fbm(x + 4*qx + 8.3, y + 4*qy + 2.8);
  return fbm(x + 4*rx, y + 4*ry);
}


float fbm(float x, float y) {
  float G = 0.5;  // play with this (2^(-H))
  float f = 1.0;
  float a = 1.0;
  float t = 0.0;

  for (int i=0; i < NUM_OCTAVES; i++) {
    t += a * noise(f*x, f*y);
    f *= 2;
    a *= G;
  }

  return t;
}
