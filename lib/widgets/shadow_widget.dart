import 'package:flutter/material.dart';

class ShadowWidget extends StatelessWidget {
  final Widget child;
  final double elevation;
  final Color shadowColor;
  final Offset offset;
  final double blurRadius;
  final double spreadRadius;
  final BorderRadius? borderRadius;

  const ShadowWidget({
    super.key,
    required this.child,
    this.elevation = 4.0,
    this.shadowColor = Colors.black,
    this.offset = const Offset(0, 2),
    this.blurRadius = 4.0,
    this.spreadRadius = 0.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.2),
            offset: offset,
            blurRadius: blurRadius,
            spreadRadius: spreadRadius,
          ),
        ],
      ),
      child: child,
    );
  }
}

class SoftShadowWidget extends StatelessWidget {
  final Widget child;
  final Color shadowColor;
  final double depth;
  final BorderRadius? borderRadius;

  const SoftShadowWidget({
    super.key,
    required this.child,
    this.shadowColor = Colors.black,
    this.depth = 10.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.1),
            offset: Offset(0, depth * 0.5),
            blurRadius: depth,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor.withOpacity(0.05),
            offset: Offset(0, depth),
            blurRadius: depth * 2,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

class HardShadowWidget extends StatelessWidget {
  final Widget child;
  final Color shadowColor;
  final double depth;
  final BorderRadius? borderRadius;

  const HardShadowWidget({
    super.key,
    required this.child,
    this.shadowColor = Colors.black,
    this.depth = 4.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            offset: Offset(0, depth),
            blurRadius: 0,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}
