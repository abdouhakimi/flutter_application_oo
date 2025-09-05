import 'package:flutter/material.dart';

class VisibilityWidget extends StatelessWidget {
  final Widget child;
  final bool visible;
  final bool maintainState;
  final bool maintainAnimation;
  final bool maintainSize;
  final bool maintainSemantics;
  final Widget? replacement;

  const VisibilityWidget({
    super.key,
    required this.child,
    required this.visible,
    this.maintainState = false,
    this.maintainAnimation = false,
    this.maintainSize = false,
    this.maintainSemantics = false,
    this.replacement,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      maintainState: maintainState,
      maintainAnimation: maintainAnimation,
      maintainSize: maintainSize,
      maintainSemantics: maintainSemantics,
      replacement: replacement ?? const SizedBox.shrink(),
      child: child,
    );
  }
}

class AnimatedVisibilityWidget extends StatefulWidget {
  final Widget child;
  final bool visible;
  final Duration duration;
  final Curve curve;
  final Widget? replacement;
  final VoidCallback? onEnd;

  const AnimatedVisibilityWidget({
    super.key,
    required this.child,
    required this.visible,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.replacement,
    this.onEnd,
  });

  @override
  State<AnimatedVisibilityWidget> createState() => _AnimatedVisibilityWidgetState();
}

class _AnimatedVisibilityWidgetState extends State<AnimatedVisibilityWidget>
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
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.visible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedVisibilityWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward().then((_) {
          widget.onEnd?.call();
        });
      } else {
        _controller.reverse();
      }
    }
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
          child: widget.visible ? widget.child : (widget.replacement ?? const SizedBox.shrink()),
        );
      },
    );
  }
}
