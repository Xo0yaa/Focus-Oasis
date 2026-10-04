import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Draws the potted plant at a given growth stage (1 to 4) for a given
/// species, matching the shapes used in the mockup (docs/02-mockup.png).
/// Kept as a CustomPainter rather than six sets of image assets, so the
/// growth stages and species don't need separate illustrations to get
/// started — see README "What's not implemented yet" for the honest
/// limits of that choice (these are simplified, not pixel-matched to the
/// mockup's hand-drawn versions).
class GardenPlant extends StatelessWidget {
  final int stage;
  final double size;
  final String species;

  const GardenPlant({super.key, required this.stage, this.size = 72, this.species = 'sampaguita'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _PlantPainter(stage: stage, species: species)),
    );
  }
}

class _PlantPainter extends CustomPainter {
  final int stage;
  final String species;
  _PlantPainter({required this.stage, required this.species});

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    Offset p(double x, double y) => Offset(x * s, y * s);

    // Pot — same for every species.
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

    if (species == 'bonsai') {
      _paintBonsai(canvas, p, s);
      return;
    }
    if (species == 'lavender') {
      _paintLavender(canvas, p, s);
      return;
    }

    final stemPaint = Paint()
      ..color = AppTheme.secondaryColor
      ..strokeWidth = 4 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
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

    if (stage < 3) return;

    final center = p(50, 30);
    final big = stage == 4;

    switch (species) {
      case 'sunflower':
        final petalPaint = Paint()..color = AppTheme.accentSun;
        for (var k = 0; k < 12; k++) {
          canvas.save();
          canvas.translate(center.dx, center.dy);
          canvas.rotate(k * 30 * 3.14159 / 180);
          final r = big ? 9.0 : 7.0;
          canvas.drawOval(Rect.fromCenter(center: Offset(0, -r * s), width: 4.5 * s, height: r * s), petalPaint);
          canvas.restore();
        }
        canvas.drawCircle(center, (big ? 9.0 : 7.0) * s, Paint()..color = AppTheme.textColor);
        break;

      case 'rose':
        canvas.drawCircle(center, (big ? 16.0 : 12.0) * s, Paint()..color = AppTheme.primaryColor);
        canvas.drawCircle(
          center,
          (big ? 10.0 : 7.5) * s,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2 * s,
        );
        canvas.drawCircle(
          center,
          (big ? 4.5 : 3.5) * s,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2 * s,
        );
        break;

      case 'tulip':
        final tulipPaint = Paint()..color = AppTheme.accentBloom;
        final w = big ? 15.0 : 11.0;
        final h = big ? 28.0 : 20.0;
        final path = Path()
          ..moveTo(center.dx - w * s, center.dy - h * 0.3 * s)
          ..cubicTo(center.dx - w * s, center.dy + h * 0.7 * s, center.dx, center.dy + h * 0.78 * s,
              center.dx, center.dy + h * 0.78 * s)
          ..cubicTo(center.dx, center.dy + h * 0.78 * s, center.dx + w * s, center.dy + h * 0.7 * s,
              center.dx + w * s, center.dy - h * 0.3 * s)
          ..lineTo(center.dx + w * 0.45 * s, center.dy - h * 0.08 * s)
          ..lineTo(center.dx, center.dy - h * 0.42 * s)
          ..lineTo(center.dx - w * 0.45 * s, center.dy - h * 0.08 * s)
          ..close();
        canvas.drawPath(path, tulipPaint);
        break;

      default: // sampaguita and any unknown species: the original five-petal flower
        final petalPaint = Paint()..color = Colors.white;
        final petalStroke = Paint()
          ..color = AppTheme.textColor
          ..strokeWidth = (big ? 1.8 : 1.4) * s
          ..style = PaintingStyle.stroke;
        final radius = big ? 7.0 : 5.5;
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

  void _paintLavender(Canvas canvas, Offset Function(double, double) p, double s) {
    final stemPaint = Paint()
      ..color = AppTheme.secondaryColor
      ..strokeWidth = 3 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final spikePaint = Paint()..color = AppTheme.accentFlora;
    final spikes = switch (stage) {
      1 => [(50.0, 54.0)],
      2 => [(44.0, 46.0), (56.0, 46.0)],
      _ => [(37.0, 34.0), (50.0, 26.0), (63.0, 34.0)],
    };
    for (final (tx, ty) in spikes) {
      final path = Path()
        ..moveTo(p(50, 68).dx, p(50, 68).dy)
        ..quadraticBezierTo(p((50 + tx) / 2, 52).dx, p((50 + tx) / 2, 52).dy, p(tx, ty).dx, p(tx, ty).dy);
      canvas.drawPath(path, stemPaint);
      if (stage >= 3) {
        for (var i = 0; i < 5; i++) {
          canvas.drawOval(
            Rect.fromCenter(center: Offset(p(tx, ty).dx, p(tx, ty).dy - 2 * s + i * 5.5 * s), width: 3.6 * s, height: 5 * s),
            spikePaint,
          );
        }
      }
    }
  }

  void _paintBonsai(Canvas canvas, Offset Function(double, double) p, double s) {
    final trunkPaint = Paint()
      ..color = AppTheme.textColor
      ..strokeWidth = 5 * s
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final trunkPath = Path()
      ..moveTo(p(50, 70).dx, p(50, 70).dy)
      ..cubicTo(p(47, 58).dx, p(47, 58).dy, p(53, 52).dx, p(53, 52).dy, p(47, 42).dx, p(47, 42).dy);
    canvas.drawPath(trunkPath, trunkPaint);

    if (stage < 2) return;
    final canopyPaint = Paint()..color = AppTheme.secondaryColor;
    final blobs = switch (stage) {
      2 => [(47.0, 42.0, 9.0)],
      3 => [(38.0, 42.0, 10.0), (58.0, 36.0, 11.0)],
      _ => [(38.0, 42.0, 11.0), (58.0, 36.0, 12.0), (47.0, 26.0, 10.0), (64.0, 48.0, 8.0)],
    };
    for (final (x, y, r) in blobs) {
      canvas.drawCircle(p(x, y), r * s, canopyPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PlantPainter oldDelegate) =>
      oldDelegate.stage != stage || oldDelegate.species != species;
}
