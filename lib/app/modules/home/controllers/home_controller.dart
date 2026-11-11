import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/auth_controller.dart';
import '../../../core/base_controller.dart';
import '../../../core/messages.dart';
import '../../../data/repositories/app_repository.dart';
import '../states/home_state.dart';

class HomeController extends BaseController {
  HomeController(this.auth, this._repository);

  final state = HomeState();
  final AuthController auth;
  final AppRepository _repository;
  late final AppLifecycleListener _lifecycle;

  @override
  void onInit() {
    super.onInit();
    _lifecycle = AppLifecycleListener(onResume: auth.resume);
  }

  @override
  void onReady() {
    super.onReady();
    _offerBiometric();
  }

  @override
  void onClose() {
    _lifecycle.dispose();
    super.onClose();
  }

  Future<void> _offerBiometric() async {
    if (!auth.offerBiometric || auth.state.hasBiometric.value) return;
    auth.offerBiometric = false;
    if (!await _repository.canUseBiometrics() || isClosed) return;
    final accept = await showDialog<bool>(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: const Text(Messages.biometricEnableQuestion),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text(Messages.commonNotNow)),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text(Messages.commonActivate)),
        ],
      ),
    );
    if (accept == true) await _enableBiometric();
  }

  Future<void> _enableBiometric() async {
    if (!await _repository.authenticate(Messages.biometricConfirmEnable)) return;
    await _repository.enableBiometric();
    auth.state.hasBiometric.value = true;
  }

  Future<void> retry() => run(auth.reload, showError: false);
}
