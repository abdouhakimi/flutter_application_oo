import 'package:flutter/material.dart';

class BorderWidget extends StatelessWidget {
  final Widget child;
  final double width;
  final Color color;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const BorderWidget({
    super.key,
    required this.child,
    this.width = 1.0,
    this.color = Colors.grey,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        border: Border.all(
          color: color,
          width: width,
        ),
        borderRadius: borderRadius,
      ),
      child: Container(
        padding: padding,
        child: child,
      ),
    );
  }
}

class DashedBorderWidget extends StatelessWidget {
  final Widget child;
  final double width;
  final Color color;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const DashedBorderWidget({
    super.key,
    required this.child,
    this.width = 1.0,
    this.color = Colors.grey,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: CustomPaint(
        painter: DashedBorderPainter(
          color: color,
          strokeWidth: width,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          borderRadius: borderRadius,
        ),
        child: Container(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final BorderRadius? borderRadius;

  DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path();
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      borderRadius?.topLeft ?? Radius.zero,
    );
    path.addRRect(rect);

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final extractPath = pathMetric.extractPath(
          distance,
          distance + dashWidth,
        );
        canvas.drawPath(extractPath, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(DashedBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        dashWidth != oldDelegate.dashWidth ||
        dashSpace != oldDelegate.dashSpace;
  }
}
