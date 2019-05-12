class Canvas
{
  PVector origin;
  float _width, _height;

  Canvas(float x0, float y0, int w, int h) {
    origin = new PVector(x0, y0);
    _width = w;
    _height = h;
  }

  Canvas(float x0, float y0, float x1, float y1) {
    origin = new PVector(x0, y0);
    _width = x1-x0;
    _height = y1-y0;
  }

  PVector getMidpoint() {
    return new PVector(origin.x + _width/2, origin.y + _height/2);
  }

  void drawAtLimits(PGraphics g) {
    g.rect(origin.x, origin.y, _width, _height);
  }

  void drawGradientAtLimits(PGraphics g, color[] colors) {    
    g.beginShape();
    
    g.fill(colors[0]);
    g.vertex(origin.x, origin.y);
    
    g.fill(colors[2]);
    g.vertex(origin.x+_width, origin.y);
    
    g.fill(colors[1]);
    g.vertex(origin.x+_width, origin.y+_height);
    
    g.fill(colors[3]);
    g.vertex(origin.x, origin.y+_height);
    
    g.endShape();
  }

  float getMinX() {
    return origin.x;
  }

  float getMaxX() {
    return origin.x+_width;
  }

  float getMinY() {
    return origin.y;
  }

  float getMaxY() {
    return origin.y+_height;
  }

  float suggestRadiusOfInfluece() {
    float minSide = min(_width, _height);
    float maxSide = min(width, height);

    return map(minSide, 100, maxSide, 4, 20);
  }

  float suggestRepulsionStrength() {
    float minSide = min(_width, _height);
    float maxSide = min(width, height);

    return map(minSide, 100, maxSide, 0.75, 1.5);
  }

  float suggestRestLength() {
    float minSide = min(_width, _height);
    float maxSide = min(width, height);

    return map(minSide, 100, maxSide, 1.5, 8);
  }

  float suggestPlanarFactor() {
    float minSide = min(_width, _height);
    float maxSide = min(width, height);

    return map(minSide, 100, maxSide, 0.1, 0.2);
  }

  float suggestSpringFactor() {
    float minSide = min(_width, _height);
    float maxSide = min(width, height);

    return map(minSide, 100, maxSide, 0.1, 1.0);
  }

  int suggestStartingNodes() {
    float minSide = min(_width, _height);
    float maxSide = min(width, height);

    return round(map(minSide, 100, maxSide, 45, 66));
  }

  int suggestFoodThreshold() {
    float minSide = min(_width, _height);
    float maxSide = min(width, height);

    return round(map(minSide, 100, maxSide, 3, 20));
  }
}
