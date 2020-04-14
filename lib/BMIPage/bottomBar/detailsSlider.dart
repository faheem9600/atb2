import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;
import 'package:protoatb/BMIPage/utilsBMI/widget_utils.dart' show screenAwareSize;

const double _detailWidth = 21.0;
const double _sliderHorizontalMargin = 24.0;
const double _doytsLeftMargin = 8.0;

class DetailSlider extends StatefulWidget {
  final VoidCallback onSubmit;
  final AnimationController submitAnimationController;

  const DetailSlider({Key key, this.onSubmit, this.submitAnimationController})
      : super(key: key);

  @override
  _DetailSliderState createState() {
    return _DetailSliderState();
  }
}

class _DetailSliderState extends State<DetailSlider>
    with TickerProviderStateMixin {
  double _detailPosition = 24.0;
  AnimationController animationController;
  Animation<double> animation;

  Animation<BorderRadius> _bordersAnimation;
  Animation<double> _submitWidthAnimation;

  double get width => _submitWidthAnimation?.value ?? 0.0;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _bordersAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(8.0),
      end: BorderRadius.circular(50.0),
    ).animate(CurvedAnimation(
      parent: widget.submitAnimationController,
      curve: Interval(0.0, 0.07),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _submitWidthAnimation = Tween<double>(
        begin: constraints.maxWidth,
        end: screenAwareSize(52.0, context),
      ).animate(CurvedAnimation(
        parent: widget.submitAnimationController,
        curve: Interval(0.05, 0.15),
      ));
      return AnimatedBuilder(
          animation: widget.submitAnimationController,
          builder: (context, child) {
            Decoration decoration = BoxDecoration(
              borderRadius: _bordersAnimation.value,
              color: Color(0xFF00154F),
            );

            return Center(
              child: Container(
                height: screenAwareSize(52.0, context),
                width: width,
                decoration: decoration,
                child: _submitWidthAnimation.isDismissed
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _animateDetailToEnd(),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            AnimatedDots(),
                            _drawDotCurtain(decoration),
                            _drawDetails(),
                          ],
                        ),
                      )
                    : Container(),
              ),
            );
          });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _drawDotCurtain(Decoration decoration) {
    if (width == 0) {
      return Container();
    }
    double marginRight =
        width - _detailPosition - screenAwareSize(_detailWidth / 2, context);
    return Positioned.fill(
      right: marginRight,
      child: Container(decoration: decoration),
    );
  }

  Widget _drawDetails() {
    if (animation == null && width != 0.0) {
      animation = _initDetailAnimation(width);
    }
    return Positioned(
      left: _detailPosition,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => _onDetailDrag(width, details),
        onHorizontalDragEnd: (details) => _onDetailDragEnd(width, details),
        child: DetailIcon(),
      ),
    );
  }

  Animation<double> _initDetailAnimation(double width) {
    Animation<double> animation = Tween(
      begin: _detailMinPosition(),
      end: _detailMaxPosition(width),
    ).animate(animationController);

    animation.addListener(() {
      setState(() {
        _detailPosition = animation.value;
      });
      if (animation.status == AnimationStatus.completed) {
        _onDetailSubmited();
      }
    });
    return animation;
  }

  _onDetailSubmited() {
    widget?.onSubmit();
    Future.delayed(Duration(seconds: 1), () => _resetDetail());
  }

  _onDetailDragEnd(double width, DragEndDetails details) {
    bool isOverHalf =
        _detailPosition + screenAwareSize(_detailWidth / 2, context) >
            width * 0.5;
    if (isOverHalf) {
      _animateDetailToEnd(width: width);
    } else {
      _resetDetail();
    }
  }

  _animateDetailToEnd({double width}) {
    animationController.forward(
        from: _detailPosition / _detailMaxPosition(width));
  }

  _resetDetail() {
    setState(() {
      _detailPosition = _detailMinPosition();
    });
  }

  _onDetailDrag(double width, DragUpdateDetails details) {
    setState(() {
      _detailPosition += details.delta.dx;
      _detailPosition = math.max(_detailMinPosition(),
          math.min(_detailMaxPosition(width), _detailPosition));
    });
  }

  double _detailMinPosition() {
    return screenAwareSize(_sliderHorizontalMargin, context);
  }

  double _detailMaxPosition(double width) {
    return width -
        screenAwareSize(_sliderHorizontalMargin / 2 + _detailWidth, context);
  }
}

class AnimatedDots extends StatefulWidget {
  @override
  _AnimatedDotsState createState() {
    return _AnimatedDotsState();
  }
}

class _AnimatedDotsState extends State<AnimatedDots>
    with TickerProviderStateMixin {
  final int numOfDots = 10;
  final double minOpacity = 0.1;
  final double maxOpacity = 0.5;

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    initAnimationController();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  initAnimationController() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 800), () {
          animationController.forward(from: 0.0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenAwareSize(
              _sliderHorizontalMargin + _detailWidth + _doytsLeftMargin,
              context),
          right: screenAwareSize(_sliderHorizontalMargin, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(numOfDots, _generateDot)
          ..add(Opacity(
            opacity: maxOpacity,
            child: Dot(size: 14.0),
          )),
      ),
    );
  }

  Widget _generateDot(int dotNumber) {
    Animation animation = _initDotAnimation(dotNumber);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) =>
          Opacity(opacity: animation.value, child: child),
      child: Dot(size: 9.0),
    );
  }

  Animation<double> _initDotAnimation(int dotNum) {
    double lastDotStartTime = 0.3;
    double dotAnimationDuration = 0.6;
    double begin = lastDotStartTime * dotNum / numOfDots;
    double end = begin + dotAnimationDuration;
    return SinusoidalAnimation(min: minOpacity, max: maxOpacity)
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(begin, end),
    ));
  }
}

class Dot extends StatelessWidget {
  final double size;

  const Dot({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenAwareSize(size, context),
      width: screenAwareSize(size, context),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF4aF1B)),
    );
  }
}

class DetailIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: screenAwareSize(16.0, context)),
      child: SvgPicture.asset(
        "images/circle.svg",
        height: screenAwareSize(25.0, context),
        width: screenAwareSize(21.0, context),
      ),
    );
  }
}

class SinusoidalAnimation extends Animatable<double> {
  SinusoidalAnimation({this.min, this.max});

  final double min;
  final double max;

  @protected
  double lerp(double t) {
    return min + (max - min) * math.sin(math.pi * t);
  }

  @override
  double transform(double t) {
    return (t == 0.0 || t == 1.0) ? min : lerp(t);
  }
}