void splitRandomLink(System system) {
  int cellsAdded = 0;
  
  for (int i = 0; i < system.amountOfCells; i++) {
    Cell c = system.cells.get(i);
    
    if (c.hasReachedBorder) continue;
    
    if (c.food >= c.foodThreshold) {
      int ri = floor(random(2));
      Cell n = c.links.get(ri);

      if (distSq(n.position, c.position) < (c.restLength * c.restLength) * 1.2) 
        continue;

      c.food = 0;

      float x = c.position.x + (n.position.x - c.position.x);
      float y = c.position.y + (n.position.y - c.position.y);

      Cell newCell = new Cell(x, y, 0, c.foodThreshold, system);
      system.lastId++;
      newCell.id = system.lastId;
      newCell.springFactor = system.springFactor;
      newCell.planarFactor = system.planarFactor;
      newCell.bulgeFactor = system.bulgeFactor;
      newCell.repulsionStrength = system.repulsionStrength;
      newCell.radiusOfInfluence = system.radiusOfInfluence;
      newCell.roiSq = system.radiusOfInfluence * system.radiusOfInfluence;
      newCell.restLength = system.restLength;

      c.removeLink(n);
      newCell.addLink(c);
      newCell.addLink(n);

      system.cells.add(newCell);
      cellsAdded++;
    }
  }
  
  system.amountOfCells += cellsAdded;
}

void splitByCurvature(System system) {
  int cellsAdded = 0;
  
  for (int i = 0; i < system.amountOfCells; i++) {
    Cell c = system.cells.get(i);

    if (c.hasReachedBorder) continue;

    if (c.food >= c.foodThreshold) {
      Cell l1 = c.links.get(0);
      Cell l2 = c.links.get(1);
      PVector link1 = PVector.sub(l1.position, c.position);
      PVector link2 = PVector.sub(l2.position, c.position);
      float a = PVector.angleBetween(link1, link2);
      float d1 = dist(l1.position.x, l1.position.y, c.position.x, c.position.y);
      float d2 = dist(l2.position.x, l2.position.y, c.position.x, c.position.y);

      if (((a >= 2.63) || d1 < c.restLength || d2 < c.restLength))
        continue;

      Cell n = d1 >= d2 ? l1 : l2;

      c.food = 0;
      c.removeLink(n);

      float x = c.position.x + (n.position.x - c.position.x);
      float y = c.position.y + (n.position.y - c.position.y);

      Cell newCell = new Cell(x, y, 0, c.foodThreshold, system);
      system.lastId++;
      newCell.id = system.lastId;
      newCell.springFactor = system.springFactor;
      newCell.planarFactor = system.planarFactor;
      newCell.bulgeFactor = system.bulgeFactor;
      newCell.repulsionStrength = system.repulsionStrength;
      newCell.radiusOfInfluence = system.radiusOfInfluence;
      newCell.roiSq = system.radiusOfInfluence * system.radiusOfInfluence;
      newCell.restLength = system.restLength;

      newCell.addLink(c);
      newCell.addLink(n);      

      system.cells.add(newCell);
      cellsAdded++;
    }
  }
  
  system.amountOfCells += cellsAdded;
}
