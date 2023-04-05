import 'package:flutter/scheduler.dart';

// class RefreshRateTicker extends Ticker {
//   RefreshRateTicker(super._onTick);
//
//   tick(Duration duration) {}
// }

class RefreshRateTickerProvider extends TickerProvider {
  final int fps;
  Function(Duration)? onTick;

  Ticker? _ticker;
  Duration _duration = const Duration();

  RefreshRateTickerProvider({required this.fps});

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

    if (diff.inMilliseconds >= 1000 / fps) {
      SchedulerBinding.instance
          .addPostFrameCallback((timeStamp) => _onTick(duration));
      _duration = duration;
    }
  }

  _onTick(Duration duration) {
    onTick?.call(duration);
  }
}
