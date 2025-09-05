import 'package:flutter/material.dart';

class GestureWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final GestureLongPressStartCallback? onLongPressStart;
  final GestureLongPressEndCallback? onLongPressEnd;
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;
  final GestureLongPressUpCallback? onLongPressUp;
  final GestureDragDownCallback? onPanDown;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final GestureDragStartCallback? onPanStart;
  final GestureDragCancelCallback? onPanCancel;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;
  final HitTestBehavior? behavior;

  const GestureWidget({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onLongPressStart,
    this.onLongPressEnd,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onPanDown,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanStart,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      onLongPressStart: onLongPressStart,
      onLongPressEnd: onLongPressEnd,
      onLongPressMoveUpdate: onLongPressMoveUpdate,
      onLongPressUp: onLongPressUp,
      onPanDown: onPanDown,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onPanStart: onPanStart,
      onPanCancel: onPanCancel,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      behavior: behavior,
      child: child,
    );
  }
}

class TapWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final HitTestBehavior? behavior;

  const TapWidget({
    super.key,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onLongPress,
      behavior: behavior,
      child: child,
    );
  }
}

class DragWidget extends StatelessWidget {
  final Widget child;
  final GestureDragDownCallback? onPanDown;
  final GestureDragUpdateCallback? onPanUpdate;
  final GestureDragEndCallback? onPanEnd;
  final GestureDragStartCallback? onPanStart;
  final GestureDragCancelCallback? onPanCancel;
  final HitTestBehavior? behavior;

  const DragWidget({
    super.key,
    required this.child,
    this.onPanDown,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanStart,
    this.onPanCancel,
    this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: onPanDown,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      onPanStart: onPanStart,
      onPanCancel: onPanCancel,
      behavior: behavior,
      child: child,
    );
  }
}

class ScaleWidget extends StatelessWidget {
  final Widget child;
  final GestureScaleStartCallback? onScaleStart;
  final GestureScaleUpdateCallback? onScaleUpdate;
  final GestureScaleEndCallback? onScaleEnd;
  final HitTestBehavior? behavior;

  const ScaleWidget({
    super.key,
    required this.child,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.behavior,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      behavior: behavior,
      child: child,
    );
  }
}
