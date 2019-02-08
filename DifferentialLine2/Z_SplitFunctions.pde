void splitRandomLink() {
  
  for (int i = 0; i < system.cells.size(); i++) {
    Cell c = system.cells.get(i);

    if (c.food >= c.foodThreshold) {
      int ri = floor(random(2));
      Cell n = c.links.get(ri);

      if (dist(n.position.x, n.position.y, c.position.x, c.position.y) < c.restLength * 1.2) 
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
      newCell.radioOfInfluence = system.radioOfInfluence;
      newCell.restLength = system.restLength;

      newCell.addLink(n);
      newCell.addLink(c);

      system.cells.add(newCell);
    }
  }
  
}

void splitByCurvature() {
  for (int i = 0; i < system.cells.size(); i++) {
    Cell c = system.cells.get(i);

    if (c.food >= c.foodThreshold) {
      Cell l1 = c.links.get(0);
      Cell l2 = c.links.get(1);
      PVector link1 = PVector.sub(l1.position, c.position);
      PVector link2 = PVector.sub(l2.position, c.position);
      float a = PVector.angleBetween(link1, link2);
      float d1 = dist(l1.position.x, l1.position.y, c.position.x, c.position.y);
      float d2 = dist(l2.position.x, l2.position.y, c.position.x, c.position.y);

      if ((a >= 1) || d1 < c.restLength || d2 < c.restLength || random(1) < 0.1) 
        continue;
      
      Cell n = d1 >= d2 ? l1 : l2;
      
      c.food = 0;
      c.removeLink(n);

      float x = c.position.x + (n.position.x - c.position.x);
      float y = c.position.y + (n.position.y - c.position.y);

      Cell newCell = new Cell(x, y, 0, c.foodThreshold);
      newCell.springFactor = system.springFactor;
      newCell.planarFactor = system.planarFactor;
      newCell.bulgeFactor = system.bulgeFactor;
      newCell.repulsionStrength = system.repulsionStrength;
      newCell.radioOfInfluence = system.radioOfInfluence;
      newCell.restLength = system.restLength;

      newCell.addLink(n);
      newCell.addLink(c);

      system.cells.add(c);
    }
  }
}
