import 'package:flutter/material.dart';

///
///  create by zmtzawqlp on 2019/5/27
///

class BubblesColor {
  const BubblesColor({
    @required this.dotPrimaryColor,
    @required this.dotSecondaryColor,
    this.dotThirdColor,
    this.dotLastColor,
  });
  final Color dotPrimaryColor;
  final Color dotSecondaryColor;
  final Color dotThirdColor;
  final Color dotLastColor;
  Color get dotThirdColorReal => dotThirdColor ?? dotPrimaryColor;

  Color get dotLastColorReal => dotLastColor ?? dotSecondaryColor;
}

class CircleColor {
  const CircleColor({
    @required this.start,
    @required this.end,
  });
  final Color start;
  final Color end;
  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CircleColor && start == other.start && end == other.end;
  }

  @override
  int get hashCode => hashValues(start, end);
}

class OvershootCurve extends Curve {
  const OvershootCurve([this.period = 2.5]);

  final double period;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }

  @override
  String toString() {
    return '$runtimeType($period)';
  }
}

class LikeCountClip extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Offset.zero & size;
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
