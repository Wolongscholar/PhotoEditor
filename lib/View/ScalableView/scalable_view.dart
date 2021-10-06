import 'package:flutter/material.dart';

// View supports scale and rotate it's child
@immutable
class ScalableView extends StatefulWidget {
  final Widget child;
  ScalableView({key, required this.child});
  ScalableViewState createState() => ScalableViewState();
}

class ScalableViewState extends State<ScalableView> {
  double _scale = 1;
  double _previousScale = 1;
  double _rotate = 0;
  double _previousRotate = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails details) {
        setState(() {
          _previousScale = _scale;
          _previousRotate = _rotate;
        });
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        setState(() {
          _scale = _previousScale * details.scale;
          _rotate = _previousRotate + details.rotation;
        });
      },
      onScaleEnd: (ScaleEndDetails details) {
        setState(() {
          _previousScale = 1;
          _previousRotate = 0;
        });
      },
      child: Transform.rotate(
          angle: _rotate,
          child: Transform.scale(scale: _scale, child: widget.child)),
    );
  }
}
