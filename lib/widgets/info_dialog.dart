import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final Color? buttonColor;
  final IconData? icon;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonPressed,
    this.buttonColor,
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
              color: buttonColor ?? AppConstants.primaryColor,
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
          text: buttonText ?? 'موافق',
          onPressed: () {
            onButtonPressed?.call();
            Navigator.of(context).pop();
          },
          backgroundColor: buttonColor ?? AppConstants.primaryColor,
        ),
      ],
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonText,
    VoidCallback? onButtonPressed,
    Color? buttonColor,
    IconData? icon,
  }) {
    return showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        buttonColor: buttonColor,
        icon: icon,
      ),
    );
  }
}
