import 'package:flutter/material.dart';

class NeumorphismWidget extends StatelessWidget {
  final Widget child;
  final double depth;
  final Color lightColor;
  final Color darkColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const NeumorphismWidget({
    super.key,
    required this.child,
    this.depth = 10.0,
    this.lightColor = Colors.white,
    this.darkColor = Colors.grey,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: lightColor,
          borderRadius: borderRadius ?? BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: darkColor.withOpacity(0.3),
              offset: Offset(depth, depth),
              blurRadius: depth * 2,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: lightColor.withOpacity(0.8),
              offset: Offset(-depth, -depth),
              blurRadius: depth * 2,
              spreadRadius: 0,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
