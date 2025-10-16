import 'dart:math';
import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final double phase; // 0..2π animated
  final double fillPercent; // 0..1 normalized
  final Color waterColor;
  final Color bgColor;
  final double borderRadius;

  WavePainter({
    required this.phase,
    required this.fillPercent,
    required this.waterColor,
    required this.bgColor,
    this.borderRadius = 10.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final innerMargin = 4.0;
    final innerRect = rect.deflate(innerMargin);

    // Draw bottle interior background
    final paintBg = Paint()..color = bgColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(borderRadius)),
      paintBg,
    );

    // Baseline for water surface (fillPercent 0 -> bottom, 1 -> top)
    final double baseY = innerRect.top + innerRect.height * (1 - fillPercent);

    // 1) Solid water body (rectangle from baseline down to bottom)
    final waterRect = Rect.fromLTRB(
      innerRect.left,
      baseY,
      innerRect.right,
      innerRect.bottom,
    );
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [waterColor.withOpacity(0.98), waterColor.withOpacity(0.85)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(innerRect);

    // Clip to inner rounded rect (bottle interior) and draw fill rect
    final clipRRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(borderRadius - 4),
    );
    canvas.save();
    canvas.clipRRect(clipRRect);
    canvas.drawRect(waterRect, fillPaint);

    // 2) Animated wave surface overlay (sine path) on top of the solid fill
    final Path wavePath = Path();
    final double width = innerRect.width;
    final double amplitude = max(4.0, width * 0.012);
    final double wavelength = width; // one cycle across the width

    wavePath.moveTo(innerRect.left, baseY);
    for (double x = 0; x <= width; x++) {
      final px = innerRect.left + x;
      final double omega = 2 * pi / wavelength;
      final double y = baseY + sin(omega * x + phase) * amplitude;
      wavePath.lineTo(px, y);
    }
    // close down to bottom so overlay covers the water surface area
    wavePath.lineTo(innerRect.right, innerRect.bottom);
    wavePath.lineTo(innerRect.left, innerRect.bottom);
    wavePath.close();

    final Paint wavePaint = Paint()
      ..shader = LinearGradient(
        colors: [waterColor.withOpacity(0.20), waterColor.withOpacity(0.05)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(innerRect)
      ..blendMode = BlendMode.srcOver;
    canvas.drawPath(wavePath, wavePaint);

    // 3) subtle crest highlight along sine top
    final Path crest = Path();
    final Paint crestPaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    crest.moveTo(innerRect.left, baseY + sin(phase) * amplitude);
    for (double x = 0; x <= width; x++) {
      final px = innerRect.left + x;
      final double omega = 2 * pi / wavelength;
      final double y = baseY + sin(omega * x + phase) * amplitude - 1.0;
      crest.lineTo(px, y);
    }
    canvas.drawPath(crest, crestPaint);

    canvas.restore();

    // 4) subtle inner shine
    final Paint shine = Paint()
      ..shader = LinearGradient(
        colors: [Colors.white.withOpacity(0.02), Colors.transparent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(innerRect);
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, Radius.circular(borderRadius - 4)),
      shine,
    );

    // 5) bottle border
    final Paint border = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(innerRect, Radius.circular(borderRadius - 4)),
      border,
    );
  }

  @override
  bool shouldRepaint(covariant WavePainter old) {
    return old.phase != phase || old.fillPercent != fillPercent;
  }
}
