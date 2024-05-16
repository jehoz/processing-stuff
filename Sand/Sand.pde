

SandPlotter[] plotters;


void setup() {
  size(600, 600);

  plotters = new SandPlotter[25];
  float radius = (float) min(width, height) / 2;
  for (int i = 0; i < plotters.length; i++) {
    // generate random position on circumference of circle
    float angle = random(PI*2);
    float x = width/2 + cos(angle)*radius;
    float y = height/2 + sin(angle)*radius;
    plotters[i] = new SandPlotter(new PVector(x, y), color(random(255), random(200), random(77)));
    plotters[i].angle = angle;
    plotters[i].radius = radius+random(-5, 5);
  }

  background(#FFFFFF);
}

void draw() {
  for (SandPlotter plotter : plotters) {
    plotter.radius -= random(.5);
    if (plotter.radius < 0) noLoop();
    
    float angle = plotter.angle + random(PI/16, PI/4);
    float x = width/2 + cos(angle)*(plotter.radius+random(-0.25, 0.25));
    float y = height/2 + sin(angle)*(plotter.radius+random(-0.25, 0.25));

    plotter.angle = angle;
    plotter.plot(new PVector(x, y));
  }
}


class SandPlotter {
  color sandColor;
  float radius, angle;
  PVector pos;

  public SandPlotter(PVector startPos, color sandColor) {
    this.pos = startPos;
    this.sandColor = sandColor;
  }

  void move(PVector to) {
    pos = to.copy();
  }

  void plot(PVector to) {
    strokeWeight(constrain(3.0/pos.dist(to), 1, 3));
    stroke(lerpColor(get(round(pos.x), round(pos.y)), sandColor, 1.0/pos.dist(to)));
    line(pos.x, pos.y, to.x, to.y);
    pos = to.copy();
  }
}
