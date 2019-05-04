class Canvas {
  PVector origin;
  float _width, _height;

  Canvas(float x0, float y0, float w, float h) {
    origin = new PVector(x0, y0);
    _width = w;
    _height = h;
  }

  PVector getMidpoint() {
    return new PVector(origin.x + _width/2, origin.y + _height/2);
  }

  void drawAtLimits() {
    rect(origin.x, origin.y, _width, _height);
  }
}
