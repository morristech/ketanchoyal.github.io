import 'dart:math';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class FlipWidget extends StatefulWidget {
  final Widget frontWidget;
  final Widget backWidget;
  final double height;
  final double width;

  FlipWidget(
      {Key key,
      this.frontWidget,
      this.backWidget,
      this.height = 100,
      this.width = 100})
      : super(key: key);
  @override
  _FlipWidgetState createState() => _FlipWidgetState();
}

class _FlipWidgetState extends State<FlipWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(end: 1, begin: 0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: FractionalOffset.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateY(pi * _animation.value),
      child: GestureDetector(
        onTap: () {
          if (_animationStatus == AnimationStatus.dismissed) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        },
        child: _animation.value <= 0.5
            ? widget.backWidget
            : Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(pi),
                child: widget.frontWidget),
      ),
    ).h(widget.height).w(widget.width);
  }
}
