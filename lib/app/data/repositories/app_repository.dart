import 'package:get/get.dart';

import '../../core/app_exception.dart';
import '../../core/endpoints.dart';
import '../../core/realtime.dart';
import '../datasources/local_datasource.dart';
import '../datasources/remote_datasource.dart';
import '../models/paged_result.dart';

class AppRepository {
  AppRepository(this._remote, this._local);

  static const _refreshTokenKey = 'refreshToken';
  static const _deviceTokenKey = 'deviceToken';

  final RemoteDataSource _remote;
  final LocalDataSource _local;

  RxInt get loading => _remote.loading;

  Future<PagedResult<T>> list<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? query,
  }) async {
    final result = await _remote.get(path, query: query);
    if (result is Map<String, dynamic>) {
      return PagedResult(
        items: (result['data'] as List).map((item) => fromJson(item as Map<String, dynamic>)).toList(),
        total: result['total'] as int,
      );
    }
    final items = (result as List).map((item) => fromJson(item as Map<String, dynamic>)).toList();
    return PagedResult(items: items, total: items.length);
  }

  Future<T> get<T>(String path, int id, T Function(Map<String, dynamic>) fromJson) async =>
      fromJson(await _remote.get('$path/$id') as Map<String, dynamic>);

  Future<T> create<T>(String path, Map<String, dynamic> body, T Function(Map<String, dynamic>) fromJson) async =>
      fromJson(await _remote.post(path, body) as Map<String, dynamic>);

  Future<T> update<T>(
    String path,
    int id,
    Map<String, dynamic> body,
    T Function(Map<String, dynamic>) fromJson,
  ) async => fromJson(await _remote.patch('$path/$id', body) as Map<String, dynamic>);

  Future<void> remove(String path, int id) async {
    await _remote.delete('$path/$id');
  }

  void configure({required void Function() onSessionExpired, required void Function() onForbidden}) =>
      _remote.configure(onSessionExpired: onSessionExpired, onForbidden: onForbidden);

  void clearSession() => _remote.clearSession();

  void connect(void Function(String reason) onClosed) => _remote.connect(onClosed);

  void disconnect() => _remote.disconnect();

  void Function() onUsersChanged(void Function() listener) => _remote.onAny(Events.userEvents, (_) => listener());

  void Function() onPatched(void Function(dynamic data) listener) => _remote.on(Events.usersPatched, listener);

  void Function() onRolesChanged(void Function() listener) => _remote.onAny(Events.roleEvents, (_) => listener());

  Future<bool> loadBiometric() async {
    await _local.delete(_refreshTokenKey);
    return await _local.read(_deviceTokenKey) != null;
  }

  Future<String> login(String email, String password) async {
    final result = await _remote.post(Endpoints.login, {'email': email, 'password': password}, authenticated: false);
    return result['otpId'] as String;
  }

  Future<Map<String, dynamic>> verifyOtp(String otpId, String code) async {
    final session = await _remote.post(Endpoints.verifyOtp, {
      'otpId': otpId,
      'code': code,
    }, authenticated: false) as Map<String, dynamic>;
    _remote.setSession(session);
    return session;
  }

  Future<Map<String, dynamic>?> biometricLogin() async {
    final token = await _local.read(_deviceTokenKey);
    if (token == null) return null;
    final Map<String, dynamic> session;
    try {
      session = await _remote.post(Endpoints.biometricLogin, {
        'deviceToken': token,
      }, authenticated: false) as Map<String, dynamic>;
    } on AppException catch (error) {
      if (error.statusCode != 401) rethrow;
      await _local.delete(_deviceTokenKey);
      return null;
    }
    await _local.write(_deviceTokenKey, session['deviceToken'] as String);
    _remote.setSession(session);
    return session;
  }

  Future<void> logout() async {
    await _remote.post(Endpoints.logout, {});
  }

  Future<Map<String, dynamic>> me() async {
    return await _remote.get(Endpoints.me) as Map<String, dynamic>;
  }

  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _remote.post(Endpoints.changePassword, {'currentPassword': currentPassword, 'newPassword': newPassword});
  }

  Future<void> forceLogout(int userId, bool revokeDevices) async {
    await _remote.post(Endpoints.forceLogout, {'userId': userId, 'revokeDevices': revokeDevices});
  }

  Future<bool> canUseBiometrics() => _local.canUseBiometrics();

  Future<bool> authenticate(String reason) => _local.authenticate(reason);

  Future<void> enableBiometric() async {
    final result = await _remote.post(Endpoints.biometricEnable, {});
    await _local.write(_deviceTokenKey, result['deviceToken'] as String);
  }

  Future<void> disableBiometric() => _local.delete(_deviceTokenKey);
}
