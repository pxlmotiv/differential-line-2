class QuadTree //<>//
{
  Rectangle rectangle;
  QuadTree parent;
  QuadTree northeast, northwest, southeast, southwest;
  QuadTree north, south, east, west;

  float capacity;
  ArrayList<Cell> cells;
  boolean divided;
  int level;

  public QuadTree(QuadTree _parent, Rectangle _boundary, float _capacity) {
    parent = _parent;
    rectangle = _boundary;
    capacity = _capacity;
    cells = new ArrayList<Cell>();
    divided = false;
    level = 0;
  }

  public void subdivide() {
    float x = this.rectangle.x;
    float y = this.rectangle.y;
    float w = this.rectangle.w;
    float h = this.rectangle.h;

    Rectangle ne = new Rectangle(x + w / 2, y - h / 2, w / 2, h / 2);
    this.northeast = new QuadTree(this, ne, this.capacity);
    this.northeast.level = this.level+1;

    Rectangle nw = new Rectangle(x - w / 2, y - h / 2, w / 2, h / 2);
    this.northwest = new QuadTree(this, nw, this.capacity);
    this.northwest.level = this.level+1;

    Rectangle se = new Rectangle(x + w / 2, y + h / 2, w / 2, h / 2);
    this.southeast = new QuadTree(this, se, this.capacity);
    this.southeast.level = this.level+1;

    Rectangle sw = new Rectangle(x - w / 2, y + h / 2, w / 2, h / 2);
    this.southwest = new QuadTree(this, sw, this.capacity);
    this.southwest.level = this.level+1;

    this.northeast.south = this.southeast;
    this.northeast.west = this.northwest;

    this.southeast.north = this.northeast;
    this.southeast.west = this.southwest;

    this.northwest.east = this.northeast;
    this.northwest.south = this.southwest;

    this.southwest.north = this.northwest;
    this.southwest.east = this.southeast;

    if (this.north != null) {
      this.northeast.north = this.north.southeast;
      this.northwest.north = this.north.southwest;
    }
    if (this.east != null) {
      this.northeast.east = this.east.northwest;
      this.southeast.east = this.east.southwest;
    }
    if (this.south != null) {
      this.southeast.south = this.south.northeast;
      this.southwest.south = this.south.northwest;
    }
    if (this.west != null) {
      this.northwest.west = this.west.northeast;
      this.southwest.west = this.west.southeast;
    }

    this.divided = true;
  }

  public boolean insert(Cell cell) {
    if (!rectangle.contains(cell.position))
      return false;
    if (cells.size() < capacity) {
      cells.add(cell);
      return true;
    } else {
      if (!divided)
        subdivide();

      if (northeast.insert(cell)) {
        return true;
      } else if (northwest.insert(cell)) {
        return true;
      } else if (southeast.insert(cell)) {
        return true;
      } else if (southwest.insert(cell)) {
        return true;
      }
    }
    return false;
  }

  public boolean findAndCalculateRepulsion(Cell cell) {
    if (!rectangle.contains(cell.position))
      return false;

    for (Cell candidate : cells) {
      if (candidate == cell && !candidate.repulsionChecked) {
        ArrayList<Cell> relevantCells = getRelevantCells(cell); //<>// //<>//

        PVector colOffset = cell.updateRepulsiveInfluence(relevantCells);

        if (!(colOffset.x == 0 && colOffset.y == 0)) 
          colOffset.mult(cell.repulsionStrength); //<>// //<>//

        cell.collisionOffset = colOffset;
        return true;
      }
    }

    if (northeast != null && northeast.findAndCalculateRepulsion(cell)) {
      return true;
    } else if (northwest != null && northwest.findAndCalculateRepulsion(cell)) {
      return true;
    } else if (southeast != null && southeast.findAndCalculateRepulsion(cell)) {
      return true;
    } else if (southwest != null && southwest.findAndCalculateRepulsion(cell)) {
      return true;
    }

    return false;
  }

  void show() {
    pushStyle();

    if (system.showGrid) {
      strokeWeight(1);
      stroke(0, 170, 225, 75);
    } else {
      noStroke();
    }
    noFill();
    rectMode(CENTER);
    rect(rectangle.x, rectangle.y, rectangle.w * 2, rectangle.h * 2);

    popStyle();

    if (this.divided) {
      this.northeast.show();
      this.northwest.show();
      this.southeast.show();
      this.southwest.show();
    }
  }

  private ArrayList<Cell> getRelevantCells(Cell cell)
  {
    ArrayList<Cell> relCells = new ArrayList<Cell>(); //<>// //<>//

    boolean foundBoundary = false;
    QuadTree q = this;

    while (!foundBoundary) {
      if (q.rectangle.contains(cell.position, cell.radiusOfInfluence)) {
        foundBoundary = true;
      } else {
        if (q.parent == null)
          return relCells;
        q = q.parent;
      }
    }
    
    if (q.parent != null) {
      relCells.addAll(q.parent.cells); //<>// //<>//
      relCells.addAll(q.parent.getChildrenCells());
    } else {
      relCells.addAll(q.cells);
      relCells.addAll(q.getChildrenCells());
    }

    return relCells;
  }

  private ArrayList<Cell> getChildrenCells() {
    ArrayList<Cell> relCells = new ArrayList<Cell>(); //<>// //<>//

    if (this.divided) {
      relCells.addAll(this.northeast.getChildrenCells());
      relCells.addAll(this.northwest.getChildrenCells());
      relCells.addAll(this.southeast.getChildrenCells());
      relCells.addAll(this.southwest.getChildrenCells());
    }

    return relCells;
  }

  private ArrayList<Cell> getRelevantCells()
  {
    ArrayList<Cell> relCells = new ArrayList<Cell>();

    relCells.addAll(this.cells);

    if (this.parent != null) {
      for (Cell c : this.parent.cells) {
        if (relCells.contains(c))continue;
        relCells.add(c);
      }
    }

    if (this.north != null) {
      for (Cell c : this.north.cells) {
        if (relCells.contains(c))continue;
        relCells.add(c);
      }
      //relCells.addAll(this.north.cells);
      if (this.north.east != null) {
        for (Cell c : this.north.east.cells) {
          if (relCells.contains(c))continue;
          relCells.add(c);
        }
        relCells.addAll(this.north.east.cells);
      }
      if (this.north.west != null) {
        for (Cell c : this.north.west.cells) {
          if (relCells.contains(c))continue;
          relCells.add(c);
        }
        //relCells.addAll(this.north.west.cells);
      }
    }

    if (this.south != null) {
      for (Cell c : this.south.cells) {
        if (relCells.contains(c))continue;
        relCells.add(c);
      }
      //relCells.addAll(this.north.cells);
      if (this.south.east != null) {
        for (Cell c : this.south.east.cells) {
          if (relCells.contains(c))continue;
          relCells.add(c);
        }
        relCells.addAll(this.south.east.cells);
      }
      if (this.south.west != null) {
        for (Cell c : this.south.west.cells) {
          if (relCells.contains(c))continue;
          relCells.add(c);
        }
        //relCells.addAll(this.north.west.cells);
      }
    }

    if (this.east != null) {
      for (Cell c : this.east.cells) {
        if (relCells.contains(c))continue;
        relCells.add(c);
      }
      //relCells.addAll(this.east.cells);
    }

    if (this.west != null) {    
      for (Cell c : this.west.cells) {
        if (relCells.contains(c))continue;
        relCells.add(c);
      }
      //relCells.addAll(this.west.cells);
    }

    return relCells;
  }
}

class Rectangle 
{
  float x, y, w, h;

  public Rectangle(float _x, float _y, float _w, float _h) 
  {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }

  public boolean contains(PVector point) 
  {
    return (point.x >= this.x - this.w &&
      point.x <= this.x + this.w &&
      point.y >= this.y - this.h &&
      point.y <= this.y + this.h);
  }

  public boolean contains(PVector point, float influence) 
  {
    return (point.x - influence >= this.x - this.w &&
      point.x + influence <= this.x + this.w &&
      point.y - influence >= this.y - this.h &&
      point.y + influence <= this.y + this.h);
  }

  public boolean intersects(Rectangle range) 
  {
    return !(range.x - range.w > this.x + this.w ||
      range.x + range.w < this.x - this.w ||
      range.y - range.h > this.y + this.h ||
      range.y + range.h < this.y - this.h);
  }
}
