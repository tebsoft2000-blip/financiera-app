import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_theme.dart';
import '../controllers/login_controller.dart';

class LoginButton extends GetView<LoginController> {
  const LoginButton({super.key, required this.label, required this.enabled, required this.onPressed});

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.loading.value;
      return SizedBox(
        height: 52,
        width: double.infinity,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: loading ? AppColors.primary : AppColors.primary.withValues(alpha: 0.35),
            disabledForegroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          onPressed: enabled && !loading ? onPressed : null,
          child: loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                )
              : Text(label),
        ),
      );
    });
  }
}
