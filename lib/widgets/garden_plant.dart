import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Draws the potted plant at a given growth stage (1 to 4), matching the
/// shapes used in the mockup (docs/02-mockup.png). Kept as a CustomPainter
/// rather than an image asset so the growth stages don't need four separate
/// illustrations to get started.
class GardenPlant extends StatelessWidget {
  final int stage;
  final double size;

  const GardenPlant({super.key, required this.stage, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PlantPainter(stage: stage)),
    );
  }
}

class _PlantPainter extends CustomPainter {
  final int stage;
  _PlantPainter({required this.stage});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    Offset p(double x, double y) => Offset(x * s, y * s);

    // Pot
    final potPaint = Paint()..color = AppTheme.textColor;
    final potPath = Path()
      ..moveTo(p(30, 74).dx, p(30, 74).dy)
      ..lineTo(p(70, 74).dx, p(70, 74).dy)
      ..lineTo(p(65, 94).dx, p(65, 94).dy)
      ..lineTo(p(35, 94).dx, p(35, 94).dy)
      ..close();
    canvas.drawPath(potPath, potPaint);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(p(27, 68).dx, p(27, 68).dy, 46 * s, 8 * s),
        Radius.circular(3 * s),
      ),
      potPaint,
    );

    if (stage <= 0) return;
    final stemPaint = Paint()
      ..color = AppTheme.secondaryColor
      ..strokeWidth = 4 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Stem height grows with stage.
    final stemTop = switch (stage) {
      1 => 52.0,
      2 => 38.0,
      _ => 30.0,
    };
    canvas.drawLine(p(50, 68), p(50, stemTop), stemPaint);

    final leafPaint = Paint()..color = AppTheme.secondaryColor;
    void leaf(double x, double y, double rot, double l, double w) {
      canvas.save();
      canvas.translate(p(x, y).dx, p(x, y).dy);
      canvas.rotate(rot * 3.14159 / 180);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: l * s, height: w * s), leafPaint);
      canvas.restore();
    }

    if (stage == 1) {
      leaf(41, 52, -30, 18, 8);
      leaf(59, 52, 30, 18, 8);
    } else if (stage == 2) {
      leaf(39, 58, -35, 20, 8);
      leaf(61, 54, 35, 20, 8);
      leaf(41, 44, -30, 16, 8);
      leaf(59, 42, 30, 16, 8);
    } else {
      leaf(38, 58, -35, 20, 8);
      leaf(62, 56, 35, 20, 8);
      leaf(40, 47, -25, 16, 8);
      leaf(60, 46, 25, 16, 8);
    }

    if (stage >= 3) {
      
      final petalPaint = Paint()..color = Colors.white;
      final petalStroke = Paint()
        ..color = AppTheme.textColor
        ..strokeWidth = (stage == 4 ? 1.8 : 1.4) * s
        ..style = PaintingStyle.stroke;
      final radius = stage == 4 ? 7.0 : 5.5;
      final center = p(50, 30);
      for (var k = 0; k < 5; k++) {
        canvas.save();
        canvas.translate(center.dx, center.dy);
        canvas.rotate(k * 72 * 3.14159 / 180);
        final petalRect = Rect.fromCenter(center: Offset(0, -radius * s), width: radius * s, height: (radius + 4) * s);
        canvas.drawOval(petalRect, petalPaint);
        canvas.drawOval(petalRect, petalStroke);
        canvas.restore();
      }
      canvas.drawCircle(center, 4.5 * s, Paint()..color = AppTheme.accentSun);
    }
  }

  @override
  bool shouldRepaint(covariant _PlantPainter oldDelegate) => oldDelegate.stage != stage;
}
