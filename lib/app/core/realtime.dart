import 'package:socket_io_client/socket_io_client.dart' as io;

import 'config.dart';

class Events {
  static const usersCreated = 'users created';
  static const usersPatched = 'users patched';
  static const usersRemoved = 'users removed';
  static const rolesCreated = 'roles created';
  static const rolesPatched = 'roles patched';
  static const rolesRemoved = 'roles removed';

  static const userEvents = [usersCreated, usersPatched, usersRemoved];
  static const roleEvents = [rolesCreated, rolesPatched, rolesRemoved];
  static const all = [...userEvents, ...roleEvents];
}

class Realtime {
  final _listeners = <String, Set<void Function(dynamic)>>{};
  io.Socket? _socket;

  void connect(String token, void Function(String reason) onClosed) {
    disconnect();
    final socket = io.io(apiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {'token': token},
      'autoConnect': false,
      'forceNew': true,
      'reconnection': false,
    });

    for (final event in Events.all) {
      socket.on(event, (data) {
        for (final listener in List.of(_listeners[event] ?? <void Function(dynamic)>{})) {
          listener(data);
        }
      });
    }
    socket.on('error', (reason) => onClosed('$reason'));
    socket.onDisconnect((reason) {
      if (reason != 'io client disconnect') onClosed('$reason');
    });

    _socket = socket;
    socket.connect();
  }

  void disconnect() {
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket = null;
  }

  void Function() on(String event, void Function(dynamic data) listener) {
    _listeners.putIfAbsent(event, () => <void Function(dynamic)>{}).add(listener);
    return () => _listeners[event]?.remove(listener);
  }

  void Function() onAny(List<String> events, void Function(dynamic data) listener) {
    final offs = [for (final event in events) on(event, listener)];
    return () {
      for (final off in offs) {
        off();
      }
    };
  }
}
