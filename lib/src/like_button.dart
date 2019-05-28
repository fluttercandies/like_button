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
  final OnClick click;
  final bool isLiked;
  final int likeCount;
  final MainAxisAlignment mainAxisAlignment;
  final LikeWidgetBuilder likeBuilder;
  final CountWidgetBuilder countBuilder;
  final Duration likeCountChangeDuration;
  final bool enableLikeCountAnimation;
  const LikeButton({
    Key key,
    @required this.size,
    this.likeBuilder,
    this.countBuilder,
    double dotSize,
    double circleSize,
    this.likeCount,
    this.isLiked: false,
    this.enableLikeCountAnimation: true,
    this.mainAxisAlignment: MainAxisAlignment.center,
    this.duration = const Duration(milliseconds: 1000),
    this.likeCountChangeDuration = const Duration(milliseconds: 500),
    this.dotColor = const DotColor(
      dotPrimaryColor: const Color(0xFFFFC107),
      dotSecondaryColor: const Color(0xFFFF9800),
      dotThirdColor: const Color(0xFFFF5722),
      dotLastColor: const Color(0xFFF44336),
    ),
    this.circleStartColor = const Color(0xFFFF5722),
    this.circleEndColor = const Color(0xFFFFC107),
    this.click,
  })  : assert(size != null),
        assert(duration != null),
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
  Animation<Offset> _slideOldValueAnimation;
  Animation<Offset> _slideNewValueAnimation;
  AnimationController _likeCountController;

  bool _isLiked = false;
  int _likeCount;
  int _oldLikeCount;
  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
    _oldLikeCount = _likeCount;

    _controller = AnimationController(duration: widget.duration, vsync: this);
    _likeCountController = AnimationController(
        duration: widget.likeCountChangeDuration, vsync: this);
    _slideOldValueAnimation = _likeCountController.drive(Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.0, 1.0),
    ));
    _slideNewValueAnimation = _likeCountController.drive(Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ));

    _initAllAmimations();
  }

  @override
  void dispose() {
    _controller.dispose();
    _likeCountController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: _onTap,
      child: Row(
        mainAxisAlignment: widget.mainAxisAlignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AnimatedBuilder(
            animation: _controller,
            builder: (c, w) {
              var likeWidget = widget.likeBuilder?.call(_isLiked) ??
                  defaultWidgetBuilder(_isLiked, widget.size);
              return Stack(
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
                      scale: (_isLiked && _controller.isAnimating)
                          ? scale.value
                          : 1.0,
                      child: SizedBox(
                        child: likeWidget,
                        height: widget.size,
                        width: widget.size,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          _likeCount == null
              ? Container()
              : (widget.enableLikeCountAnimation && _oldLikeCount != _likeCount
                  ? ClipRect(
                      clipper: LikeCountClip(),
                      child: AnimatedBuilder(
                        animation: _likeCountController,
                        builder: (context, w) {
                          return Stack(
                            fit: StackFit.passthrough,
                            overflow: Overflow.clip,
                            children: <Widget>[
                              FractionalTranslation(
                                  translation: _oldLikeCount > _likeCount
                                      ? _slideNewValueAnimation.value
                                      : -_slideNewValueAnimation.value,
                                  child: _getLikeCountWidget(
                                      _likeCount, _isLiked)),
                              FractionalTranslation(
                                  translation: _oldLikeCount > _likeCount
                                      ? _slideOldValueAnimation.value
                                      : -_slideOldValueAnimation.value,
                                  child: _getLikeCountWidget(
                                      _oldLikeCount, !_isLiked)),
                            ],
                          );
                        },
                      ),
                    )
                  : _getLikeCountWidget(_likeCount, _isLiked))
        ],
      ),
    );
  }

  Widget _getLikeCountWidget(int likeCount, bool isLiked) {
    return (widget.countBuilder?.call(likeCount, isLiked) ??
        Padding(
          child: Text(
            likeCount.toString(),
            style: TextStyle(color: Colors.grey),
          ),
          padding: EdgeInsets.only(left: 3.0),
        ));
  }

  void _onTap() {
    if (_controller.isAnimating || _likeCountController.isAnimating) return;
    if (widget.click != null) {
      widget.click(_isLiked).then((isLiked) {
        _handleIsLikeChanged(isLiked);
      });
    } else {
      _handleIsLikeChanged(!_isLiked);
    }
  }

  void _handleIsLikeChanged(bool isLiked) {
    if (isLiked != null && isLiked != _isLiked) {
      if (_likeCount != null) {
        _oldLikeCount = _likeCount;
        if (isLiked) {
          _likeCount++;
        } else {
          _likeCount--;
        }
      }
      _isLiked = isLiked;

      if (mounted) {
        setState(() {
          if (_isLiked) {
            _controller.reset();
            _controller.forward();
          }
          if (widget.enableLikeCountAnimation) {
            _likeCountController.reset();
            _likeCountController.forward();
          }
        });
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
