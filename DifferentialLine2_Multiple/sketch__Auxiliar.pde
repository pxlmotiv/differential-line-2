boolean DoLinesIntersect(PVector p0, PVector p1, PVector p2, PVector p3) {
  // Find the four orientations needed for general and 
  // special cases
  p0 = getPixelPerfectVector(p0);
  p1 = getPixelPerfectVector(p1);
  p2 = getPixelPerfectVector(p2);
  p3 = getPixelPerfectVector(p3);

  int o1 = orientation(p0, p1, p2);
  int o2 = orientation(p0, p1, p3);
  int o3 = orientation(p2, p3, p0); 
  int o4 = orientation(p2, p3, p1);

  if (o1 != o2 && o3 != o4) 
    return true; 

  // Special Cases 
  // p0, p1 and p2 are colinear and p2 lies on segment p0p1 
  if (o1 == 0 && onSegment(p0, p2, p1)) return true; 

  // p0, p1 and p3 are colinear and p3 lies on segment p0p1 
  if (o2 == 0 && onSegment(p0, p3, p1)) return true; 

  // p0, p2 and p3 are colinear and p1 lies on segment p2q2 
  if (o3 == 0 && onSegment(p2, p0, p3)) return true; 

  // p2, q2 and q1 are colinear and q1 lies on segment p2q2 
  if (o4 == 0 && onSegment(p2, p1, p3)) return true;  

  return false; // Doesn't fall in any of the above cases
}

// Given three colinear points p, q, r, the function checks if 
// point q lies on line segment 'pr' 
boolean onSegment(PVector p, PVector q, PVector r) 
{ 
  if (q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) && q.y <= max(p.y, r.y) && q.y >= min(p.y, r.y)) 
    return true; 

  return false;
} 

// To find orientation of ordered triplet (p, q, r). 
// The function returns following values 
// 0 --> p, q and r are colinear 
// 1 --> Clockwise 
// 2 --> Counterclockwise 
int orientation(PVector p, PVector q, PVector r) {
  // See https://www.geeksforgeeks.org/orientation-3-ordered-points/ 
  // for details of below formula. 
  float val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y); 

  if (val >= -0.5 && val <= 0.5) return 0;  // colinear 

  return (val > 0) ? 1: 2; // clock or counterclock wise
}

PVector getPixelPerfectVector(PVector vector) {
  int x = floor(vector.x);
  int y = floor(vector.y);
  int z = floor(vector.z);
  return new PVector(x, y, z);
}

float distSq(PVector p1, PVector p2)
{
  return (p2.y - p1.y)*(p2.y - p1.y)+(p2.x - p1.x)*(p2.x - p1.x);
}
