class Canvas {
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

  void drawAtLimits() {
    rect(origin.x, origin.y, _width, _height);
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
}
