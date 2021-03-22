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
  const LikeButton(
      {Key? key,
      this.size = 30.0,
      this.likeBuilder,
      this.countBuilder,
      double? bubblesSize,
      double? circleSize,
      this.likeCount,
      this.isLiked = false,
      this.mainAxisAlignment = MainAxisAlignment.center,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.animationDuration = const Duration(milliseconds: 1000),
      this.likeCountAnimationType = LikeCountAnimationType.part,
      this.likeCountAnimationDuration = const Duration(milliseconds: 500),
      this.likeCountPadding = const EdgeInsets.only(left: 3.0),
      this.bubblesColor = const BubblesColor(
        dotPrimaryColor: Color(0xFFFFC107),
        dotSecondaryColor: Color(0xFFFF9800),
        dotThirdColor: Color(0xFFFF5722),
        dotLastColor: Color(0xFFF44336),
      ),
      this.circleColor =
          const CircleColor(start: Color(0xFFFF5722), end: Color(0xFFFFC107)),
      this.onTap,
      this.countPostion = CountPostion.right,
      this.padding,
      this.countDecoration})
      : bubblesSize = bubblesSize ?? size * 2.0,
        circleSize = circleSize ?? size * 0.8,
        super(key: key);

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
  final LikeButtonTapCallback? onTap;

  ///whether it is liked
  final bool? isLiked;

  ///like count
  ///if null, will not show
  final int? likeCount;

  /// mainAxisAlignment for like button
  final MainAxisAlignment mainAxisAlignment;

  // crossAxisAlignment for like button
  final CrossAxisAlignment crossAxisAlignment;

  ///builder to create like widget
  final LikeWidgetBuilder? likeBuilder;

  ///builder to create like count widget
  final LikeCountWidgetBuilder? countBuilder;

  ///animation duration to change like count
  final Duration likeCountAnimationDuration;

  ///animation type to change like count(none,part,all)
  final LikeCountAnimationType likeCountAnimationType;

  ///padding for like count widget
  final EdgeInsetsGeometry? likeCountPadding;

  ///like count widget postion
  ///left of like widget
  ///right of like widget
  ///top of like widget
  ///bottom of like widget
  final CountPostion countPostion;

  /// padding of like button
  final EdgeInsetsGeometry? padding;

  ///return count widget with decoration
  final CountDecoration? countDecoration;
  @override
  State<StatefulWidget> createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  AnimationController? _controller;
  late Animation<double> _outerCircleAnimation;
  late Animation<double> _innerCircleAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bubblesAnimation;
  late Animation<Offset> _slidePreValueAnimation;
  late Animation<Offset> _slideCurrentValueAnimation;
  AnimationController? _likeCountController;
  late Animation<double> _opacityAnimation;

  bool? _isLiked = false;
  int? _likeCount;
  int? _preLikeCount;
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

    _initAnimations();
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
    _preLikeCount = _likeCount;

    if (_controller?.duration != widget.animationDuration) {
      _controller?.dispose();
      _controller =
          AnimationController(duration: widget.animationDuration, vsync: this);
      _initControlAnimation();
    }

    if (_likeCountController?.duration != widget.likeCountAnimationDuration) {
      _likeCountController?.dispose();
      _likeCountController = AnimationController(
          duration: widget.likeCountAnimationDuration, vsync: this);
      _initLikeCountControllerAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller!.dispose();
    _likeCountController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget likeCountWidget = _getLikeCountWidget();
    if (widget.countDecoration != null) {
      likeCountWidget = widget.countDecoration!(likeCountWidget, _likeCount) ??
          likeCountWidget;
    }
    if (widget.likeCountPadding != null) {
      likeCountWidget = Padding(
        padding: widget.likeCountPadding!,
        child: likeCountWidget,
      );
    }

    List<Widget> children = <Widget>[
      AnimatedBuilder(
        animation: _controller!,
        builder: (BuildContext c, Widget? w) {
          final Widget likeWidget =
              widget.likeBuilder?.call(_isLiked ?? true) ??
                  defaultWidgetBuilder(_isLiked ?? true, widget.size);
          return Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Positioned(
                top: (widget.size - widget.bubblesSize) / 2.0,
                left: (widget.size - widget.bubblesSize) / 2.0,
                child: CustomPaint(
                  size: Size(widget.bubblesSize, widget.bubblesSize),
                  painter: BubblesPainter(
                    currentProgress: _bubblesAnimation.value,
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
                    innerCircleRadiusProgress: _innerCircleAnimation.value,
                    outerCircleRadiusProgress: _outerCircleAnimation.value,
                    circleColor: widget.circleColor,
                  ),
                ),
              ),
              Container(
                width: widget.size,
                height: widget.size,
                alignment: Alignment.center,
                child: Transform.scale(
                  scale: ((_isLiked ?? true) && _controller!.isAnimating)
                      ? _scaleAnimation.value
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
      likeCountWidget
    ];

    if (widget.countPostion == CountPostion.left ||
        widget.countPostion == CountPostion.top) {
      children = children.reversed.toList();
    }
    Widget result = (widget.countPostion == CountPostion.left ||
            widget.countPostion == CountPostion.right)
        ? Row(
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            children: children,
          )
        : Column(
            mainAxisAlignment: widget.mainAxisAlignment,
            crossAxisAlignment: widget.crossAxisAlignment,
            children: children,
          );

    if (widget.padding != null) {
      result = Padding(
        padding: widget.padding!,
        child: result,
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: result,
    );
  }

  Widget _getLikeCountWidget() {
    if (_likeCount == null) {
      return Container();
    }
    final String likeCount = _likeCount.toString();
    final String preLikeCount = _preLikeCount.toString();

    int didIndex = 0;
    if (preLikeCount.length == likeCount.length) {
      for (; didIndex < likeCount.length; didIndex++) {
        if (likeCount[didIndex] != preLikeCount[didIndex]) {
          break;
        }
      }
    }
    final bool allChange =
        preLikeCount.length != likeCount.length || didIndex == 0;

    Widget result;

    if (widget.likeCountAnimationType == LikeCountAnimationType.none ||
        _likeCount == _preLikeCount) {
      result = _createLikeCountWidget(
          _likeCount, _isLiked ?? true, _likeCount.toString());
    } else if (widget.likeCountAnimationType == LikeCountAnimationType.part &&
        !allChange) {
      final String samePart = likeCount.substring(0, didIndex);
      final String preText =
          preLikeCount.substring(didIndex, preLikeCount.length);
      final String text = likeCount.substring(didIndex, likeCount.length);
      final Widget preSameWidget =
          _createLikeCountWidget(_preLikeCount, !(_isLiked ?? true), samePart);
      final Widget currentSameWidget =
          _createLikeCountWidget(_likeCount, _isLiked ?? true, samePart);
      final Widget preWidget =
          _createLikeCountWidget(_preLikeCount, !(_isLiked ?? true), preText);
      final Widget currentWidget =
          _createLikeCountWidget(_likeCount, _isLiked ?? true, text);

      result = AnimatedBuilder(
          animation: _likeCountController!,
          builder: (BuildContext b, Widget? w) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    Opacity(
                      child: currentSameWidget,
                      opacity: _opacityAnimation.value,
                    ),
                    Opacity(
                      child: preSameWidget,
                      opacity: 1.0 - _opacityAnimation.value,
                    ),
                  ],
                ),
                Stack(
                  fit: StackFit.passthrough,
                  clipBehavior: Clip.hardEdge,
                  children: <Widget>[
                    FractionalTranslation(
                        translation: _preLikeCount! > _likeCount!
                            ? _slideCurrentValueAnimation.value
                            : -_slideCurrentValueAnimation.value,
                        child: currentWidget),
                    FractionalTranslation(
                        translation: _preLikeCount! > _likeCount!
                            ? _slidePreValueAnimation.value
                            : -_slidePreValueAnimation.value,
                        child: preWidget),
                  ],
                )
              ],
            );
          });
    } else {
      result = AnimatedBuilder(
        animation: _likeCountController!,
        builder: (BuildContext b, Widget? w) {
          return Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              FractionalTranslation(
                  translation: _preLikeCount! > _likeCount!
                      ? _slideCurrentValueAnimation.value
                      : -_slideCurrentValueAnimation.value,
                  child: _createLikeCountWidget(
                      _likeCount, _isLiked ?? true, _likeCount.toString())),
              FractionalTranslation(
                  translation: _preLikeCount! > _likeCount!
                      ? _slidePreValueAnimation.value
                      : -_slidePreValueAnimation.value,
                  child: _createLikeCountWidget(_preLikeCount,
                      !(_isLiked ?? true), _preLikeCount.toString())),
            ],
          );
        },
      );
    }

    result = ClipRect(
      child: result,
      clipper: LikeCountClip(),
    );

    return result;
  }

  Widget _createLikeCountWidget(int? likeCount, bool isLiked, String text) {
    return widget.countBuilder?.call(likeCount, isLiked, text) ??
        Text(text, style: const TextStyle(color: Colors.grey));
  }

  void onTap() {
    if (_controller!.isAnimating || _likeCountController!.isAnimating) {
      return;
    }
    if (widget.onTap != null) {
      widget.onTap!(_isLiked ?? true).then((bool isLiked) {
        _handleIsLikeChanged(isLiked);
      });
    } else {
      _handleIsLikeChanged(!(_isLiked ?? true));
    }
  }

  void _handleIsLikeChanged(bool? isLiked) {
    if (_isLiked == null) {
      if (_likeCount != null) {
        _preLikeCount = _likeCount;
        _likeCount = _likeCount! + 1;
      }
      if (mounted) {
        setState(() {
          _controller!.reset();
          _controller!.forward();

          if (widget.likeCountAnimationType != LikeCountAnimationType.none) {
            _likeCountController!.reset();
            _likeCountController!.forward();
          }
        });
      }
      return;
    }

    if (isLiked != null && isLiked != _isLiked) {
      if (_likeCount != null) {
        _preLikeCount = _likeCount;
        if (isLiked) {
          _likeCount = _likeCount! + 1;
        } else {
          _likeCount = _likeCount! - 1;
        }
      }
      _isLiked = isLiked;

      if (mounted) {
        setState(() {
          if (_isLiked!) {
            _controller!.reset();
            _controller!.forward();
          }
          if (widget.likeCountAnimationType != LikeCountAnimationType.none) {
            _likeCountController!.reset();
            _likeCountController!.forward();
          }
        });
      }
    }
  }

  void _initAnimations() {
    _initControlAnimation();
    _initLikeCountControllerAnimation();
  }

  void _initLikeCountControllerAnimation() {
    _slidePreValueAnimation = _likeCountController!.drive(Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, 1.0),
    ));
    _slideCurrentValueAnimation = _likeCountController!.drive(Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ));

    _opacityAnimation = _likeCountController!.drive(Tween<double>(
      begin: 0.0,
      end: 1.0,
    ));
  }

  void _initControlAnimation() {
    _outerCircleAnimation = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );
    _innerCircleAnimation = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.2,
          0.5,
          curve: Curves.ease,
        ),
      ),
    );
    final Animation<double> animate = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.35,
          0.7,
          curve: OvershootCurve(),
        ),
      ),
    );
    _scaleAnimation = animate;
    _bubblesAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: const Interval(
          0.1,
          1.0,
          curve: Curves.decelerate,
        ),
      ),
    );
  }
}
