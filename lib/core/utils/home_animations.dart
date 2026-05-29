import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeScreenAnimations {
  HomeScreenAnimations(TickerProvider vsync)
    : controller = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 8000),
      ),
      bobController = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 2000),
      )..repeat();

  final AnimationController controller;
  final AnimationController bobController;

  static const double _totalSeconds = 8.0;
  double centerY = 176.0;
  double get littleUpY => (centerY - 85.0).clamp(110.0, 500.0);

  void start() {
    controller.forward();
  }

  void dispose() {
    controller.dispose();
    bobController.dispose();
  }

  double _t(double seconds) => seconds / _totalSeconds;

  double get confettiTriggerProgress => _t(1.6);

  double _intervalValue(
    double start,
    double end, {
    Curve curve = Curves.easeOutCubic,
  }) {
    if (controller.value <= start) {
      return 0.0;
    }
    if (controller.value >= end) {
      return 1.0;
    }

    final double t = (controller.value - start) / (end - start);
    return curve.transform(t.clamp(0.0, 1.0));
  }

  double fade(double start, double end, {Curve curve = Curves.easeOutCubic}) {
    return _intervalValue(start, end, curve: curve);
  }

  double scale(
    double start,
    double end, {
    double begin = 0.9,
    double finish = 1.0,
    Curve curve = Curves.easeOutBack,
  }) {
    return begin + (finish - begin) * _intervalValue(start, end, curve: curve);
  }

  double _piecewiseTravel(double value, List<_TimelinePoint> points) {
    if (points.isEmpty) {
      return 0;
    }
    if (value <= points.first.t) {
      return points.first.value;
    }
    for (int i = 0; i < points.length - 1; i++) {
      final _TimelinePoint current = points[i];
      final _TimelinePoint next = points[i + 1];
      if (value <= next.t) {
        final double localT = ((value - current.t) / (next.t - current.t))
            .clamp(0.0, 1.0);
        return ui.lerpDouble(
              current.value,
              next.value,
              next.curve.transform(localT),
            ) ??
            next.value;
      }
    }
    return points.last.value;
  }

  double get backgroundReveal => fade(_t(0.0), _t(1.0), curve: Curves.easeOut);

  double get walletOpacity => fade(_t(0.4), _t(0.8));
  double get walletScale => scale(
    _t(0.4),
    _t(1.6),
    begin: 0.94,
    finish: 1.0,
    curve: Curves.easeInOut,
  );
  double get walletTravelY {
    if (controller.value <= _t(0.4)) {
      return centerY - 100.0;
    } else if (controller.value <= _t(0.8)) {
      final double progress = (controller.value - _t(0.4)) / (_t(0.8) - _t(0.4));
      return ui.lerpDouble(
        centerY - 100.0,
        centerY - 80.0,
        Curves.easeOut.transform(progress),
      )!;
    } else if (controller.value <= _t(1.6)) {
      final double progress = (controller.value - _t(0.8)) / (_t(1.6) - _t(0.8));
      return ui.lerpDouble(
        centerY - 80.0,
        centerY,
        Curves.easeOutCubic.transform(progress),
      )!;
    } else if (controller.value <= _t(3.2)) {
      return centerY;
    } else if (controller.value <= _t(3.8)) {
      final double progress = (controller.value - _t(3.2)) / (_t(3.8) - _t(3.2));
      return ui.lerpDouble(
        centerY,
        centerY - 30.0,
        Curves.easeInOutCubic.transform(progress),
      )!;
    } else if (controller.value <= _t(4.8)) {
      return centerY - 30.0;
    } else if (controller.value <= _t(5.8)) {
      final double progress = (controller.value - _t(4.8)) / (_t(5.8) - _t(4.8));
      return ui.lerpDouble(
        centerY - 30.0,
        10.0,
        Curves.easeInOutCubic.transform(progress),
      )!;
    } else {
      return 10.0;
    }
  }
  double get walletWobbleRotation =>
      math.sin(bobController.value * math.pi * 2) *
      _piecewiseTravel(controller.value, <_TimelinePoint>[
        _TimelinePoint(_t(0.0), 0.0),
        _TimelinePoint(_t(5.8), 0.0),
        _TimelinePoint(_t(6.6), 0.03, curve: Curves.easeOut),
      ]);
  double get walletBobOffset =>
      math.sin(bobController.value * math.pi * 2) *
      _piecewiseTravel(controller.value, <_TimelinePoint>[
        _TimelinePoint(_t(0.0), 0.0),
        _TimelinePoint(_t(5.8), 0.0),
        _TimelinePoint(_t(6.6), 2.0, curve: Curves.easeOut),
      ]);

  double get wordmarkOpacity => fade(_t(3.8), _t(4.4));
  double get wordmarkLift => (1 - _intervalValue(_t(3.8), _t(4.4))) * 20;

  double get moneyOpacity => fade(_t(4.2), _t(4.8));
  double get moneyLift => (1 - _intervalValue(_t(4.2), _t(4.8))) * 20;
  double get moneyScale => scale(
    _t(4.2),
    _t(4.8),
    begin: 0.85,
    finish: 1.0,
    curve: Curves.easeOutBack,
  );

  double cardOpacity(int index) {
    final double start = 5.8 + (index * 0.2);
    return fade(_t(start), _t(start + 0.6));
  }

  double cardLift(int index) {
    final double start = 5.8 + (index * 0.2);
    return (1 - _intervalValue(_t(start), _t(start + 0.6), curve: Curves.easeOutBack)) * 60;
  }

  double get settingsOpacity => fade(_t(6.6), _t(7.6));
  double get settingsScale => scale(
    _t(6.6),
    _t(7.6),
    begin: 0.92,
    finish: 1.0,
    curve: Curves.easeOutBack,
  );

  double get chromeOpacity => fade(_t(6.6), _t(7.6));
  double get chromeScale => scale(
    _t(6.6),
    _t(7.6),
    begin: 0.92,
    finish: 1.0,
    curve: Curves.easeOutBack,
  );
}

class _TimelinePoint {
  const _TimelinePoint(this.t, this.value, {this.curve = Curves.easeOutCubic});

  final double t;
  final double value;
  final Curve curve;
}
