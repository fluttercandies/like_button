import 'package:flutter/material.dart';
import 'package:like_button/src/utils/like_button_model.dart';
import 'package:like_button/src/utils/like_button_util.dart';

///
///  create by zmtzawqlp on 2019/5/27
///

class CirclePainter extends CustomPainter {
  CirclePainter(
      {required this.outerCircleRadiusProgress,
      required this.innerCircleRadiusProgress,
      this.circleColor = const CircleColor(
          start: Color(0xFFFF5722), end: Color(0xFFFFC107))}) {
    //circlePaint..style = PaintingStyle.fill;
    _circlePaint.style = PaintingStyle.stroke;
    //maskPaint..blendMode = BlendMode.clear;
  }
  final Paint _circlePaint = Paint();
  //Paint maskPaint = new Paint();

  final double outerCircleRadiusProgress;
  final double innerCircleRadiusProgress;
  final CircleColor circleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width * 0.5;
    _updateCircleColor();
    // canvas.saveLayer(Offset.zero & size, Paint());
    // canvas.drawCircle(Offset(center, center),
    //     outerCircleRadiusProgress * center, circlePaint);
    // canvas.drawCircle(Offset(center, center),
    //     innerCircleRadiusProgress * center + 1, maskPaint);
    // canvas.restore();
    //flutter web don't support BlendMode.clear.
    final double strokeWidth = outerCircleRadiusProgress * center -
        (innerCircleRadiusProgress * center);
    if (strokeWidth > 0.0) {
      _circlePaint.strokeWidth = strokeWidth;
      canvas.drawCircle(Offset(center, center),
          outerCircleRadiusProgress * center, _circlePaint);
    }
  }

  void _updateCircleColor() {
    double colorProgress = clamp(outerCircleRadiusProgress, 0.5, 1.0);
    colorProgress = mapValueFromRangeToRange(colorProgress, 0.5, 1.0, 0.0, 1.0);
    _circlePaint.color =
        Color.lerp(circleColor.start, circleColor.end, colorProgress)!;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is CirclePainter &&
        (oldDelegate.outerCircleRadiusProgress != outerCircleRadiusProgress ||
            oldDelegate.innerCircleRadiusProgress !=
                innerCircleRadiusProgress ||
            oldDelegate.circleColor.start != circleColor.start ||
            oldDelegate.circleColor.end != circleColor.end);
  }
}
