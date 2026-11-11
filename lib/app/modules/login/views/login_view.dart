import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/common_widgets.dart';
import '../controllers/login_controller.dart';
import '../widgets/biometric_button.dart';
import '../widgets/credentials_fields.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_header.dart';
import '../widgets/otp_fields.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  static const _overlap = 48.0;

  @override
  Widget build(BuildContext context) {
    final headerHeight = math.max(MediaQuery.sizeOf(context).height * 0.35, 220.0);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Stack(
                    children: [
                      LoginHeader(height: headerHeight, overlap: _overlap),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, headerHeight - _overlap, 20, 0),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 440),
                            child: _card(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => !controller.state.otpStep && controller.auth.state.hasBiometric.value
                        ? const Padding(padding: EdgeInsets.only(top: 28), child: BiometricButton())
                        : const SizedBox.shrink(),
                  ),
                  const Spacer(),
                  const SafeArea(
                    top: false,
                    child: Padding(padding: EdgeInsets.fromLTRB(20, 32, 20, 16), child: LoginFooter()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _card(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.background,
          prefixIconColor: AppColors.muted,
          suffixIconColor: AppColors.muted,
          labelStyle: const TextStyle(color: AppColors.muted),
          floatingLabelStyle: const TextStyle(color: AppColors.primary),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: radius, borderSide: const BorderSide(color: AppColors.border)),
          enabledBorder: OutlineInputBorder(borderRadius: radius, borderSide: const BorderSide(color: AppColors.border)),
          focusedBorder: OutlineInputBorder(borderRadius: radius, borderSide: const BorderSide(color: AppColors.primary, width: 1.6)),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: AppColors.primaryDark.withValues(alpha: 0.10), blurRadius: 30, offset: const Offset(0, 12)),
          ],
        ),
        child: Obx(() {
          final otpStep = controller.state.otpStep;
          final notice = controller.auth.state.notice.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (!otpStep && notice.isNotEmpty) ...[
                Message(notice, isError: false),
                const SizedBox(height: 20),
              ],
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: otpStep ? const OtpFields(key: ValueKey('otp')) : const CredentialsFields(key: ValueKey('credentials')),
              ),
            ],
          );
        }),
      ),
    );
  }
}
