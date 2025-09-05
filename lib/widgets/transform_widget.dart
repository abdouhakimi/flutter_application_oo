import 'package:flutter/material.dart';

class TransformWidget extends StatelessWidget {
  final Widget child;
  final double scale;
  final double rotation;
  final Offset translation;
  final Alignment alignment;
  final bool transformHitTests;

  const TransformWidget({
    super.key,
    required this.child,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.translation = Offset.zero,
    this.alignment = Alignment.center,
    this.transformHitTests = true,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..scale(scale)
        ..rotateZ(rotation)
        ..translate(translation.dx, translation.dy),
      alignment: alignment,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class ScaleWidget extends StatelessWidget {
  final Widget child;
  final double scale;
  final Alignment alignment;
  final bool transformHitTests;

  const ScaleWidget({
    super.key,
    required this.child,
    this.scale = 1.0,
    this.alignment = Alignment.center,
    this.transformHitTests = true,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      alignment: alignment,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class RotateWidget extends StatelessWidget {
  final Widget child;
  final double angle;
  final Alignment alignment;
  final bool transformHitTests;

  const RotateWidget({
    super.key,
    required this.child,
    this.angle = 0.0,
    this.alignment = Alignment.center,
    this.transformHitTests = true,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      alignment: alignment,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}

class TranslateWidget extends StatelessWidget {
  final Widget child;
  final Offset offset;
  final bool transformHitTests;

  const TranslateWidget({
    super.key,
    required this.child,
    this.offset = Offset.zero,
    this.transformHitTests = true,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      transformHitTests: transformHitTests,
      child: child,
    );
  }
}
