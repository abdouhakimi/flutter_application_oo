import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../utils/input_formatters.dart';
import '../widgets/custom_text_field.dart';

class CurrencyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? Function(String?)? validator;
  final String currencySymbol;
  final int decimalDigits;
  final ValueChanged<String>? onChanged;

  const CurrencyTextField({
    super.key,
    required this.controller,
    this.labelText = 'المبلغ',
    this.validator,
    this.currencySymbol = 'DZ',
    this.decimalDigits = 2,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: labelText,
      keyboardType: TextInputType.number,
      inputFormatters: [
        CurrencyTextInputFormatter(
          currencySymbol: currencySymbol,
          decimalDigits: decimalDigits,
        ),
      ],
      validator: validator,
      onChanged: onChanged,
      prefixIcon: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.smallPadding),
        child: Text(
          currencySymbol,
          style: AppConstants.bodyStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.primaryColor,
          ),
        ),
      ),
    );
  }
}
