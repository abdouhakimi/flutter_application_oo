import 'package:flutter/material.dart';

class RippleEffectWidget extends StatefulWidget {
  final Widget child;
  final Color rippleColor;
  final double rippleRadius;
  final Duration duration;
  final VoidCallback? onTap;

  const RippleEffectWidget({
    super.key,
    required this.child,
    this.rippleColor = Colors.white,
    this.rippleRadius = 100.0,
    this.duration = const Duration(milliseconds: 600),
    this.onTap,
  });

  @override
  State<RippleEffectWidget> createState() => _RippleEffectWidgetState();
}

class _RippleEffectWidgetState extends State<RippleEffectWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Offset? _tapPosition;

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
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _tapPosition = details.localPosition;
    _controller.forward().then((_) {
      _controller.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: RipplePainter(
              animation: _animation,
              tapPosition: _tapPosition,
              rippleColor: widget.rippleColor,
              rippleRadius: widget.rippleRadius,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }
}

class RipplePainter extends CustomPainter {
  final Animation<double> animation;
  final Offset? tapPosition;
  final Color rippleColor;
  final double rippleRadius;

  RipplePainter({
    required this.animation,
    this.tapPosition,
    required this.rippleColor,
    required this.rippleRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (tapPosition == null) return;

    final paint = Paint()
      ..color = rippleColor.withOpacity(0.3 * (1 - animation.value))
      ..style = PaintingStyle.fill;

    final radius = rippleRadius * animation.value;
    canvas.drawCircle(tapPosition!, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return animation != oldDelegate.animation ||
        tapPosition != oldDelegate.tapPosition;
  }
}
