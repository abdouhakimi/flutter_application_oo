import 'package:flutter/material.dart';

class StackWidget extends StatelessWidget {
  final List<Widget> children;
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit fit;
  final Clip clipBehavior;
  final int? semanticChildCount;

  const StackWidget({
    super.key,
    required this.children,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.fit = StackFit.loose,
    this.clipBehavior = Clip.hardEdge,
    this.semanticChildCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: children,
      alignment: alignment,
      textDirection: textDirection,
      fit: fit,
      clipBehavior: clipBehavior,
    );
  }
}

class PositionedWidget extends StatelessWidget {
  final Widget child;
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;

  const PositionedWidget({
    super.key,
    required this.child,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }
}

class AlignWidget extends StatelessWidget {
  final Widget child;
  final AlignmentGeometry alignment;
  final double? widthFactor;
  final double? heightFactor;

  const AlignWidget({
    super.key,
    required this.child,
    this.alignment = Alignment.center,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}

class CenterWidget extends StatelessWidget {
  final Widget child;
  final double? widthFactor;
  final double? heightFactor;

  const CenterWidget({
    super.key,
    required this.child,
    this.widthFactor,
    this.heightFactor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: child,
    );
  }
}
