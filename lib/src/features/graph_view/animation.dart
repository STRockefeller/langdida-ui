import 'dart:math';

import 'package:flutter/material.dart';

class Point {
  final double x;
  final double y;
  final double radius;
  final double vx;
  final double vy;

  Point({
    required this.x,
    required this.y,
    required this.radius,
    required this.vx,
    required this.vy,
  });

  void animate() {
    if (y < radius || y > (1 - radius)) {
      _reverseVelocity(vy);
    } else if (x < radius || x > (1 - radius)) {
      _reverseVelocity(vx);
    }
  }

  void _reverseVelocity(double velocity) {
    velocity = -1 * velocity;
  }
}

class AnimatedCanvas extends StatefulWidget {
  @override
  _AnimatedCanvasState createState() => _AnimatedCanvasState();
}

class _AnimatedCanvasState extends State<AnimatedCanvas>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Point> _points;

  final int _pointsNumber = 20;
  // final double _minDist = 80;
  final double _velocity = 0.3;
  final double _basePointSize = 0.5;
  final Color _circleColor = Colors.white;

  _AnimatedCanvasState() {
    _points = []; // Initialize _points list here
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 16),
      vsync: this,
    )..addListener(() {
        setState(() {
          _updateScene();
        });
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initScene();
      _animationController.repeat();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initScene() {
    _points = [];
    final random = Random();
    for (var i = 0; i < _pointsNumber; i++) {
      _points.add(Point(
        x: random.nextDouble(),
        y: random.nextDouble(),
        radius: _basePointSize + random.nextInt(5),
        vx: _getRandomVelocity(),
        vy: _getRandomVelocity(),
      ));
    }
  }

  void _updateScene() {
    for (var i = 0; i < _pointsNumber; i++) {
      _points[i].animate();
    }
  }

  double _getRandomVelocity() {
    return _velocity - (Random().nextDouble() * 0.5);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final renderBox = context.findRenderObject() as RenderBox;
        final localPosition = renderBox.globalToLocal(details.globalPosition);
        setState(() {
          _addPoint(localPosition.dx / renderBox.size.width,
              localPosition.dy / renderBox.size.height);
        });
      },
      child: Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.black,
        child: CustomPaint(
          painter: _CanvasPainter(_points, _circleColor),
        ),
      ),
    );
  }

  void _addPoint(double x, double y) {
    setState(() {
      _points.add(Point(
        x: x,
        y: y,
        radius: _basePointSize + Random().nextInt(5),
        vx: _getRandomVelocity(),
        vy: _getRandomVelocity(),
      ));
    });
  }
}

class _CanvasPainter extends CustomPainter {
  final List<Point> points;
  final Color circleColor;

  _CanvasPainter(this.points, this.circleColor);

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      _drawPoint(canvas, point, size);

      for (var j = i; j < points.length; j++) {
        final otherPoint = points[j];
        _drawLine(canvas, point, otherPoint, size);
      }
    }
  }

  void _drawPoint(Canvas canvas, Point point, Size size) {
    final center = Offset(point.x * size.width, point.y * size.height);
    final paint = Paint()..color = circleColor;

    canvas.drawCircle(center, point.radius, paint);
  }

  void _drawLine(Canvas canvas, Point point1, Point point2, Size size) {
    final t1 = 80 * (point1.radius / 2);
    final t2 = 80 * (point2.radius / 2);

    final threshold = t1 > t2 ? t1 : t2;

    final distance =
        sqrt(pow(point2.x - point1.x, 2) + pow(point2.y - point1.y, 2));
    if (distance < threshold) {
      final opacity = 1 - distance / threshold * 1.2;
      final paint = Paint()
        ..color = circleColor.withOpacity(opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.5;

      final startPoint = Offset(point1.x * size.width, point1.y * size.height);
      final endPoint = Offset(point2.x * size.width, point2.y * size.height);

      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(_CanvasPainter oldDelegate) {
    return true;
  }
}
