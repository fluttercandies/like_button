import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:like_button/src/utils/like_button_util.dart';

///
///  create by zmtzawqlp on 2019/5/27
///

class BubblesPainter extends CustomPainter {
  BubblesPainter({
    required this.currentProgress,
    this.bubblesCount = 7,
    this.color1 = const Color(0xFFFFC107),
    this.color2 = const Color(0xFFFF9800),
    this.color3 = const Color(0xFFFF5722),
    this.color4 = const Color(0xFFF44336),
  }) {
    _outerBubblesPositionAngle = 360.0 / bubblesCount;
    for (int i = 0; i < 4; i++) {
      _circlePaints.add(Paint()..style = PaintingStyle.fill);
    }
  }
  final double currentProgress;
  final int bubblesCount;
  final Color color1;
  final Color color2;
  final Color color3;
  final Color color4;

  double _outerBubblesPositionAngle = 51.42;
  double _centerX = 0.0;
  double _centerY = 0.0;
  final List<Paint> _circlePaints = <Paint>[];

  double _maxOuterDotsRadius = 0.0;
  double _maxInnerDotsRadius = 0.0;
  double? _maxDotSize;

  double _currentRadius1 = 0.0;
  double? _currentDotSize1 = 0.0;
  double? _currentDotSize2 = 0.0;
  double _currentRadius2 = 0.0;

  @override
  void paint(Canvas canvas, Size size) {
    _centerX = size.width * 0.5;
    _centerY = size.height * 0.5;
    _maxDotSize = size.width * 0.05;
    _maxOuterDotsRadius = size.width * 0.5 - _maxDotSize! * 2;
    _maxInnerDotsRadius = 0.8 * _maxOuterDotsRadius;

    _updateOuterBubblesPosition();
    _updateInnerBubblesPosition();
    _updateBubblesPaints();
    _drawOuterBubblesFrame(canvas);
    _drawInnerBubblesFrame(canvas);
  }

  void _drawOuterBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0;
    for (int i = 0; i < bubblesCount; i++) {
      final double cX = _centerX +
          _currentRadius1 *
              math.cos(degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY +
          _currentRadius1 *
              math.sin(degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize1!,
          _circlePaints[i % _circlePaints.length]);
    }
  }

  void _drawInnerBubblesFrame(Canvas canvas) {
    final double start = _outerBubblesPositionAngle / 4.0 * 3.0 -
        _outerBubblesPositionAngle / 2.0;
    for (int i = 0; i < bubblesCount; i++) {
      final double cX = _centerX +
          _currentRadius2 *
              math.cos(degToRad(start + _outerBubblesPositionAngle * i));
      final double cY = _centerY +
          _currentRadius2 *
              math.sin(degToRad(start + _outerBubblesPositionAngle * i));
      canvas.drawCircle(Offset(cX, cY), _currentDotSize2!,
          _circlePaints[(i + 1) % _circlePaints.length]);
    }
  }

  void _updateOuterBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius1 = mapValueFromRangeToRange(
          currentProgress, 0.0, 0.3, 0.0, _maxOuterDotsRadius * 0.8);
    } else {
      _currentRadius1 = mapValueFromRangeToRange(currentProgress, 0.3, 1.0,
          0.8 * _maxOuterDotsRadius, _maxOuterDotsRadius);
    }
    if (currentProgress == 0) {
      _currentDotSize1 = 0;
    } else if (currentProgress < 0.7) {
      _currentDotSize1 = _maxDotSize;
    } else {
      _currentDotSize1 = mapValueFromRangeToRange(
          currentProgress, 0.7, 1.0, _maxDotSize!, 0.0);
    }
  }

  void _updateInnerBubblesPosition() {
    if (currentProgress < 0.3) {
      _currentRadius2 = mapValueFromRangeToRange(
          currentProgress, 0.0, 0.3, 0.0, _maxInnerDotsRadius);
    } else {
      _currentRadius2 = _maxInnerDotsRadius;
    }
    if (currentProgress == 0) {
      _currentDotSize2 = 0;
    } else if (currentProgress < 0.2) {
      _currentDotSize2 = _maxDotSize;
    } else if (currentProgress < 0.5) {
      _currentDotSize2 = mapValueFromRangeToRange(
          currentProgress, 0.2, 0.5, _maxDotSize!, 0.3 * _maxDotSize!);
    } else {
      _currentDotSize2 = mapValueFromRangeToRange(
          currentProgress, 0.5, 1.0, _maxDotSize! * 0.3, 0.0);
    }
  }

  void _updateBubblesPaints() {
    final double progress = clamp(currentProgress, 0.6, 1.0);
    final int alpha =
        mapValueFromRangeToRange(progress, 0.6, 1.0, 255.0, 0.0).toInt();
    if (currentProgress < 0.5) {
      final double progress =
          mapValueFromRangeToRange(currentProgress, 0.0, 0.5, 0.0, 1.0);
      _circlePaints[0].color =
          Color.lerp(color1, color2, progress)!.withAlpha(alpha);
      _circlePaints[1].color =
          Color.lerp(color2, color3, progress)!.withAlpha(alpha);
      _circlePaints[2].color =
          Color.lerp(color3, color4, progress)!.withAlpha(alpha);
      _circlePaints[3].color =
          Color.lerp(color4, color1, progress)!.withAlpha(alpha);
    } else {
      final double progress =
          mapValueFromRangeToRange(currentProgress, 0.5, 1.0, 0.0, 1.0);
      _circlePaints[0].color =
          Color.lerp(color2, color3, progress)!.withAlpha(alpha);
      _circlePaints[1].color =
          Color.lerp(color3, color4, progress)!.withAlpha(alpha);
      _circlePaints[2].color =
          Color.lerp(color4, color1, progress)!.withAlpha(alpha);
      _circlePaints[3].color =
          Color.lerp(color1, color2, progress)!.withAlpha(alpha);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is BubblesPainter &&
        (oldDelegate.bubblesCount != bubblesCount ||
            oldDelegate.currentProgress != currentProgress ||
            oldDelegate.color1 != color1 ||
            oldDelegate.color2 != color2 ||
            oldDelegate.color3 != color3 ||
            oldDelegate.color4 != color4);
  }
}
