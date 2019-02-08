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
    if(a < 1)
      c.food += random(2, 4);
    else
      c.food += 0.5;
  }
}
