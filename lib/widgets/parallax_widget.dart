import 'package:flutter/material.dart';

class ParallaxWidget extends StatefulWidget {
  final Widget child;
  final double parallaxFactor;
  final ScrollController? scrollController;

  const ParallaxWidget({
    super.key,
    required this.child,
    this.parallaxFactor = 0.5,
    this.scrollController,
  });

  @override
  State<ParallaxWidget> createState() => _ParallaxWidgetState();
}

class _ParallaxWidgetState extends State<ParallaxWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_controller);

    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController != null) {
      final offset = widget.scrollController!.offset;
      final maxScroll = widget.scrollController!.position.maxScrollExtent;
      final progress = offset / maxScroll;
      _controller.value = progress;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -50 * _animation.value * widget.parallaxFactor),
          child: widget.child,
        );
      },
    );
  }
}
