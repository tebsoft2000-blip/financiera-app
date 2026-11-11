import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class LocalDataSource {
  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();

  Future<String?> read(String key) => _storage.read(key: key);

  Future<void> write(String key, String value) => _storage.write(key: key, value: value);

  Future<void> delete(String key) => _storage.delete(key: key);

  Future<bool> canUseBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics && (await _localAuth.getAvailableBiometrics()).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  Future<bool> authenticate(String reason) async {
    try {
      return await _localAuth.authenticate(localizedReason: reason, biometricOnly: true);
    } on LocalAuthException {
      return false;
    }
  }
}
