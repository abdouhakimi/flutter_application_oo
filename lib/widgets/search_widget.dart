import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../widgets/custom_text_field.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final Widget? suffixIcon;

  const SearchWidget({
    super.key,
    required this.controller,
    this.hintText = 'بحث',
    this.onChanged,
    this.onClear,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      labelText: hintText,
      prefixIcon: const Icon(
        Icons.search,
        color: AppConstants.primaryColor,
      ),
      suffixIcon: controller.text.isNotEmpty
          ? IconButton(
              icon: const Icon(
                Icons.clear,
                color: AppConstants.primaryColor,
              ),
              onPressed: () {
                controller.clear();
                onChanged?.call('');
                onClear?.call();
              },
            )
          : suffixIcon,
      onChanged: onChanged,
    );
  }
}
