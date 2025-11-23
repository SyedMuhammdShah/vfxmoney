import 'dart:developer';

import 'package:vfxmoney/core/constants/api_endpoints.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'storage_service.dart';

class SocketService {
  late io.Socket socket;
  final StorageService storageService;

  SocketService(this.storageService) {
    _initSocket();
  }

  void _initSocket() {
    socket = io.io(
      baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setExtraHeaders({
            "Authorization": "Bearer ${storageService.getToken}",
          })
          .build(),
    );
    socket.onConnect((_) => log("Connected"));
    socket.onDisconnect(
      (_) => log("Disconnected for token ${storageService.getToken}"),
    );
    socket.onAny((event, data) {
      log(
        "[Socket] Received event: $event | data: $data",
        name: "socket event",
      );
    });
    socket.onError((data) {
      log("[Socket] On Error: data: $data", name: "socket Error");
    });
  }

  void connect() {
    socket.connect();
    socket.onConnect((data) {
      log("[Socket] Connected! ✅ $data");
    });
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void disconnect() {
    socket.disconnect();
    socket.destroy();
  }
}
