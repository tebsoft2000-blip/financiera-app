import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_theme.dart';
import '../../../core/messages.dart';
import '../controllers/login_controller.dart';

class BiometricButton extends GetView<LoginController> {
  const BiometricButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final loading = controller.loading.value;
      final onTap = loading ? null : controller.loginWithBiometric;
      return Semantics(
        button: true,
        label: Messages.biometricLogin,
        excludeSemantics: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: loading ? AppColors.accent.withValues(alpha: 0.5) : AppColors.accent,
              shape: const CircleBorder(),
              elevation: 6,
              shadowColor: AppColors.accent.withValues(alpha: 0.5),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: const SizedBox(
                  width: 76,
                  height: 76,
                  child: Icon(Icons.fingerprint, color: Colors.white, size: 42),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onTap,
              child: const Text(
                Messages.biometricLogin,
                style: TextStyle(color: AppColors.accent, fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    });
  }
}
