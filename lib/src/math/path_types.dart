enum PathFillRule {
  nonZero,
  evenOdd,
}

enum PathDirection {
  clockwise,
  counterclockwise,
}

enum PathVerb {
  move,
  line,
  quad,
  conicUnused, // so we match skia's order
  cubic,
  close,
}

abstract class PathInterface {
  void moveTo(double x, double y);
  void lineTo(double x, double y);
  void cubicTo(double ox, double oy, double ix, double iy, double x, double y);
  void close();
}
