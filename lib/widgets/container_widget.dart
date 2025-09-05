import 'package:flutter/material.dart';

class ContainerWidget extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final Decoration? foregroundDecoration;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Clip clipBehavior;
  final Matrix4? transform;
  final String? semanticLabel;

  const ContainerWidget({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.foregroundDecoration,
    this.constraints,
    this.alignment,
    this.clipBehavior = Clip.none,
    this.transform,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      constraints: constraints,
      alignment: alignment,
      clipBehavior: clipBehavior,
      transform: transform,
      child: child,
    );
  }
}

class SizedBoxWidget extends StatelessWidget {
  final Widget? child;
  final double? width;
  final double? height;

  const SizedBoxWidget({
    super.key,
    this.child,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}

class PaddingWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const PaddingWidget({
    super.key,
    required this.child,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: child,
    );
  }
}

class MarginWidget extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;

  const MarginWidget({
    super.key,
    required this.child,
    required this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: child,
    );
  }
}

class DecoratedBoxWidget extends StatelessWidget {
  final Widget child;
  final Decoration decoration;
  final DecorationPosition position;

  const DecoratedBoxWidget({
    super.key,
    required this.child,
    required this.decoration,
    this.position = DecorationPosition.background,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration,
      position: position,
      child: child,
    );
  }
}

class ConstrainedBoxWidget extends StatelessWidget {
  final Widget child;
  final BoxConstraints constraints;

  const ConstrainedBoxWidget({
    super.key,
    required this.child,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: constraints,
      child: child,
    );
  }
}

class UnconstrainedBoxWidget extends StatelessWidget {
  final Widget child;
  final Alignment alignment;
  final Axis? constrainedAxis;
  final Clip clipBehavior;

  const UnconstrainedBoxWidget({
    super.key,
    required this.child,
    this.alignment = Alignment.center,
    this.constrainedAxis,
    this.clipBehavior = Clip.none,
  });

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      alignment: alignment,
      constrainedAxis: constrainedAxis,
      clipBehavior: clipBehavior,
      child: child,
    );
  }
}
