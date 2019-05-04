ArrayList<Cell> arrangeInSpikes(System system) //<>//
{
  int n = system.arrangementSettings.n;
  float s = system.arrangementSettings.s;
  float food = system.arrangementSettings.food;
  float threshold = system.arrangementSettings.threshold;

  ArrayList<Cell> cells = new ArrayList<Cell>();

  for (int i = 0; i < n; i++) {
    float rs = i % 2 == 0 ? s * 1.5 : s * 0.5;
    float x = (cos(float(i) / n * TWO_PI) * rs) + start.x;
    float y = (sin(float(i) / n * TWO_PI) * rs) + start.y;
    Cell c = new Cell(x, y, food, threshold);
    c.springFactor = system.springFactor;
    c.planarFactor = system.planarFactor;
    c.bulgeFactor = system.bulgeFactor;
    c.repulsionStrength = system.repulsionStrength;
    c.radiusOfInfluence = system.radiusOfInfluence;
    c.roiSq = system.radiusOfInfluence * system.radiusOfInfluence;
    c.restLength = system.restLength;
    c.id = i;

    if (i > 0) {
      Cell link = cells.get(i-1);
      c.addLink(link);
    }
    cells.add(c);
    system.lastId = c.id;
  }

  Cell last = cells.get(n-1);
  last.addLink(cells.get(0));

  return cells;
}

ArrayList<Cell> arrangeInCircle(System system)
{
  int n = system.arrangementSettings.n;
  float s = system.arrangementSettings.s;
  float food = system.arrangementSettings.food;
  float threshold = system.arrangementSettings.threshold;

  ArrayList<Cell> cells = new ArrayList<Cell>();

  for (int i = 0; i < n; i++) {
    float x = (cos(float(i) / n * TWO_PI) * s) + start.x;
    float y = (sin(float(i) / n * TWO_PI) * s) + start.y;
    Cell c = new Cell(x, y, food, threshold);
    c.id = i;
    c.springFactor = system.springFactor;
    c.planarFactor = system.planarFactor;
    c.bulgeFactor = system.bulgeFactor;
    c.repulsionStrength = system.repulsionStrength;
    c.radiusOfInfluence = system.radiusOfInfluence;
    c.roiSq = system.radiusOfInfluence * system.radiusOfInfluence;
    c.restLength = system.restLength;

    if (i > 0) {
      Cell link = cells.get(i-1);
      c.addLink(link);
    } 
    cells.add(c);
    system.lastId = c.id;
  }

  Cell first = cells.get(0);
  first.addLink(cells.get(n-1));

  return cells;
}

class ArrangementSettings {
  int n;
  float s, food, threshold;

  ArrangementSettings(int _n, float _s, float _food, float _threshold) {
    n = _n;
    s = _s;
    food = _food;
    threshold = _threshold;
  }
}
