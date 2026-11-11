import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/app_theme.dart';
import '../../../core/messages.dart';
import '../../../widgets/password_field.dart';
import '../controllers/login_controller.dart';
import 'login_button.dart';
import 'login_error_box.dart';
import 'login_texts.dart';

class CredentialsFields extends GetView<LoginController> {
  const CredentialsFields({super.key});

  bool get _filled => controller.email.text.trim().isNotEmpty && controller.password.text.isNotEmpty;

  void _submit() {
    if (_filled && !controller.loading.value) controller.submitCredentials();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          Messages.authLoginTitle,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.text),
        ),
        const SizedBox(height: 4),
        const Text(LoginTexts.credentialsSubtitle, style: TextStyle(fontSize: 14, color: AppColors.muted)),
        const SizedBox(height: 20),
        TextField(
          controller: controller.email,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(
            labelText: Messages.authEmail,
            prefixIcon: Icon(Icons.mail_outline),
          ),
        ),
        const SizedBox(height: 14),
        PasswordField(
          controller: controller.password,
          labelText: Messages.passwordLabel,
          prefixIcon: const Icon(Icons.lock_outline),
          onSubmitted: (_) => _submit(),
        ),
        const LoginErrorBox(),
        const SizedBox(height: 22),
        ListenableBuilder(
          listenable: Listenable.merge([controller.email, controller.password]),
          builder: (context, _) => LoginButton(
            label: Messages.authSignIn,
            enabled: _filled,
            onPressed: controller.submitCredentials,
          ),
        ),
      ],
    );
  }
}
