import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class _SpinnerReloadState extends State<SpinnerReload>
    with SingleTickerProviderStateMixin {
  AnimationController _spinLoopController;
  Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _spinLoopController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    final Animation curve = CurvedAnimation(
        parent: _spinLoopController, curve: Curves.easeInOutQuart);
    _rotate = Tween<double>(begin: 0, end: pi).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    _spinLoopController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    // this give spinner 1 full spin before stop if it's take less than second to reload
    if (!widget.spinSync && _rotate.value < pi / 360.0) {
      _spinLoopController.reset();
    } else if (_rotate.value < pi / 360.0) {
      _spinLoopController.repeat();
    }
    return Transform.rotate(
      angle: _rotate.value,
      child: Icon(
        Icons.autorenew,
        color: Colors.white,
        size: 16.0,
      ),
    );
  }
}

class SpinnerReload extends StatefulWidget {
  final bool spinSync;

  SpinnerReload(this.spinSync, {Key key}) : super(key: key);

  @override
  _SpinnerReloadState createState() => _SpinnerReloadState();
}
