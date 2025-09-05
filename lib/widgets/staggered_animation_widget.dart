import 'package:flutter/material.dart';

class StaggeredAnimationWidget extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool autoStart;

  const StaggeredAnimationWidget({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 300),
    this.delay = const Duration(milliseconds: 100),
    this.curve = Curves.easeInOut,
    this.autoStart = true,
  });

  @override
  State<StaggeredAnimationWidget> createState() => _StaggeredAnimationWidgetState();
}

class _StaggeredAnimationWidgetState extends State<StaggeredAnimationWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.duration,
        vsync: this,
      ),
    );
    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ));
    }).toList();

    if (widget.autoStart) {
      _startStaggeredAnimation();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _startStaggeredAnimation() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(
        Duration(milliseconds: widget.delay.inMilliseconds * i),
        () {
          if (mounted) {
            _controllers[i].forward();
          }
        },
      );
    }
  }

  void start() {
    _startStaggeredAnimation();
  }

  void reverse() {
    for (var controller in _controllers) {
      controller.reverse();
    }
  }

  void reset() {
    for (var controller in _controllers) {
      controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.children.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, 50 * (1 - _animations[index].value)),
              child: Opacity(
                opacity: _animations[index].value,
                child: widget.children[index],
              ),
            );
          },
        );
      }),
    );
  }
}
