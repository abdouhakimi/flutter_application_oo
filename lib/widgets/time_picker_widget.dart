import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/custom_text_field.dart';

class TimePickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay>? onTimeSelected;
  final String? Function(String?)? validator;

  const TimePickerWidget({
    super.key,
    required this.controller,
    this.labelText = 'الوقت',
    this.initialTime,
    this.onTimeSelected,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: labelText,
      readOnly: true,
      onTap: () => _selectTime(context),
      validator: validator,
      suffixIcon: IconButton(
        icon: const Icon(Icons.access_time),
        onPressed: () => _selectTime(context),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final now = DateTime.now();
      final time = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      controller.text = DateFormat('HH:mm:ss').format(time);
      onTimeSelected?.call(picked);
    }
  }
}
