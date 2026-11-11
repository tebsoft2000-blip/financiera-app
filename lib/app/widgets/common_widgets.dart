import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../core/app_theme.dart';
import '../core/messages.dart';

export '../core/app_theme.dart';

class Brand extends StatelessWidget {
  const Brand({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.5, 0.5],
              colors: [AppColors.primary, AppColors.brass],
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Text(Messages.commonAppName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
      ],
    );
  }
}

class Message extends StatelessWidget {
  const Message(this.text, {super.key, this.isError = true});

  final String text;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.danger : AppColors.brass;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Text(text, style: TextStyle(color: isError ? AppColors.danger : null)),
    );
  }
}

class LoadingBar extends GetView<AuthController> {
  const LoadingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.loading.value > 0
          ? const SafeArea(
              bottom: false,
              child: LinearProgressIndicator(minHeight: 3, color: AppColors.brass),
            )
          : const SizedBox.shrink(),
    );
  }
}

Future<bool> confirm(String title, String message) async {
  final result = await showDialog<bool>(
    context: Get.context!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text(Messages.commonCancel)),
        FilledButton(onPressed: () => Get.back(result: true), child: const Text(Messages.commonDelete)),
      ],
    ),
  );
  return result ?? false;
}

void showSnackbar(String message) {
  ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(content: Text(message)));
}
