import 'dart:async';
import 'dart:convert';

import 'package:exchange_api/app/domain/models/ws_status/ws_status.dart';
import 'package:exchange_api/app/domain/repositories/ws_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsRepositoryImpl implements WsRepository {
  final WebSocketChannel Function(List<String> ids) builder;
  WebSocketChannel? _channel;
  final Duration _reconnectDuration;
  StreamController<Map<String, double>>? _controller;
  StreamController<WsStatus>? _wsController;
  StreamSubscription? _subscription;
  Timer? _timer;

  //*Conexion al WebSocket
  WsRepositoryImpl(this.builder,
      [this._reconnectDuration = const Duration(seconds: 5)]);
  @override
  Future<bool> connect(List<String> ids) async {
    try {
      const WsStatus.connecting();
      _channel = builder(ids);
      await _channel!.ready;
      _subscription = _channel!.stream.listen(
        (
          event,
        ) {
          final map = Map<String, String>.from(jsonDecode(event));
          final data = <String, double>{};
          data.addEntries(
            map.entries.map(
              (e) => MapEntry(
                e.key,
                double.parse(e.value),
              ),
            ),
          );

          if (_controller?.hasListener ?? false) {
            _controller!.add(data);
          }
        },
        onDone: () {
          _reconnect(ids);
        },
      );
      _notifyStatus(
        const WsStatus.connected(),
      );
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      _reconnect(ids);
      return false;
    }
  }

  void _reconnect(List<String> ids) {
    if (_subscription != null) {
      _timer?.cancel();
      _timer = Timer(_reconnectDuration, () {
        connect(ids);
      });
    }
  }

  void _notifyStatus(WsStatus status) {
    if (_subscription == null) {
      return;
    }

    if (_wsController?.hasListener ?? false) {
      _wsController!.add(status);
    }
  }

//*Desconexion al WebSocket
  @override
  Future<void> disconnect() async {
    _timer?.cancel();
    _timer = null;
    _subscription?.cancel();
    _subscription = null;
    await _controller?.close();
    await _wsController?.close();
    await _channel?.sink.close();
    _channel = null;
  }

  @override
  Stream<Map<String, double>> get onPricesChanged {
    _controller ??= StreamController.broadcast();
    return _controller!.stream;
  }

  @override
  Stream<WsStatus> get onStatusChanged {
    _wsController ??= StreamController.broadcast();
    return _wsController!.stream;
  }
}
