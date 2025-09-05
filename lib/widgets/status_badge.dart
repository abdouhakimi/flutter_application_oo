import 'package:flutter/material.dart';
import '../utils/constants.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusType type;
  final IconData? icon;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const StatusBadge({
    super.key,
    required this.text,
    required this.type,
    this.icon,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: AppConstants.smallPadding,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _getBackgroundColor(type),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(
          color: _getBorderColor(type),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: fontSize ?? 14,
              color: _getTextColor(type),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: _getTextColor(type),
              fontSize: fontSize ?? 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(StatusType type) {
    switch (type) {
      case StatusType.success:
        return AppConstants.successColor.withOpacity(0.1);
      case StatusType.warning:
        return AppConstants.warningColor.withOpacity(0.1);
      case StatusType.error:
        return AppConstants.errorColor.withOpacity(0.1);
      case StatusType.info:
        return AppConstants.primaryColor.withOpacity(0.1);
      case StatusType.neutral:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Color _getBorderColor(StatusType type) {
    switch (type) {
      case StatusType.success:
        return AppConstants.successColor.withOpacity(0.3);
      case StatusType.warning:
        return AppConstants.warningColor.withOpacity(0.3);
      case StatusType.error:
        return AppConstants.errorColor.withOpacity(0.3);
      case StatusType.info:
        return AppConstants.primaryColor.withOpacity(0.3);
      case StatusType.neutral:
        return Colors.grey.withOpacity(0.3);
    }
  }

  Color _getTextColor(StatusType type) {
    switch (type) {
      case StatusType.success:
        return AppConstants.successColor;
      case StatusType.warning:
        return AppConstants.warningColor;
      case StatusType.error:
        return AppConstants.errorColor;
      case StatusType.info:
        return AppConstants.primaryColor;
      case StatusType.neutral:
        return Colors.grey[700]!;
    }
  }
}

enum StatusType {
  success,
  warning,
  error,
  info,
  neutral,
}
