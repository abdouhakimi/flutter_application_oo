import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation ?? AppConstants.cardElevation,
      margin: margin ?? const EdgeInsets.all(AppConstants.smallPadding),
      color: color ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppConstants.defaultPadding),
          child: child,
        ),
      ),
    );
  }
}
