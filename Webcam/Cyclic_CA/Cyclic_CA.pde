import processing.video.*;

Capture cam;
PImage prevFrame;

final int NUM_STATES = 5;
final int THRESHOLD = 3;

int[][] board;

void setup() {
  size(480, 360);
  frameRate(30);
  cam = new Capture(this, width, height, 30);
  cam.start();
  
  board = new int[height][width];
  // set each pixel to random state
  for (int y = 0; y < height-1; y++) {
    for (int x = 0; x < width-1; x++) {
      board[y][x] = floor(random(NUM_STATES));
    }
  }
}


void draw() {
  if (cam.available()) cam.read();

  PImage frame = cam.copy();
  if (prevFrame == null) prevFrame = frame.copy();
  int[][] next = new int[height][width];
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      next[y][x] = nextState(x, y);

      if (next[y][x] % 2 == 0) {
        frame.set(x, y, lerpColor(prevFrame.get(x, y), frame.get(x, y), 0.2));
      }
    }
  }
  prevFrame = frame.copy();
  image(frame, 0, 0);

  for (int y = 0; y < height-1; y++) {
    for (int x = 0; x < width-1; x++) {
      board[y][x] = next[y][x];
    }
  }
}

int nextState(int x, int y) {
  int succ = (board[y][x] + 1) % NUM_STATES;
  int count = 0;

  for (int j = -1; j <= 1; j++) {
    int yn = (y + j + height) % height;
    for (int i = -1; i <= 1; i++) {
      int xn = (x + i + width) % width;

      if (board[yn][xn] == succ) {
        count++;
      }
    }
  }
  return (count >= THRESHOLD) ? succ : board[y][x];
}
