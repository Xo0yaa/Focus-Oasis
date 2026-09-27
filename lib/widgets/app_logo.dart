import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// The "Ring Sprout" mark: a Pomodoro ring with a seedling growing inside
/// it. See docs/logos/logo-1-ring-sprout.svg for the source design and
/// docs/DESIGN_SYSTEM_V3.pdf section VII for the brand rules.
///
/// Drawn with CustomPaint for now so the app doesn't depend on flutter_svg
/// (not covered in the course). Swap for Image.asset('assets/images/
/// logo_mark.png') once the exported PNG is added to the project.
class AppLogo extends StatelessWidget {
  final double size;
  const AppLogo({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size, child: CustomPaint(painter: _LogoPainter()));
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 100;
    final center = Offset(50 * s, 50 * s);

    final track = Paint()
      ..color = AppTheme.ringTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, 40 * s, track);

    final ring = Paint()
      ..color = AppTheme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10 * s
      ..strokeCap = StrokeCap.round;
    const sweep = 2 * math.pi * 0.72;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 40 * s),
      -math.pi / 2,
      sweep,
      false,
      ring,
    );

    final stem = Paint()
      ..color = AppTheme.secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(50 * s, 72 * s), Offset(50 * s, 50 * s), stem);

    final leaf = Paint()..color = AppTheme.secondaryColor;
    final leafPath1 = Path()
      ..moveTo(50 * s, 58 * s)
      ..cubicTo(39 * s, 58 * s, 33 * s, 51 * s, 33 * s, 42 * s)
      ..cubicTo(43 * s, 42 * s, 50 * s, 48 * s, 50 * s, 58 * s)
      ..close();
    canvas.drawPath(leafPath1, leaf);
    final leafPath2 = Path()
      ..moveTo(50 * s, 50 * s)
      ..cubicTo(50 * s, 40 * s, 58 * s, 34 * s, 68 * s, 34 * s)
      ..cubicTo(68 * s, 44 * s, 60 * s, 50 * s, 50 * s, 50 * s)
      ..close();
    canvas.drawPath(leafPath2, leaf);

    final soil = Paint()
      ..color = AppTheme.textColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5 * s
      ..strokeCap = StrokeCap.round;
    final soilPath = Path()
      ..moveTo(36 * s, 72 * s)
      ..quadraticBezierTo(50 * s, 64 * s, 64 * s, 72 * s);
    canvas.drawPath(soilPath, soil);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) => false;
}
