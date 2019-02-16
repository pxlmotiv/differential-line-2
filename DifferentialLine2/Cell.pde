class Cell //<>//
{
  PVector position;
  float food, foodThreshold;
  float springFactor, planarFactor, bulgeFactor, repulsionStrength, radiusOfInfluence, restLength, roiSq;
  PVector springTarget, planarTarget, bulgeTarget, collisionOffset;
  ArrayList<Cell> links;
  boolean repulsionChecked, hasBeenDrawn;
  int id;

  Cell(float x, float y, float _food, float threshold) {
    position = new PVector(x, y);
    food = _food;
    foodThreshold = threshold;
    springTarget = planarTarget = bulgeTarget = collisionOffset = new PVector(0, 0);
    repulsionChecked = hasBeenDrawn = false;
    links = new ArrayList<Cell>();
    id = -1;
  }

  void updateTargets() {
    hasBeenDrawn = false; // Reset flag

    springTarget = updateSpringTarget();
    planarTarget = updatePlanarTarget();
    //bulgeTarget = updateBulgeTarget();
    collisionOffset = updateRepulsiveInfluence(); //Updated by the QUADTREE

    if (!(springTarget.x == 0 && springTarget.y == 0)) springTarget.sub(position).mult(springFactor);
    if (!(planarTarget.x == 0 && planarTarget.y == 0)) planarTarget.sub(position).mult(planarFactor);
    //if (!(bulgeTarget.x == 0 && bulgeTarget.y == 0)) bulgeTarget.sub(position).mult(bulgeFactor);
    if (!(collisionOffset.x == 0 && collisionOffset.y == 0)) collisionOffset.mult(repulsionStrength); //Updated by the QUADTREE
  }

  void updatePosition() {
    if (!(springTarget.x == 0 && springTarget.y == 0)) position.add(springTarget);
    if (!(planarTarget.x == 0 && planarTarget.y == 0)) position.add(planarTarget);
    //if (!(bulgeTarget.x == 0 && bulgeTarget.y == 0)) position.add(bulgeTarget);
    if (!(collisionOffset.x == 0 && collisionOffset.y == 0)) position.add(collisionOffset);

    repulsionChecked = false;
  }

  void draw() {
    pushStyle();
    strokeWeight(2);
    stroke(0);
    for (int i = 0; i < links.size(); i++) {
      Cell link = links.get(i);
      if (!link.hasBeenDrawn)
        line(position.x, position.y, link.position.x, link.position.y);
    }
    //ellipse(position.x, position.y, 3, 3);
    popStyle();
    hasBeenDrawn = true; // flag to avoid drawing links twice
  }

  void addLink(Cell c) {
    links.add(c);
    c.links.add(this);
  }

  void removeLink(Cell c) {
    links.remove(c);
    c.links.remove(this);
  }

  private PVector updateSpringTarget() {
    int s = this.links.size();

    if (s == 0) 
      return new PVector(0, 0);

    PVector sum = new PVector(0, 0);

    for (int i = 0; i < s; i++) {
      Cell linkedCell = this.links.get(i);
      PVector v = PVector.sub(position, linkedCell.position).normalize().mult(restLength);
      v.add(linkedCell.position);
      sum.add(v);
    }

    return sum.div(s);
  }

  private PVector updatePlanarTarget() {
    int s = this.links.size();

    if (s == 0) 
      return new PVector(0, 0);

    float totalX = 0.0;
    float totalY = 0.0;

    for (int i = 0; i < s; i++) {
      Cell linkedCell = this.links.get(i);
      totalX += linkedCell.position.x;
      totalY += linkedCell.position.y;
    }

    return new PVector(totalX/float(s), totalY/float(s));
  }

  private PVector updateBulgeTarget() { // still not implemented since it doesn't seem it would impact too much.
    return new PVector(0, 0);
  }

  private PVector updateRepulsiveInfluence() {
    int s = system.cells.size();

    PVector sum =  new PVector(0, 0);

    if (s == 0) 
      return sum;

    for (int i = 0; i < s; i++) {
      Cell tCell = system.cells.get(i);

      if ((tCell == this || tCell == this.links.get(0) || tCell == this.links.get(1)) || (distSq(position, tCell.position) > roiSq))
        continue; 

      PVector diff = PVector.sub(position, tCell.position);
      float f = (roiSq - diff.magSq()) / roiSq;
      PVector offset = diff.normalize().mult(f);

      sum.add(offset);

      if (system.showGrid) {
        pushStyle();
        strokeWeight(1);
        stroke(255, 50, 50, 64);
        line(position.x, position.y, tCell.position.x, tCell.position.y);
        popStyle();
      }
    }

    return sum;
  }

  PVector updateRepulsiveInfluence(ArrayList<Cell> cells) {
    int s = cells.size();

    PVector sum =  new PVector(0, 0);

    if (s == 0) 
      return sum;

    for (int i = 0; i < s; i++) {
      Cell tCell = cells.get(i);

      if ((tCell == this || tCell == this.links.get(0) || tCell == this.links.get(1)) || (dist(position.x, position.y, tCell.position.x, tCell.position.y) > radiusOfInfluence))
        continue; 

      PVector diff = PVector.sub(position, tCell.position);
      float roiSq = radiusOfInfluence * radiusOfInfluence;
      float f = (roiSq - diff.magSq()) / roiSq;
      PVector offset = diff.normalize().mult(f);

      sum.add(offset);
    }

    return sum;
  }
}
