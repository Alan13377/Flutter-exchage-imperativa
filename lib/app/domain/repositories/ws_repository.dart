//*Conectarnos al webSocket
import 'package:exchange_api/app/data/repository_impl/ws_repository_impl.dart';
import 'package:exchange_api/app/domain/models/ws_status/ws_status.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class WsRepository {
  //*Conectar y desconectar al websocket
  Future<bool> connect(List<String> ids);
  Stream<Map<String, double>> get onPricesChanged;
  Stream<WsStatus> get onStatusChanged;
  Future<void> disconnect();
}

final wsRepositoryProvider = Provider(
  (ref) => WsRepositoryImpl(
    (ids) => WebSocketChannel.connect(
        Uri.parse("wss://ws.coincap.io/prices?assets=${ids.join(',')}")),
  ),
);
