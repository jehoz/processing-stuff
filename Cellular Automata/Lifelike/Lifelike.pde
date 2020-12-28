final int BOARD_HEIGHT = 64;
final int BOARD_WIDTH = 128;
final int DRAW_SCALE = 4;

final int[] BIRTH   = { 3 };
final int[] SURVIVE = { 0, 2, 3 };

Cell[][] board;
int generation = 0;


void setup() {
  size(512, 256);
  frameRate(15);
  board = new Cell[BOARD_WIDTH][BOARD_HEIGHT];
  initRandom();
  noStroke();
}


void draw() {
  background(0);
  for (int x = 0; x < BOARD_WIDTH; x++) {
    for (int y = 0; y < BOARD_HEIGHT; y++) {
      fill(board[x][y].getColor());
      rect(x*DRAW_SCALE, y*DRAW_SCALE, DRAW_SCALE, DRAW_SCALE);
    }
  }
  nextGen();
}


void initRandom() {
  for (int x = 0; x < BOARD_WIDTH; x++) {
    for (int y = 0; y < BOARD_HEIGHT; y++) {
      board[x][y] = new Cell(random(1.0) < 0.5);
    }
  }
}


void initLine() {
  for (int x = 0; x < BOARD_WIDTH; x++) {
    for (int y = 0; y < BOARD_HEIGHT; y++) {
      if (y == 16) { board[x][y] = new Cell(true);  }
      else         { board[x][y] = new Cell(false); } 
    }
  }
}


boolean survivesWith(int n) {
  for (int i = 0; i < SURVIVE.length; i++) {
    if (n == SURVIVE[i]) return true;
  }
  return false;
}


boolean birthsWith(int n) {
  for (int i = 0; i < BIRTH.length; i++) {
    if (n == BIRTH[i]) return true;
  }
  return false;
}


void nextGen() {
  Cell[][] nextBoard = new Cell[BOARD_WIDTH][BOARD_HEIGHT];
  
  for (int x = 0; x < BOARD_WIDTH; x++) {
    for (int y = 0; y < BOARD_HEIGHT; y++) {
      
      // count living neighbors
      int neighbors = 0;
      for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
          if (i == 0 && j == 0) continue;
          
          int xn = (x + i + BOARD_WIDTH) % BOARD_WIDTH;
          int yn = (y + j + BOARD_HEIGHT) % BOARD_HEIGHT;
          
          if (board[xn][yn].alive) {
            neighbors += 1;
          }
        }
      }
      
      nextBoard[x][y] = board[x][y].clone();
      
      // determine which living cells die
      if (board[x][y].alive) {
        if (!survivesWith(neighbors)) nextBoard[x][y].setDead();
      }
      // determine which dead cells are reborn
      else {
        if (birthsWith(neighbors)) nextBoard[x][y].setAlive();
      }
    }
  }
  
  for (int x = 0; x < BOARD_WIDTH; x++) {
    for (int y = 0; y < BOARD_HEIGHT; y++) {
      board[x][y] = nextBoard[x][y];
    }
  }
  generation++;
}


class Cell {
  boolean alive = false;
  int lastUpdate;  // last generation where cell's state changed
  
  Cell(boolean state) {
    alive = state;
    if (alive) {
      lastUpdate = generation;
    } else {
      lastUpdate = generation - 10;  // if starting as dead, don't show trace
    }
  }
  
  Cell clone() {
    Cell c = new Cell(alive);
    c.lastUpdate = lastUpdate;
    return c;
  }
  
  void setAlive() {
    if (!alive) {
      lastUpdate = generation;
    }
    alive = true;
  }
  
  void setDead() {
    if (alive) {
      lastUpdate = generation;
    }
    alive = false;
  }

  color getColor() {
    // 
    float youth = 1.0 - min((float) (generation - lastUpdate) / 10, 1.0);
    if (alive) {
      // young cells are white, old cells are blue
      return color(255 * youth, 255 * youth, 255);
    } else {
      // recently dead cells are red, long dead cells are black
      return color(127 * youth);
    }
  }
}
