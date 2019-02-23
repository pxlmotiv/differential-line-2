abstract class Boundary {
  public abstract boolean checkCellWithin(Cell cell);
}

public class RectangularBoundary extends Boundary
{
  float minX, minY, maxX, maxY;
  
  RectangularBoundary(float _minX, float _minY, float _maxX, float _maxY) {
    minX = _minX;
    maxX = _maxX;
    minY = _minY;
    maxY = _maxY;
  }
  
  public boolean checkCellWithin(Cell cell) {
    return cell.position.x >= minX && cell.position.x <= maxX && cell.position.y >= minY && cell.position.y <= maxY;
  }
}

public class CircularBoundary extends Boundary
{
  float x, y, r;
  
  CircularBoundary(float _x, float _y, float _r) {
    x = _x;
    y = _y;
    r = _r;
  }
  
  public boolean checkCellWithin(Cell cell) {
    float dsq = distSq(cell.position, new PVector(x, y));
    return r*r >= dsq;
  }
}
