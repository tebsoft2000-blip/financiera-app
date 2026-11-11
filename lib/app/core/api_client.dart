import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'app_exception.dart';
import 'config.dart';
import 'endpoints.dart';
import 'messages.dart';

class ApiClient {
  final loading = 0.obs;
  String accessToken = '';
  String _refreshToken = '';
  Future<void>? _refreshing;
  void Function()? onSessionExpired;
  void Function()? onForbidden;

  void setSession(Map<String, dynamic> session) {
    accessToken = session['accessToken'] as String;
    _refreshToken = session['refreshToken'] as String;
  }

  void clearSession() {
    accessToken = '';
    _refreshToken = '';
  }

  Future<dynamic> publicPost(String path, Object body) => _send('POST', path, body: body);

  Future<dynamic> api(String method, String path, [Object? body]) async {
    try {
      return await _send(method, path, body: body, token: accessToken);
    } on AppException catch (error) {
      if (error.statusCode != 401) rethrow;
      if (error.code != 'TOKEN_EXPIRED') {
        _expire();
        rethrow;
      }
    }

    try {
      await _refresh();
      return await _send(method, path, body: body, token: accessToken);
    } on AppException catch (error) {
      if (error.statusCode == 401) _expire();
      rethrow;
    }
  }

  Future<void> _refresh() {
    return _refreshing ??= _send(
      'POST',
      Endpoints.refresh,
      body: {'refreshToken': _refreshToken},
    ).then((session) => setSession(session as Map<String, dynamic>)).whenComplete(() => _refreshing = null);
  }

  void _expire() {
    clearSession();
    onSessionExpired?.call();
  }

  void _changeLoading(int delta) => scheduleMicrotask(() => loading.value += delta);

  Future<dynamic> _send(String method, String path, {Object? body, String? token}) async {
    _changeLoading(1);
    try {
      final response = await _request(method, path, body, token);
      final data = _decode(response);
      if (response.statusCode == 403 && token != null) onForbidden?.call();
      if (response.statusCode >= 400) {
        final map = data is Map ? data : const {};
        final details = map['data'];
        throw AppException(
          (map['message'] as String?) ?? Messages.errorUnexpected,
          statusCode: response.statusCode,
          code: details is Map ? details['reason'] as String? : null,
        );
      }
      return data;
    } finally {
      _changeLoading(-1);
    }
  }

  Future<http.Response> _request(String method, String path, Object? body, String? token) async {
    final request = http.Request(method, Uri.parse('$apiUrl$path'));
    request.headers['content-type'] = 'application/json';
    if (token != null && token.isNotEmpty) request.headers['authorization'] = 'Bearer $token';
    if (body != null) request.body = jsonEncode(body);

    try {
      final streamed = await request.send().timeout(const Duration(seconds: 20));
      return await http.Response.fromStream(streamed);
    } catch (_) {
      throw AppException(Messages.errorConnection);
    }
  }

  dynamic _decode(http.Response response) {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      return null;
    }
  }
}
