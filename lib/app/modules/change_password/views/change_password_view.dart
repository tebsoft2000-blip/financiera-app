import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/messages.dart';
import '../../../widgets/common_widgets.dart';
import '../../../widgets/password_field.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Obx(() {
                final saving = controller.loading.value;
                final error = controller.error.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Align(alignment: Alignment.centerLeft, child: Brand()),
                    const SizedBox(height: 32),
                    const Text(Messages.passwordCreateTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    PasswordField(controller: controller.current, labelText: Messages.passwordCurrent),
                    const SizedBox(height: 12),
                    PasswordField(
                      controller: controller.next,
                      labelText: Messages.passwordNew,
                      helperText: Messages.passwordRequirements,
                      onSubmitted: (_) => saving ? null : controller.submit(),
                    ),
                    if (error != null) ...[
                      const SizedBox(height: 12),
                      Message(error),
                    ],
                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                      onPressed: saving ? null : controller.submit,
                      child: Text(saving ? Messages.commonSaving : Messages.passwordSave),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
