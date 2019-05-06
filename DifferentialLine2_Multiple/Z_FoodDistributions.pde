void randomUniformDistribution(System system) {
  for (int i = 0; i < system.amountOfCells; i++) {
    Cell c = system.cells.get(i);

    if (!c.hasReachedBorder && !c.links.get(0).hasReachedBorder && !c.links.get(1).hasReachedBorder)
      c.food += random(2);
  }
}

void byCurvature(System system) {
  for (int i = 0; i < system.amountOfCells; i++) {
    Cell c = system.cells.get(i);

    if (c.hasReachedBorder && !c.links.get(0).hasReachedBorder && !c.links.get(1).hasReachedBorder)
      continue;

    PVector link1 = PVector.sub(c.links.get(0).position, c.position);
    PVector link2 = PVector.sub(c.links.get(1).position, c.position);
    float a = PVector.angleBetween(link1, link2);

    if (a < 1)
      c.food += random(1, 5);
    else
      c.food += 0.5;
  }
}
