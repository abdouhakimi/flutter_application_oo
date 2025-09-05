import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomProgressIndicator extends StatelessWidget {
  final double value;
  final String? label;
  final Color? color;
  final Color? backgroundColor;
  final double height;
  final BorderRadius? borderRadius;

  const CustomProgressIndicator({
    super.key,
    required this.value,
    this.label,
    this.color,
    this.backgroundColor,
    this.height = 8.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppConstants.bodyStyle,
          ),
          const SizedBox(height: AppConstants.smallPadding),
        ],
        Container(
          height: height,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.grey[300],
            borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: value.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                color: color ?? AppConstants.primaryColor,
                borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CircularProgressIndicator extends StatelessWidget {
  final double value;
  final String? label;
  final Color? color;
  final double strokeWidth;
  final double size;

  const CircularProgressIndicator({
    super.key,
    required this.value,
    this.label,
    this.color,
    this.strokeWidth = 4.0,
    this.size = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            color: color ?? AppConstants.primaryColor,
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            label!,
            style: AppConstants.bodyStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
