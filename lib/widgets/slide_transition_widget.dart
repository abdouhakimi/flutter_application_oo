import 'package:flutter/material.dart';

class SlideTransitionWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset begin;
  final Offset end;
  final bool autoStart;

  const SlideTransitionWidget({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeInOut,
    this.begin = const Offset(1.0, 0.0),
    this.end = Offset.zero,
    this.autoStart = true,
  });

  @override
  State<SlideTransitionWidget> createState() => _SlideTransitionWidgetState();
}

class _SlideTransitionWidgetState extends State<SlideTransitionWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<Offset>(
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
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}
