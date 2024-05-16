
final float DA = 1;
final float DB = 0.5;
float F  = 0.0380;
float K  = 0.0610;
final int ITER_PER_FRAME = 8;

final color COLOR_A = #79cbb8;
final color COLOR_B = #0d1137;

final int CLICK_SIZE = 15;

// convolution weights for laplacian function
final float[][] WEIGHTS = {{  0.10, 0.15, 0.10 }, 
  {  0.15, -1.00, 0.15 }, 
  {  0.10, 0.15, 0.10 }};

Cell[][] board, next;

void setup() {
  size(360, 360);
  frameRate(60);

  // fill board with A=1, B=0
  board = new Cell[height][width];
  next = new Cell[height][width];
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      board[y][x] = new Cell(1, 0);
      next[y][x] = new Cell(1, 0);
    }
  }
}


void draw() {
  background(0);

  for (int iter = 0; iter < ITER_PER_FRAME; iter++) {
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {

        // calculate laplacians from weighted 3x3 convolution
        float lapA = 0, lapB = 0;
        for (int j = -1; j <= 1; j++) {
          for (int i = -1; i <= 1; i++) {
            Cell neighbor = board[(y+j+height) % height][(x+i+width) % width];
            lapA += neighbor.A * WEIGHTS[j+1][i+1];
            lapB += neighbor.B * WEIGHTS[j+1][i+1];
          }
        }

        // pulling these out makes the following equations more readable
        float A = board[y][x].A, B = board[y][x].B;

        next[y][x].A = A + (DA*lapA + (-A*B*B) + F*(1-A));
        next[y][x].B = B + (DB*lapB + A*B*B - (K+F)*B);
      }
    }

    // swap arrays
    Cell[][] tmp = board;
    board = next;
    next = tmp;
  }

  float c;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      c = constrain(4*(board[y][x].A) - 1, 0.0, 1.0);
      set(x, y, lerpColor(COLOR_A, COLOR_B, c));
    }
  }
}


void mousePressed() {
  for (int y = -CLICK_SIZE; y <= CLICK_SIZE; y++) {
    for (int x = -CLICK_SIZE; x <= CLICK_SIZE; x++) {
      if (sqrt(x*x + y*y) <= CLICK_SIZE) {
        board[(mouseY+y+height) % height][(mouseX+x+width) % width].B = 1;
      }
    }
  }
}

void keyPressed() {
  switch (keyCode) {
  case UP:
    F += 0.001;
    break;
  case DOWN:
    F -= 0.001;
    break;
  case LEFT:
    K -= 0.001;
    break;
  case RIGHT:
    K += 0.001;
    break;
  }
  println("F: " + F + "\tK: " + K);
}


class Cell {
  // concentrations of the two chemicals in the cell
  float A, B;

  Cell(float a, float b) {
    A = a;
    B = b;
  }
}
