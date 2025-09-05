import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final Color? cancelColor;
  final IconData? icon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.cancelColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: confirmColor ?? AppConstants.primaryColor,
            ),
            const SizedBox(width: AppConstants.smallPadding),
          ],
          Expanded(
            child: Text(
              title,
              style: AppConstants.titleStyle,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: AppConstants.bodyStyle,
      ),
      actions: [
        CustomButton(
          text: cancelText ?? 'إلغاء',
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
          backgroundColor: cancelColor ?? Colors.grey,
        ),
        const SizedBox(width: AppConstants.smallPadding),
        CustomButton(
          text: confirmText ?? 'تأكيد',
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          backgroundColor: confirmColor ?? AppConstants.primaryColor,
        ),
      ],
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    Color? confirmColor,
    Color? cancelColor,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmColor: confirmColor,
        cancelColor: cancelColor,
        icon: icon,
      ),
    );
  }
}
