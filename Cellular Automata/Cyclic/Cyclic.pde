

color[] STATES = {
  //#ffffff,
  #d0e1f9,
  #4d648d,
  #283655,
  #1e1f26
};

int THRESHOLD = 3;

int[][] board;


void setup() {
  size(800, 600);
  frameRate(25);
  
  board = new int[height][width];
  
  // set each pixel to random state
  for (int y = 0; y < height-1; y++) {
    for (int x = 0; x < width-1; x++) {
      board[y][x] = floor(random(STATES.length));
      set(x, y, STATES[board[y][x]]);
    }
  }
}


void draw() {
  int[][] next = new int[height][width];
  for (int y = 0; y < height-1; y++) {
    for (int x = 0; x < width-1; x++) {
      next[y][x] = nextState(x, y);
    }
  }
  
  for (int y = 0; y < height-1; y++) {
    for (int x = 0; x < width-1; x++) {
      board[y][x] = next[y][x];
      set(x, y, STATES[board[y][x]]);
    }
  }
}


int nextState(int x, int y) {
  int succ = (board[y][x] + 1) % STATES.length;
  int count = 0;
 
  for (int j = -1; j <= 1; j++) {
    int yn = (y + j + height) % height;
    for (int i = -1; i <= 1; i++) {
      int xn = (x + i + width) % width;
      
      if (board[yn][xn] == succ) { //<>//
        count++;
      }
    }
  }
  return (count >= THRESHOLD) ? succ : board[y][x];
}
