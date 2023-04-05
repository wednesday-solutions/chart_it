import 'package:flutter/foundation.dart';

abstract class ChartController {
  VoidCallback? _listener;

  void addListener(VoidCallback listener) {
    _listener = listener;
  }

  void notifyListeners() {
    _listener?.call();
  }

  @mustCallSuper
  void dispose() {
    _listener = null;
  }
}
