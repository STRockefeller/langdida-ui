import 'package:langdida_ui/src/api_models/card.dart';

class CardPoint {
  double x;
  double y;
  final double radius;
  double vx;
  double vy;
  final CardIndex cardIndex;

  CardPoint({
    required this.x,
    required this.y,
    required this.radius,
    required this.vx,
    required this.vy,
    required this.cardIndex,
  });

  void animate() {
    if (_reachPositiveBound(x)) {
      vx = -vx.abs();
    }
    if (_reachNegativeBound(x)) {
      vx = vx.abs();
    }
    if (_reachPositiveBound(y)) {
      vy = -vy.abs();
    }
    if (_reachNegativeBound(y)) {
      vy = vy.abs();
    }
    x += vx;
    y += vy;
  }

  bool _reachPositiveBound(double position) {
    return position >= 1;
  }

  bool _reachNegativeBound(double position) {
    return position <= 0;
  }
}
