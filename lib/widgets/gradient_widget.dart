import 'package:flutter/material.dart';

class GradientWidget extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final Alignment begin;
  final Alignment end;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const GradientWidget({
    super.key,
    required this.child,
    required this.colors,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: begin,
          end: end,
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

class RadialGradientWidget extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final Alignment center;
  final double radius;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const RadialGradientWidget({
    super.key,
    required this.child,
    required this.colors,
    this.center = Alignment.center,
    this.radius = 1.0,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: colors,
          center: center,
          radius: radius,
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

class SweepGradientWidget extends StatelessWidget {
  final Widget child;
  final List<Color> colors;
  final Alignment center;
  final double startAngle;
  final double endAngle;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SweepGradientWidget({
    super.key,
    required this.child,
    required this.colors,
    this.center = Alignment.center,
    this.startAngle = 0.0,
    this.endAngle = 6.28,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: SweepGradient(
          colors: colors,
          center: center,
          startAngle: startAngle,
          endAngle: endAngle,
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
