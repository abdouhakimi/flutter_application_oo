import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  static Future<ConnectivityResult> getConnectionType() async {
    return await Connectivity().checkConnectivity();
  }

  static Stream<ConnectivityResult> get connectionStream {
    return Connectivity().onConnectivityChanged;
  }

  static String getConnectionTypeString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'No Connection';
    }
  }

  static bool isSlowConnection(ConnectivityResult result) {
    return result == ConnectivityResult.mobile;
  }

  static Future<void> waitForConnection({Duration timeout = const Duration(seconds: 30)}) async {
    final stopwatch = Stopwatch()..start();
    
    while (stopwatch.elapsed < timeout) {
      if (await isConnected()) {
        return;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    
    throw Exception('Connection timeout');
  }
}
