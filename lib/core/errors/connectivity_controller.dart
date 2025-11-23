import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityController {
  ValueNotifier<bool> isConnected = ValueNotifier(false);

  Future<void> init() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();

    isInternetConnected(result[0]);

    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> result,
    ) {
      isInternetConnected(result[0]);
    });
  }

  bool isInternetConnected(ConnectivityResult? result) {
    if (result == ConnectivityResult.none) {
      isConnected.value = false;

      // Future.delayed(const Duration(seconds: 3), () {
      //   isConnected.value = true;
      // });

      return isConnected.value;
    } else if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      isConnected.value = true;

      return isConnected.value;
    }

    return false;
  }
}
