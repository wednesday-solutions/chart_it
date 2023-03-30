import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/scheduler.dart';

class FpsTicker extends Ticker {
  FpsTicker(super._onTick);

  tic(Duration dur) {}
}

class FpsTickerProvider extends TickerProvider {
  Function(Duration)? onTick;
  final int fps;
  Ticker? _ticker;

  Duration _duration = const Duration();

  FpsTickerProvider({required this.fps});

  @override
  Ticker createTicker(TickerCallback onTick) {
    this.onTick = onTick;
    _ticker = Ticker(_durationTick);
    return _ticker!;
  }

  _durationTick(Duration duration) {
    final diff = duration - _duration;
    if (diff.inMilliseconds < 0) {
      _duration = const Duration();
      return;
    }

    if (diff.inMilliseconds >= 1000/fps) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        _onTick(duration);
      });
      _duration = duration;
    }
  }

  _onTick(Duration duration) {
    onTick?.call(duration);
  }
}
