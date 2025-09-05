import 'package:flutter/material.dart';

class HeroTransitionWidget extends StatelessWidget {
  final Widget child;
  final String tag;
  final Duration flightShuttleBuilderDuration;
  final Duration transitionDuration;

  const HeroTransitionWidget({
    super.key,
    required this.child,
    required this.tag,
    this.flightShuttleBuilderDuration = const Duration(milliseconds: 300),
    this.transitionDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: child,
      flightShuttleBuilder: (
        BuildContext flightContext,
        Animation<double> animation,
        HeroFlightDirection flightDirection,
        BuildContext fromHeroContext,
        BuildContext toHeroContext,
      ) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Transform.scale(
              scale: animation.value,
              child: Opacity(
                opacity: animation.value,
                child: this.child,
              ),
            );
          },
        );
      },
    );
  }
}
