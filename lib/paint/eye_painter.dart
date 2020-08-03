import 'dart:math';

import 'package:flutter/material.dart';

class EyePainter extends CustomPainter {
  EyePainter({@required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTWH(0, 0, size.width, size.height);
    final centerEye = Offset(shapeBounds.center.dx, shapeBounds.center.dy);

    final eyeBounds =
        Rect.fromCircle(center: centerEye, radius: size.width / 4);
    final eyeOuterBounds =
        Rect.fromCircle(center: centerEye, radius: size.width / 3);
    final eyeInnerBounds =
        Rect.fromCircle(center: centerEye, radius: size.width / 8);
    _drawBackground(
        canvas, shapeBounds, eyeBounds, eyeOuterBounds, eyeInnerBounds);
  }

  void _drawBackground(Canvas canvas, Rect shapeBounds, Rect eyeBounds,
      Rect eyeOuterBounds, Rect eyeInnerBounds) {
    final paint = Paint()..color = color;
    final paintSecondary = Paint()..color = color.withOpacity(.5);

    final backgroundPath = Path()
      ..moveTo(shapeBounds.left, shapeBounds.top)
      ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy)
      ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy)
      ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy)
      ..close();
    backgroundPath.addOval(eyeInnerBounds);
    backgroundPath.addOval(eyeOuterBounds);

    final backgroundOuterPath = Path();
    backgroundOuterPath.addOval(eyeBounds);
    canvas.drawPath(backgroundOuterPath, paintSecondary);
    canvas.drawPath(backgroundPath, paint);
  }

  @override
  bool shouldRepaint(EyePainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
