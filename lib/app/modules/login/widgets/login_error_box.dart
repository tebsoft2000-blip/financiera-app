import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_theme.dart';
import '../controllers/login_controller.dart';

class LoginErrorBox extends GetView<LoginController> {
  const LoginErrorBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final message = controller.error.value;
      if (message == null || message.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(message, style: const TextStyle(color: AppColors.error, fontSize: 14, height: 1.35)),
              ),
            ],
          ),
        ),
      );
    });
  }
}
