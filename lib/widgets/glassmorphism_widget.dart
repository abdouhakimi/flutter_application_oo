import 'package:flutter/material.dart';
import 'dart:ui';

class GlassmorphismWidget extends StatelessWidget {
  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius? borderRadius;
  final Border? border;

  const GlassmorphismWidget({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.color = Colors.white,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            border: border ??
                Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
          ),
          child: child,
        ),
      ),
    );
  }
}
