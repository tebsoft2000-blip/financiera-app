import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/base_controller.dart';
import '../../../core/messages.dart';
import '../../../data/repositories/app_repository.dart';
import '../states/login_state.dart';

class LoginController extends BaseController {
  LoginController(this.auth, this._repository);

  final state = LoginState();
  final AuthController auth;
  final AppRepository _repository;
  final email = TextEditingController();
  final password = TextEditingController();
  final code = TextEditingController();

  @override
  void onReady() {
    super.onReady();
    _autoPrompt();
  }

  Future<void> _autoPrompt() async {
    await auth.whenReady;
    if (!isClosed && auth.state.hasBiometric.value && !auth.loggedOutManually) loginWithBiometric();
    auth.loggedOutManually = false;
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    code.dispose();
    super.onClose();
  }

  void submitCredentials() => run(() async {
    final id = await _repository.login(email.text.trim(), password.text);
    password.clear();
    state.otpId.value = id;
  }, showError: false);

  void submitCode() => run(() async {
    final session = await _repository.verifyOtp(state.otpId.value!, code.text);
    auth.startSession(session, offerBiometric: !auth.state.hasBiometric.value);
  }, showError: false);

  void loginWithBiometric() => run(_loginWithBiometric, showError: false);

  Future<void> _loginWithBiometric() async {
    if (!await _repository.authenticate(Messages.biometricConfirmLogin)) return;
    final session = await _repository.biometricLogin();
    if (session == null) {
      auth.state.hasBiometric.value = false;
      auth.endSession(Messages.biometricExpired);
      return;
    }
    auth.startSession(session);
  }

  void restart() {
    state.otpId.value = null;
    code.clear();
    error.value = null;
  }
}
