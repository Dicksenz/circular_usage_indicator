library circular_usage_indicator;

import 'package:flutter/material.dart';
import 'dart:math' as math;

class CircularUsageIndicator extends StatelessWidget {
  final double progressValue;
  final double size;
  final Color backgroundColor;
  final Color progressColor;
  final Color borderColor;
  final TextStyle progressLabelStyle;
  final double borderWidth;
  final List<Widget> children;
  final double elevation;

  CircularUsageIndicator({
    this.progressValue = 0.0,
    @required this.backgroundColor,
    @required this.progressColor,
    this.size = 200,
    @required this.borderColor,
    this.progressLabelStyle,
    this.borderWidth = 1.0,
    this.children = const [],
    this.elevation = 0.0,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(size),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(size),
          child: Container(
            height: size,
            width: size,
            child: Stack(
              children: [
                Container(
                  color: backgroundColor,
                ),
                progressValue == 0.0
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: size * progressValue,
                          color: progressColor,
                        ),
                      )
                    : Wave(
                        value: progressValue,
                        color: progressColor,
                        direction: Axis.vertical,
                      ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  body: Center(
                    child: children.length == 0
                        ? Text(
                            '${(progressValue * 100).round()} %',
                            style: progressLabelStyle,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: children,
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Wave extends StatefulWidget {
  final double value;
  final Color color;
  final Axis direction;

  const Wave({
    Key key,
    @required this.value,
    @required this.color,
    @required this.direction,
  }) : super(key: key);

  @override
  _WaveState createState() => _WaveState();
}

class _WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      builder: (context, child) => ClipPath(
        child: Container(
          color: widget.color,
        ),
        clipper: _WaveClipper(
          animationValue: _animationController.value,
          value: widget.value,
          direction: widget.direction,
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double value;
  final Axis direction;

  _WaveClipper({
    @required this.animationValue,
    @required this.value,
    @required this.direction,
  });

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      Path path = Path()
        ..addPolygon(_generateHorizontalWavePath(size), false)
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0)
        ..close();
      return path;
    }

    Path path = Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  List<Offset> _generateHorizontalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final waveHeight = (size.width / 20);
      final dx = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) *
              waveHeight +
          (size.width * value);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final waveHeight = (size.height / 20);
      final dy = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) *
              waveHeight +
          (size.height - (size.height * value));
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) =>
      animationValue != oldClipper.animationValue;
}
