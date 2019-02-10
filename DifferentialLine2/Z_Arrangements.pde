ArrayList<Cell> arrangeInSpikes(System system)
{
  int n = 12;
  float s = system.restLength * 2;
  float food = 0;
  float threshold = 80;

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
    
    if (i > 0) {
      Cell link = cells.get(i-1);
      c.addLink(link);
    }
    cells.add(c);
  }

  Cell last = cells.get(n-1);
  last.addLink(cells.get(0));

  return cells; //<>//
}

ArrayList<Cell> arrangeInCircle(System system)
{
  int n = 32;
  float s = system.restLength * 2;
  float food = 0;
  float threshold = 50;

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
  }

  Cell last = cells.get(n-1);
  last.addLink(cells.get(0));

  return cells;
}
