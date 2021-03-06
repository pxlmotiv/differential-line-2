abstract class Boundary
{
  public abstract boolean checkCellWithin(Cell cell, PVector target);
}

public class RectangularBoundary extends Boundary
{
  float minX, minY, maxX, maxY;

  RectangularBoundary(float _minX, float _minY, float _maxX, float _maxY)
  {
    minX = _minX;
    maxX = _maxX;
    minY = _minY;
    maxY = _maxY;
  }

  public boolean checkCellWithin(Cell cell, PVector target)
  {
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

  public boolean checkCellWithin(Cell cell, PVector target)
  {
    float dsq = distSq(cell.position, new PVector(x, y));
    return r*r >= dsq;
  }
}

public class RomboidBoundary extends Boundary
{
  PVector top, right, bottom, left;

  RomboidBoundary(float x0, float y0, float x1, float y1, float x2, float y2)
  {
    top = new PVector(x1, y0);
    right = new PVector(x2, y1);
    bottom = new PVector(x1, y2);
    left = new PVector(x0, y1);
  }

  public boolean checkCellWithin(Cell cell, PVector target)
  {
    PVector newPos = PVector.add(cell.position, target);

    boolean touchedTopRight = DoLinesIntersect(top, right, cell.position, newPos);
    boolean touchedBottomRight = DoLinesIntersect(right, bottom, cell.position, newPos);
    boolean touchedBottomLeft = DoLinesIntersect(bottom, left, cell.position, newPos);
    boolean touchedTopLeft = DoLinesIntersect(left, top, cell.position, newPos);

    return !touchedTopRight && !touchedBottomRight && !touchedBottomLeft && !touchedTopLeft;
  }
}

public class TriangularBoundary extends Boundary
{
  PVector p0, p1, p2;

  TriangularBoundary(float startX, float startY, float s)
  {
    float offset = HALF_PI;
    float x0 = (cos(float(0) / 3 * TWO_PI + offset) * s) + startX;
    float y0 = (sin(float(0) / 3 * TWO_PI + offset) * s) + startY;
    float x1 = (cos(float(1) / 3 * TWO_PI + offset) * s) + startX;
    float y1 = (sin(float(1) / 3 * TWO_PI + offset) * s) + startY;
    float x2 = (cos(float(2) / 3 * TWO_PI + offset) * s) + startX;
    float y2 = (sin(float(2) / 3 * TWO_PI + offset) * s) + startY;
    p0 = new PVector(x0, y0);
    p1 = new PVector(x1, y1);
    p2 = new PVector(x2, y2);
  }

  public boolean checkCellWithin(Cell cell, PVector target)
  {
    PVector newPos = PVector.add(cell.position, target);

    boolean touchedp0 = DoLinesIntersect(p0, p1, cell.position, newPos);
    boolean touchedp1 = DoLinesIntersect(p1, p2, cell.position, newPos);
    boolean touchedp2 = DoLinesIntersect(p2, p0, cell.position, newPos);

    return !touchedp0 && !touchedp1 && !touchedp2;
  }
}

public class RandomLinesBoundary extends Boundary
{ 
  ArrayList<PVector> vertices;
  int amountOfLines = 12;

  RandomLinesBoundary()
  {
    vertices = new ArrayList<PVector>();

    for (int i = 0; i < amountOfLines; i++)
    {
      vertices.add(new PVector(random(width), random(height)));
    }
  }

  public boolean checkCellWithin(Cell cell, PVector target)
  {
    PVector newPos = PVector.add(cell.position, target);

    for (int i = 0; i < amountOfLines; i+=2) {
      boolean res = DoLinesIntersect(vertices.get(i), vertices.get(i+1), cell.position, newPos);

      if (res)
        return false;
    }

    return true;
  }
}
