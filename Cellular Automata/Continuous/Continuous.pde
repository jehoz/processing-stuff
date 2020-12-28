final int DRAW_SCALE = 2;

float K = 1;
float H = 0.005;

float[][] board;

int boardHeight, boardWidth;


void setup() {
  size(600, 800);
  frameRate(60);
  boardHeight = height / DRAW_SCALE;
  boardWidth = width / DRAW_SCALE;
  board = new float[boardHeight][boardWidth];
}


void draw() {
  background(0);
  noStroke();
  
  // top row always empty with middle cell full
  for (int x = 0; x < boardWidth; x++) board[0][x] = 0; //<>//
  board[0][boardWidth/2] = 1.0;
  
  fill(255.0);
  rect((boardWidth/2)*DRAW_SCALE, 0, DRAW_SCALE, DRAW_SCALE);
  
  for (int y = 1; y < boardHeight; y++) {
    for (int x = 0; x < boardWidth; x++) {
      float avg = (
        board[y-1][(x + boardWidth - 1) % boardWidth] + 
        board[y-1][x] + 
        board[y-1][(x+1) % boardWidth]
        ) / 3;
      
      avg /= K;
      avg += H;
      
      board[y][x] = avg - floor(avg);
      
      fill(board[y][x] * 255);
      rect(x*DRAW_SCALE, y*DRAW_SCALE, DRAW_SCALE, DRAW_SCALE);
    }
  }
  
  H += 0.000001;
}
