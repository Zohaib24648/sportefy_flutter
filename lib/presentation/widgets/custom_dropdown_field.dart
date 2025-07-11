//lib/presentation/widgets/custom_dropdown_field.dart
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../utils/responsive_helper.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final T? value;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const CustomDropdownField({
    super.key,
    this.value,
    required this.hintText,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  State<CustomDropdownField<T>> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  String? _errorText;

  void _validateInput(T? value) {
    if (widget.validator != null) {
      setState(() {
        _errorText = widget.validator!(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            vertical: ResponsiveHelper.getResponsiveSpacing(context, 4),
          ),
          decoration: BoxDecoration(
            color: AppColors.cardColor,
            borderRadius: BorderRadius.circular(14),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 8,
                offset: Offset(0, 2),
                spreadRadius: 0,
              ),
            ],
          ),
          child: DropdownButtonFormField<T>(
            value: widget.value,
            items: widget.items,
            onChanged: (value) {
              _validateInput(value);
              widget.onChanged?.call(value);
            },
            style: AppStyles.textFieldStyle(context),
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppStyles.hintTextStyle(context),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsiveSpacing(context, 24),
                vertical: ResponsiveHelper.getResponsiveSpacing(context, 18),
              ),
            ),
            dropdownColor: AppColors.cardColor,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              top: 4,
              right: 16,
              bottom: 8,
            ),
            child: Text(
              _errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
