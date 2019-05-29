///
///  create by zmtzawqlp on 2019/5/27
///

import 'package:flutter/material.dart';
import 'package:like_button/src/painter/circle_painter.dart';
import 'package:like_button/src/painter/bubbles_painter.dart';
import 'package:like_button/src/utils/like_button_model.dart';
import 'package:like_button/src/utils/like_button_typedef.dart';
import 'package:like_button/src/utils/like_button_util.dart';

class LikeButton extends StatefulWidget {
  ///size of like widget
  final double size;

  ///animation duration to change isLiked state
  final Duration animationDuration;

  ///total size of bubbles
  final double bubblesSize;

  ///colors of bubbles
  final BubblesColor bubblesColor;

  ///size of circle
  final double circleSize;

  ///colors of circle
  final CircleColor circleColor;

  /// tap call back of like button
  final LikeButtonTapCallback onTap;

  ///whether it is liked
  final bool isLiked;

  ///like count
  ///if null, will not show
  final int likeCount;

  /// mainAxisAlignment for like button
  final MainAxisAlignment mainAxisAlignment;

  ///builder to create like widget
  final LikeWidgetBuilder likeBuilder;

  ///builder to create like count widget
  final LikeCountWidgetBuilder countBuilder;

  ///animation duration to change like count
  final Duration likeCountAnimationDuration;

  ///animation type to change like count(none,part,all)
  final LikeCountAnimationType likeCountAnimationType;

  ///padding for like count widget
  final EdgeInsetsGeometry likeCountPadding;

  const LikeButton({
    Key key,
    this.size: 30.0,
    this.likeBuilder,
    this.countBuilder,
    double dotSize,
    double circleSize,
    this.likeCount,
    this.isLiked: false,
    this.mainAxisAlignment: MainAxisAlignment.center,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.likeCountAnimationType = LikeCountAnimationType.part,
    this.likeCountAnimationDuration = const Duration(milliseconds: 500),
    this.likeCountPadding = const EdgeInsets.only(left: 3.0),
    this.bubblesColor = const BubblesColor(
      dotPrimaryColor: const Color(0xFFFFC107),
      dotSecondaryColor: const Color(0xFFFF9800),
      dotThirdColor: const Color(0xFFFF5722),
      dotLastColor: const Color(0xFFF44336),
    ),
    this.circleColor = const CircleColor(
        start: const Color(0xFFFF5722), end: const Color(0xFFFFC107)),
    this.onTap,
  })  : assert(size != null),
        assert(animationDuration != null),
        assert(circleColor != null),
        assert(bubblesColor != null),
        assert(isLiked != null),
        assert(mainAxisAlignment != null),
        bubblesSize = dotSize ?? size * 2.0,
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
  int _preLikeCount;
  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
    _preLikeCount = _likeCount;

    _controller =
        AnimationController(duration: widget.animationDuration, vsync: this);
    _likeCountController = AnimationController(
        duration: widget.likeCountAnimationDuration, vsync: this);
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
                    top: (widget.size - widget.bubblesSize) / 2.0,
                    left: (widget.size - widget.bubblesSize) / 2.0,
                    child: CustomPaint(
                      size: Size(widget.bubblesSize, widget.bubblesSize),
                      painter: BubblesPainter(
                        currentProgress: dots.value,
                        color1: widget.bubblesColor.dotPrimaryColor,
                        color2: widget.bubblesColor.dotSecondaryColor,
                        color3: widget.bubblesColor.dotThirdColorReal,
                        color4: widget.bubblesColor.dotLastColorReal,
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
                        circleColor: widget.circleColor,
                      ),
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
          _getLikeCountWidget()
        ],
      ),
    );
  }

  Widget _getLikeCountWidget() {
    if (_likeCount == null) return Container();
    var likeCount = _likeCount.toString();
    var preLikeCount = _preLikeCount.toString();

    int didIndex = 0;
    if (preLikeCount.length == likeCount.length) {
      for (; didIndex < likeCount.length; didIndex++) {
        if (likeCount[didIndex] != preLikeCount[didIndex]) {
          break;
        }
      }
    }
    bool allChange = preLikeCount.length != likeCount.length || didIndex == 0;

    Widget result;

    if (widget.likeCountAnimationType == LikeCountAnimationType.none ||
        _likeCount == _preLikeCount) {
      result =
          _createLikeCountWidget(_likeCount, _isLiked, _likeCount.toString());
    } else if (widget.likeCountAnimationType == LikeCountAnimationType.part &&
        !allChange) {
      var samePart = likeCount.substring(0, didIndex);
      var preText = preLikeCount.substring(didIndex, preLikeCount.length);
      var text = likeCount.substring(didIndex, likeCount.length);
      var sameWidget = _createLikeCountWidget(_likeCount, _isLiked, samePart);
      var oldWidget = _createLikeCountWidget(_preLikeCount, !_isLiked, preText);
      var currentWidget = _createLikeCountWidget(_likeCount, _isLiked, text);

      result = Row(
        children: <Widget>[
          sameWidget,
          AnimatedBuilder(
              animation: _likeCountController,
              builder: (b, w) {
                return Stack(
                  fit: StackFit.passthrough,
                  overflow: Overflow.clip,
                  children: <Widget>[
                    FractionalTranslation(
                        translation: _preLikeCount > _likeCount
                            ? _slideNewValueAnimation.value
                            : -_slideNewValueAnimation.value,
                        child: currentWidget),
                    FractionalTranslation(
                        translation: _preLikeCount > _likeCount
                            ? _slideOldValueAnimation.value
                            : -_slideOldValueAnimation.value,
                        child: oldWidget),
                  ],
                );
              })
        ],
      );
    } else {
      result = AnimatedBuilder(
        animation: _likeCountController,
        builder: (b, w) {
          return Stack(
            fit: StackFit.passthrough,
            overflow: Overflow.clip,
            children: <Widget>[
              FractionalTranslation(
                  translation: _preLikeCount > _likeCount
                      ? _slideNewValueAnimation.value
                      : -_slideNewValueAnimation.value,
                  child: _createLikeCountWidget(
                      _likeCount, _isLiked, _likeCount.toString())),
              FractionalTranslation(
                  translation: _preLikeCount > _likeCount
                      ? _slideOldValueAnimation.value
                      : -_slideOldValueAnimation.value,
                  child: _createLikeCountWidget(
                      _preLikeCount, !_isLiked, _preLikeCount.toString())),
            ],
          );
        },
      );
    }

    if (widget.likeCountPadding != null) {
      result = Padding(
        padding: widget.likeCountPadding,
        child: result,
      );
    }

    return ClipRect(
      child: result,
      clipper: LikeCountClip(),
    );
  }

  Widget _createLikeCountWidget(int likeCount, bool isLiked, String text) {
    return widget.countBuilder?.call(likeCount, isLiked, text) ??
        Text(text, style: TextStyle(color: Colors.grey));
  }

  void _onTap() {
    if (_controller.isAnimating || _likeCountController.isAnimating) return;
    if (widget.onTap != null) {
      widget.onTap(_isLiked).then((isLiked) {
        _handleIsLikeChanged(isLiked);
      });
    } else {
      _handleIsLikeChanged(!_isLiked);
    }
  }

  void _handleIsLikeChanged(bool isLiked) {
    if (isLiked != null && isLiked != _isLiked) {
      if (_likeCount != null) {
        _preLikeCount = _likeCount;
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
          if (widget.likeCountAnimationType != LikeCountAnimationType.none) {
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
