import 'package:flutter/material.dart';

///
///  create by zmtzawqlp on 2019/5/27
///

class DotColor {
  final Color dotPrimaryColor;
  final Color dotSecondaryColor;
  final Color dotThirdColor;
  final Color dotLastColor;

  const DotColor({
    @required this.dotPrimaryColor,
    @required this.dotSecondaryColor,
    this.dotThirdColor,
    this.dotLastColor,
  });

  Color get dotThirdColorReal =>
      dotThirdColor == null ? dotPrimaryColor : dotThirdColor;

  Color get dotLastColorReal =>
      dotLastColor == null ? dotSecondaryColor : dotLastColor;
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
