import 'package:flutter/material.dart';

class ClipWidget extends StatelessWidget {
  final Widget child;
  final ClipType type;
  final double radius;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const ClipWidget({
    super.key,
    required this.child,
    this.type = ClipType.rounded,
    this.radius = 10.0,
    this.borderRadius,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget clippedChild = child;

    switch (type) {
      case ClipType.rounded:
        clippedChild = ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(radius),
          child: child,
        );
        break;
      case ClipType.circle:
        clippedChild = ClipOval(child: child);
        break;
      case ClipType.rectangle:
        clippedChild = ClipRect(child: child);
        break;
      case ClipType.path:
        clippedChild = ClipPath(
          clipper: CustomPathClipper(radius: radius),
          child: child,
        );
        break;
    }

    return Container(
      margin: margin,
      padding: padding,
      child: clippedChild,
    );
  }
}

enum ClipType {
  rounded,
  circle,
  rectangle,
  path,
}

class CustomPathClipper extends CustomClipper<Path> {
  final double radius;

  CustomPathClipper({required this.radius});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);
    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomPathClipper oldClipper) {
    return radius != oldClipper.radius;
  }
}
