///
///  create by zmtzawqlp on 2019/5/27
///

import 'package:flutter/material.dart';
import 'package:like_button/src/painter/circle_painter.dart';
import 'package:like_button/src/painter/dot_painter.dart';
import 'package:like_button/src/utils/like_button_model.dart';
import 'package:like_button/src/utils/like_button_typedef.dart';
import 'package:like_button/src/utils/like_button_util.dart';

class LikeButton extends StatefulWidget {
  final double size;
  final double dotSize;
  final double circleSize;
  //final LikeIcon icon;
  final Duration duration;
  final DotColor dotColor;
  final Color circleStartColor;
  final Color circleEndColor;
  final LikeCallback onIconClicked;
  final bool isLiked;
  final int likeCount;
  final Color countColor;
  final MainAxisAlignment mainAxisAlignment;
  final StateChanged builder;
  const LikeButton({
    Key key,
    @required this.size,
    this.builder,
    double dotSize,
    double circleSize,
    this.likeCount: 0,
    this.countColor,
    this.isLiked: false,
    this.mainAxisAlignment: MainAxisAlignment.center,
    this.duration = const Duration(milliseconds: 1000),
    this.dotColor = const DotColor(
      dotPrimaryColor: const Color(0xFFFFC107),
      dotSecondaryColor: const Color(0xFFFF9800),
      dotThirdColor: const Color(0xFFFF5722),
      dotLastColor: const Color(0xFFF44336),
    ),
    this.circleStartColor = const Color(0xFFFF5722),
    this.circleEndColor = const Color(0xFFFFC107),
    this.onIconClicked,
  })  : assert(size != null),
        dotSize = dotSize ?? size * 2.0,
        circleSize = circleSize ?? size * 0.8,
        super(key: key);

  @override
  State<StatefulWidget> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> outerCircle;
  Animation<double> innerCircle;
  Animation<double> scale;
  Animation<double> dots;

  bool _isLiked = false;
  int _likeCount = 0;
  @override
  void initState() {
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
    super.initState();
    _controller =
        new AnimationController(duration: widget.duration, vsync: this)
          ..addListener(() {
            setState(() {});
          });
    _initAllAmimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var likeWidget = widget.builder?.call(_isLiked) ??
        defaultWidgetBuilder(_isLiked, widget.size);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onTap,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Positioned(
                top: (widget.size - widget.dotSize) / 2.0,
                left: (widget.size - widget.dotSize) / 2.0,
                child: CustomPaint(
                  size: Size(widget.dotSize, widget.dotSize),
                  painter: DotPainter(
                    currentProgress: dots.value,
                    color1: widget.dotColor.dotPrimaryColor,
                    color2: widget.dotColor.dotSecondaryColor,
                    color3: widget.dotColor.dotThirdColorReal,
                    color4: widget.dotColor.dotLastColorReal,
                  ),
                ),
              ),
              Positioned(
                top: (widget.size - widget.circleSize) / 2.0,
                left: (widget.size - widget.circleSize) / 2.0,
                child: CustomPaint(
                  size: Size(widget.circleSize, widget.circleSize),
                  painter: CirclePainter(
                      innerCircleRadiusProgress: innerCircle.value,
                      outerCircleRadiusProgress: outerCircle.value,
                      startColor: widget.circleStartColor,
                      endColor: widget.circleEndColor),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                alignment: Alignment.center,
                child: Transform.scale(
                  scale:
                      (_isLiked && _controller.isAnimating) ? scale.value : 1.0,
                  child: SizedBox(
                    child: likeWidget,
                    height: widget.size,
                    width: widget.size,
                  ),
                ),
              ),
            ],
          ),
//          Padding(
//            padding: EdgeInsets.only(
//              top: _likeCount < 10000 ? 4.0 : 0.0,
//              left: 5.0,
//            ),
//            child: Text(
//              StringExtensions.intFormat(_likeCount),
//              style: TextStyle(
//                  color: _likeCount > 0
//                      ? widget.countColor ?? EastMoneyTheme.grey17
//                      : EastMoneyTheme.grey17),
//            ),
//          )
        ],
      ),
    );
  }

  void _onTap() {
    if (_controller.isAnimating) return;
    if (widget.onIconClicked != null) {
      widget.onIconClicked(_isLiked).then((isLiked) {
        _handleIsLikeChanged(isLiked);
      });
    } else {
      _handleIsLikeChanged(!_isLiked);
    }
  }

  void _handleIsLikeChanged(bool isLiked) {
    if (isLiked != null && isLiked != _isLiked) {
      if (isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
      _isLiked = isLiked;
      if (_isLiked) {
        _controller.reset();
        _controller.forward();
      } else {
        setState(() {});
      }
    }
  }

  void _initAllAmimations() {
    outerCircle = new Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    innerCircle = new Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    scale = new Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    dots = new Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      new CurvedAnimation(
        parent: _controller,
        curve: new Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
