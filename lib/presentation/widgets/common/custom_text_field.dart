//lib/presentation/widgets/custom_text_field.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/responsive_helper.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final int? maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;

  void _validateInput(String? value) {
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
            color: AppColors.white,
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
          child: TextField(
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            style: AppTextStyles.body,
            onChanged: _validateInput,
            maxLines: widget.maxLines,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: AppTextStyles.body.copyWith(color: AppColors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: ResponsiveHelper.getResponsiveSpacing(context, 24),
                vertical: ResponsiveHelper.getResponsiveSpacing(context, 18),
              ),
              suffixIcon: widget.suffixIcon,
              prefixIcon: widget.prefixIcon,
            ),
          ),
        ),
        if (_errorText != null)
          Padding(
            padding: EdgeInsets.only(left: 16, top: 4, right: 16, bottom: 8),
            child: Text(
              _errorText!,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(color: AppColors.error),
            ),
          ),
      ],
    );
  }
}
