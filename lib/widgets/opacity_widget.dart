import 'package:flutter/material.dart';

class OpacityWidget extends StatelessWidget {
  final Widget child;
  final double opacity;
  final bool alwaysIncludeSemantics;

  const OpacityWidget({
    super.key,
    required this.child,
    this.opacity = 1.0,
    this.alwaysIncludeSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      alwaysIncludeSemantics: alwaysIncludeSemantics,
      child: child,
    );
  }
}

class AnimatedOpacityWidget extends StatefulWidget {
  final Widget child;
  final double opacity;
  final Duration duration;
  final Curve curve;
  final VoidCallback? onEnd;

  const AnimatedOpacityWidget({
    super.key,
    required this.child,
    required this.opacity,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.onEnd,
  });

  @override
  State<AnimatedOpacityWidget> createState() => _AnimatedOpacityWidgetState();
}

class _AnimatedOpacityWidgetState extends State<AnimatedOpacityWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.opacity,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    _controller.forward().then((_) {
      widget.onEnd?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Opacity(
          opacity: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}
