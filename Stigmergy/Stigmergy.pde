
import java.util.List;

float[][] WEIGHTS;

float[][] pheromones;
Ant[] ants;

PVector home, food;

void setup() {
  size(400, 300);
  frameRate(60);

  // initialize weights with perlin noise
  noiseDetail(16);
  WEIGHTS = new float[height][width];
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      WEIGHTS[y][x] = noise(float(x*5)/width, float(y*5)/height);
    }
  }

  pheromones = new float[height][width];

  // palce home to corners, food in center of window
  home = new PVector(0, 0);
  food = new PVector(width/2, height/2);

  ants = new Ant[100];
  for (int i = 0; i < ants.length; i++) {
    ants[i] = new Ant();
  }
}


void draw() {
  background(0);
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      set(x, y, lerpColor(color(WEIGHTS[y][x]*64), color(120, 50, 255), pheromones[y][x]));
    }
  }

  for (Ant ant : ants) {
    ant.move();
    set(int(ant.x), int(ant.y), #ffffff);
  }
}


class Ant {
  class StepChoice {
    int x, y;
    float weight;
    StepChoice(int x, int y, float w) {
      this.x = x;
      this.y = y;
      this.weight = w;
    }
  }

  int x, y;
  List<PVector> steps = new ArrayList<PVector>();

  Ant() {
    x = floor(home.x + random(-10, 11));
    y = floor(home.y + random(-10, 11));
    normalize();
  }

  void normalize() {
    x = (x + width) % width;
    y = (y + height) % height;
  }

  void markPath() {
    float stepAmt = 250.0 / steps.size();
    // pheromones placed at each step are proportional to how many steps were taken
    for (PVector step : steps) {
      pheromones[int(step.y)][int(step.x)] += stepAmt;
    }
  }

  void move() {
    if (x == food.x && y == food.y) {
      markPath();
      steps = new ArrayList<PVector>();
      x = floor(home.x + random(-10, 11));
      y = floor(home.y + random(-10, 11));
      normalize();
      return;
    }

    StepChoice[] choices = new StepChoice[8];
    float totalWeight = 0;
    int idx = 0;
    // determine weights of steps into neighboring cells 
    for (int j = -1; j <= 1; j++) {
      for (int i = -1; i <= 1; i++) {
        if (i == 0 && j == 0) continue;
        int wx = (x+i+width) % width, wy = (y+j+height) % height;

        // weight for a move is calculated as inverse distance to food * pheromone strength
        float weight = (3.0 / dist(wx, wy, food.x, food.y)) + (pheromones[wy][wx] / 10) - (WEIGHTS[wy][wx] / 40);
        weight = constrain(weight, 0, 100);

        choices[idx++] = new StepChoice(i, j, weight);
        totalWeight += weight;
      }
    }

    idx = 0;
    for (float r = random(totalWeight); idx < choices.length; idx++) {
      r -= choices[idx].weight;
      if (r <= 0) break;
    }

    int prevX = x, prevY = y;
    x += choices[idx].x;
    y += choices[idx].y;
    normalize();
    steps.add(new PVector(prevX, prevY));
  }
}


float dist(int x1, int y1, int x2, int y2) {
  return sqrt(sq(y2-y1)+sq(x2-x1));
}
