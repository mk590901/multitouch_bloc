
import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  List<Offset>? points;
  Map<int, List<Offset>> hash;
  Map<int, Path> hashPathMap = <int, Path>{};
  Path path = Path();

  Map<int, Offset> hashLastPoint = <int, Offset>{};
  Map<int, Offset> hashFirstPoint = <int, Offset>{};

  final paintCircle = Paint()
    ..color = Colors.deepPurpleAccent
    ..style = PaintingStyle.fill;

  final paintShape = Paint()
    ..color = Colors.red //.orange
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.0;

  static const markerRadius = 8.0;

  List<int> getKeys() {
    List<int> result = <int>[];
    hash.forEach((k, v) => result.add(k));
    return result;
  }

  PathPainter.hash(this.hash) {
    if (hash.isEmpty) {
      return;
    }
    hashPathMap.clear();
    hashLastPoint.clear();
    hashFirstPoint.clear();
    List<int> keys = getKeys();
    for (int i = 0; i < keys.length; i++) {
      List<Offset>? hashPoints = hash[keys[i]];
      Path hashPath = Path();
      Offset origin = hashPoints![0];
      hashPath.moveTo(origin.dx, origin.dy);
      for (Offset o in hashPoints) {
        hashPath.lineTo(o.dx, o.dy);
      }
      hashPathMap[keys[i]] = hashPath;
      hashLastPoint[keys[i]] = hashPoints[hashPoints.length - 1];
      hashFirstPoint[keys[i]] = hashPoints[0];
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    double width = size.width;



    // canvas.drawLine(
    //     const Offset(0.0, 0.0), Offset(width, height), paintShape);

    List<int> keys = getKeys();
    for (int i = 0; i < keys.length; i++) {
      Path? hashPath = hashPathMap[keys[i]];
      if (hashPath != null) {
        canvas.drawPath(
          hashPath,
          paintShape,
        );
      }

      Offset? point = hashLastPoint[keys[i]];
      canvas.drawCircle(point!, markerRadius, paintCircle);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true; // todo - determine if the path has changed
  }
}
