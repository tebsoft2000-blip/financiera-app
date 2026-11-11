import 'package:flutter/material.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/base_controller.dart';
import '../../../core/messages.dart';
import '../../../data/repositories/app_repository.dart';

class ChangePasswordController extends BaseController {
  ChangePasswordController(this._auth, this._repository);

  final AuthController _auth;
  final AppRepository _repository;
  final current = TextEditingController();
  final next = TextEditingController();

  @override
  void onClose() {
    current.dispose();
    next.dispose();
    super.onClose();
  }

  Future<void> submit() => run(() async {
    await _repository.changePassword(current.text, next.text);
    await _auth.logout(Messages.passwordUpdated);
  }, showError: false);
}
