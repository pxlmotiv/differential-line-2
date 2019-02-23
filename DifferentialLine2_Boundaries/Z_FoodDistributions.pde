void randomUniformDistribution() {
  for (int i = 0; i < system.cells.size(); i++) {
    Cell c = system.cells.get(i);      
    c.food += random(2);
  }
}

void byCurvature() {
  for (int i = 0; i < system.cells.size(); i++) {
    Cell c = system.cells.get(i);
    PVector link1 = PVector.sub(c.links.get(0).position, c.position);
    PVector link2 = PVector.sub(c.links.get(1).position, c.position);
    float a = PVector.angleBetween(link1, link2);
    if (a < 1)
      c.food += random(2, 4);
    else
      c.food += 0.5;
  }
}

void process() {

  for (int i = 0; i < system.cells.size(); i++) {
    Cell c = system.cells.get(i);      
    c.food += random(2);

    if (c.food >= c.foodThreshold) {
      int ri = floor(random(2));
      Cell n = c.links.get(ri);

      if (distSq(n.position, c.position) < (c.restLength * c.restLength) * 1.2) 
        continue;

      c.food = 0;
      c.removeLink(n);

      float x = c.position.x + (n.position.x - c.position.x);
      float y = c.position.y + (n.position.y - c.position.y);

      Cell newCell = new Cell(x, y, 0, c.foodThreshold);

      newCell.springFactor = system.springFactor;
      newCell.planarFactor = system.planarFactor;
      newCell.bulgeFactor = system.bulgeFactor;
      newCell.repulsionStrength = system.repulsionStrength;
      newCell.radiusOfInfluence = system.radiusOfInfluence;
      newCell.roiSq = system.radiusOfInfluence * system.radiusOfInfluence;
      newCell.restLength = system.restLength;

      newCell.addLink(n);
      newCell.addLink(c);

      system.cells.add(newCell);
    }

    c.updateTargets();
    c.updatePosition(system.boundary);
  }
}
