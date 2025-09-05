import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_text_field.dart';

class DatePickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime>? onDateSelected;
  final String? Function(String?)? validator;

  const DatePickerWidget({
    super.key,
    required this.controller,
    this.labelText = 'التاريخ',
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: labelText,
      readOnly: true,
      onTap: () => _selectDate(context),
      validator: validator,
      suffixIcon: IconButton(
        icon: const Icon(Icons.calendar_today),
        onPressed: () => _selectDate(context),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
      locale: const Locale('ar', ''),
    );

    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      onDateSelected?.call(picked);
    }
  }
}
