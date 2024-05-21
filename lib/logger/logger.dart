import 'package:flutter/foundation.dart';

class Logger {
  static final Logger _instance = Logger._internal();

  factory Logger() {
    return _instance;
  }

  Logger._internal();

  static bool force = true;

  static void vpn(String msg) {
    if (kDebugMode || force) {
      print('[VPN]:$msg');
    }
  }

  static void event(dynamic msg) {
    if (kDebugMode || force) {
      print('[EVENT]:$msg');
    }
  }
}
