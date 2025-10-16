import 'dart:math';
import 'package:flutter/material.dart';
import '../design_system/design_tokens.dart';
import '_wave_painter.dart';

class WaterIntakeWidget extends StatefulWidget {
  final int currentMl;
  final int goalMl;
  final double width;
  final double height;
  final VoidCallback? onTap;

  const WaterIntakeWidget({
    super.key,
    required this.currentMl,
    required this.goalMl,
    this.width = 120,
    this.height = 280,
    this.onTap,
  });

  @override
  State<WaterIntakeWidget> createState() => _WaterIntakeWidgetState();
}

class _WaterIntakeWidgetState extends State<WaterIntakeWidget>
    with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _fillController;
  late Animation<double> _waveAnimation;
  late Animation<double> _fillAnimation;

  @override
  void initState() {
    super.initState();

    // Wave animation controller (continuous)
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );

    // Fill animation controller (for smooth transitions)
    _fillController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: _waveController, curve: Curves.linear));

    _fillAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _fillController, curve: Curves.easeOut));

    // Start wave animation
    _waveController.repeat();

    // Animate to current fill level
    _fillController.forward();
  }

  @override
  void didUpdateWidget(WaterIntakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Animate to new fill level when values change
    if (oldWidget.currentMl != widget.currentMl) {
      _fillController.reset();
      _fillController.forward();
    }
  }

  @override
  void dispose() {
    _waveController.dispose();
    _fillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fillPercent = (widget.currentMl / widget.goalMl).clamp(0.0, 1.0);
    final actualPercentage = ((widget.currentMl / widget.goalMl) * 100).round();

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Water bottle with wave animation
            AnimatedBuilder(
              animation: Listenable.merge([_waveAnimation, _fillAnimation]),
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: WavePainter(
                    phase: _waveAnimation.value,
                    fillPercent: fillPercent * _fillAnimation.value,
                    waterColor: DesignTokens.accent1,
                    bgColor: DesignTokens.brandDark.withOpacity(0.1),
                    borderRadius: 60.0,
                  ),
                );
              },
            ),

            // Water level indicator (small dot at bottom)
            Positioned(
              bottom: 20,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: DesignTokens.accent1,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),

            // Progress percentage text
            Positioned(
              top: 20,
              child: Text(
                '$actualPercentage%',
                style: AppTextStyles.h2.copyWith(color: DesignTokens.accent1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
