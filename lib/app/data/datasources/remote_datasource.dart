import 'package:get/get.dart';

import '../../core/api_client.dart';
import '../../core/realtime.dart';

class RemoteDataSource {
  RemoteDataSource(this._api, this._realtime);

  final ApiClient _api;
  final Realtime _realtime;

  RxInt get loading => _api.loading;

  void configure({required void Function() onSessionExpired, required void Function() onForbidden}) {
    _api.onSessionExpired = onSessionExpired;
    _api.onForbidden = onForbidden;
  }

  void setSession(Map<String, dynamic> session) => _api.setSession(session);

  void clearSession() => _api.clearSession();

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    final uri = query == null
        ? path
        : Uri(path: path, queryParameters: query.map((key, value) => MapEntry(key, '$value'))).toString();
    return _api.api('GET', uri);
  }

  Future<dynamic> post(String path, Object body, {bool authenticated = true}) =>
      authenticated ? _api.api('POST', path, body) : _api.publicPost(path, body);

  Future<dynamic> patch(String path, Object body) => _api.api('PATCH', path, body);

  Future<dynamic> delete(String path) => _api.api('DELETE', path);

  void connect(void Function(String reason) onClosed) => _realtime.connect(_api.accessToken, onClosed);

  void disconnect() => _realtime.disconnect();

  void Function() on(String event, void Function(dynamic data) listener) => _realtime.on(event, listener);

  void Function() onAny(List<String> events, void Function(dynamic data) listener) => _realtime.onAny(events, listener);
}
