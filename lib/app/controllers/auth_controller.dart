import 'dart:async';

import 'package:get/get.dart';

import '../core/messages.dart';
import '../data/models/user_model.dart';
import '../data/repositories/app_repository.dart';
import '../routes/app_routes.dart';
import '../states/auth_state.dart';

class AuthController extends GetxController {
  AuthController(this._repository);

  final state = AuthState();
  static const _idleMinutes = 10;
  static const _invalidReasons = {'TOKEN_MISSING', 'TOKEN_INVALID', 'SESSION_REVOKED'};

  final AppRepository _repository;
  final _offs = <void Function()>[];
  Timer? _idle;

  bool loggedOutManually = false;
  bool offerBiometric = false;
  late final Future<void> whenReady;

  RxInt get loading => _repository.loading;

  @override
  void onInit() {
    super.onInit();
    _repository.configure(
      onSessionExpired: () => endSession(Messages.authSessionEnded),
      onForbidden: () => reload().catchError((_) {}),
    );
    whenReady = _load();
  }

  @override
  void onReady() {
    super.onReady();
    everAll([state.ready, state.user], (_) => _redirect());
    _redirect();
  }

  String get _route {
    if (!state.ready.value) return Routes.splash;
    final current = state.user.value;
    if (current == null) return Routes.login;
    return current.mustChangePassword ? Routes.changePassword : Routes.home;
  }

  void _redirect() {
    final route = _route;
    if (Get.currentRoute != route) Get.offAllNamed(route);
  }

  Future<void> _load() async {
    try {
      state.hasBiometric.value = await _repository.loadBiometric();
    } catch (_) {}
    state.ready.value = true;
  }

  bool can(String permission) => state.permissions.contains(permission);

  void startSession(Map<String, dynamic> session, {bool offerBiometric = false}) {
    this.offerBiometric = offerBiometric;
    state.notice.value = '';
    _apply(session);
    _openSocket();
    _listen();
    touch();
  }

  Future<void> reload() async {
    _apply(await _repository.me());
  }

  Future<void> resume() async {
    if (state.user.value == null) return;
    try {
      await reload();
      _openSocket();
    } catch (_) {
      _repository.disconnect();
    }
  }

  Future<void> logout([String message = '']) async {
    loggedOutManually = true;
    await _repository.logout().catchError((_) {});
    endSession(message);
  }

  Future<void> disableBiometric() async {
    await _repository.disableBiometric();
    state.hasBiometric.value = false;
  }

  void touch() {
    if (state.user.value == null) return;
    _idle?.cancel();
    _idle = Timer(const Duration(minutes: _idleMinutes), () => logout(Messages.authIdleLogout));
  }

  void _apply(Map<String, dynamic> data) {
    state.user.value = User.fromJson(data['user'] as Map<String, dynamic>);
    state.permissions.assignAll(List<String>.from(data['permissions'] as List));
  }

  void _openSocket() {
    _repository.connect((reason) {
      if (state.user.value == null) return;
      if (_invalidReasons.contains(reason)) {
        endSession(Messages.authSessionEnded);
      } else {
        resume();
      }
    });
  }

  void _listen() {
    _stopListening();
    _offs.add(_repository.onRolesChanged(() => reload().ignore()));
    _offs.add(_repository.onPatched((data) {
      if (data is Map && data['id'] == state.user.value?.id) reload().ignore();
    }));
  }

  void _stopListening() {
    for (final off in _offs) {
      off();
    }
    _offs.clear();
  }

  void endSession(String message) {
    _idle?.cancel();
    _stopListening();
    _repository.disconnect();
    _repository.clearSession();
    offerBiometric = false;
    state.user.value = null;
    state.permissions.clear();
    state.notice.value = message;
  }
}
