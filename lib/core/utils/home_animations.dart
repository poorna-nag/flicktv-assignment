import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeScreenAnimations {
  HomeScreenAnimations(TickerProvider vsync)
    : controller = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 8500),
      ),
      bobController = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 2000),
      )..repeat();

  final AnimationController controller;
  final AnimationController bobController;

  static const double _totalSeconds = 8.5;

  void start() {
    controller.forward();
  }

  void dispose() {
    controller.dispose();
    bobController.dispose();
  }

  double _t(double seconds) => seconds / _totalSeconds;

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

  double get backgroundReveal => fade(_t(0.0), _t(0.2), curve: Curves.easeOut);

  double get walletOpacity => fade(_t(0.0), _t(0.2));
  double get walletScale => scale(
    _t(0.2),
    _t(1.2),
    begin: 0.95,
    finish: 1.0,
    curve: Curves.easeInOut,
  );
  double get walletTravelY =>
      _piecewiseTravel(controller.value, <_TimelinePoint>[
        _TimelinePoint(0.0, 0.0),
        _TimelinePoint(_t(0.2), 0.0),
        _TimelinePoint(_t(1.2), 90.0, curve: Curves.easeInOutCubic),
        _TimelinePoint(_t(1.6), 90.0),
        _TimelinePoint(_t(2.6), -22.0, curve: Curves.easeInOutCubic),
        _TimelinePoint(_t(5.4), -22.0),
      ]);
  double get walletWobbleRotation =>
      math.sin(bobController.value * math.pi * 2) *
      _piecewiseTravel(controller.value, <_TimelinePoint>[
        _TimelinePoint(_t(0.0), 0.0),
        _TimelinePoint(_t(6.4), 0.0),
        _TimelinePoint(_t(6.8), 0.03, curve: Curves.easeOut),
      ]);
  double get walletBobOffset =>
      math.sin(bobController.value * math.pi * 2) *
      _piecewiseTravel(controller.value, <_TimelinePoint>[
        _TimelinePoint(_t(0.0), 0.0),
        _TimelinePoint(_t(6.4), 0.0),
        _TimelinePoint(_t(6.8), 2.0, curve: Curves.easeOut),
      ]);

  double get wordmarkOpacity => fade(_t(2.6), _t(3.0));
  double get wordmarkLift => (1 - _intervalValue(_t(2.6), _t(3.0))) * 4;

  double get moneyOpacity => fade(_t(3.0), _t(3.5));
  double get moneyLift => (1 - _intervalValue(_t(3.0), _t(3.5))) * 8;
  double get moneyScale => scale(
    _t(3.0),
    _t(3.5),
    begin: 0.75,
    finish: 1.0,
    curve: Curves.easeOutBack,
  );

  double cardOpacity(int index) {
    final double start = 4.75 + (index * 0.12);
    return fade(_t(start), _t(start + 0.32));
  }

  double cardLift(int index) {
    final double start = 4.75 + (index * 0.12);
    return (1 - _intervalValue(_t(start), _t(start + 0.32))) * 24;
  }

  double get settingsOpacity => fade(_t(6.0), _t(6.4));
  double get settingsScale => scale(
    _t(6.0),
    _t(6.4),
    begin: 0.92,
    finish: 1.0,
    curve: Curves.easeOutBack,
  );

  double get chromeOpacity => fade(_t(6.0), _t(6.4));
  double get chromeScale => scale(
    _t(6.0),
    _t(6.4),
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
