import 'package:flutter/material.dart';

class RotationTransitionWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double begin;
  final double end;
  final bool autoStart;

  const RotationTransitionWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.begin = 0.0,
    this.end = 1.0,
    this.autoStart = true,
  });

  @override
  State<RotationTransitionWidget> createState() => _RotationTransitionWidgetState();
}

class _RotationTransitionWidgetState extends State<RotationTransitionWidget>
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
      begin: widget.begin,
      end: widget.end,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));

    if (widget.autoStart) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void start() {
    _controller.forward();
  }

  void reverse() {
    _controller.reverse();
  }

  void reset() {
    _controller.reset();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}
