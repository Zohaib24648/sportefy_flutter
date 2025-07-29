import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class NotificationToggle extends StatefulWidget {
  const NotificationToggle({super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> {
  bool _isEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: _isEnabled,
      onChanged: (value) {
        setState(() {
          _isEnabled = value;
        });
        // TODO: Integrate with NotificationBloc when available
      },
      activeColor: AppColors.primary,
    );
  }
}
