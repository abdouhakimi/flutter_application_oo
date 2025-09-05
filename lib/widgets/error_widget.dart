import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: 64,
            color: AppConstants.errorColor,
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Text(
            'حدث خطأ',
            style: AppConstants.titleStyle.copyWith(
              color: AppConstants.errorColor,
            ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            message,
            style: AppConstants.bodyStyle,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppConstants.largePadding),
            CustomButton(
              text: 'إعادة المحاولة',
              onPressed: onRetry,
              icon: Icons.refresh,
            ),
          ],
        ],
      ),
    );
  }
}
