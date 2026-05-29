import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

class HomeScreenAnimations {
  HomeScreenAnimations(TickerProvider vsync)
    : controller = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 16000),
      ),
      bobController = AnimationController(
        vsync: vsync,
        duration: const Duration(milliseconds: 2000),
      )..repeat();

  final AnimationController controller;
  final AnimationController bobController;

  static const double _totalSeconds = 16.0;
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

  double get backgroundReveal => fade(_t(0.0), _t(0.25), curve: Curves.easeOut);

  double get walletOpacity => fade(_t(0.0), _t(0.3));
  double get walletScale => scale(
    _t(0.1),
    _t(0.9),
    begin: 0.94,
    finish: 1.0,
    curve: Curves.easeInOut,
  );
  double get walletTravelY {
    if (controller.value <= _t(2.5)) {
      return ui.lerpDouble(
        110.0,
        centerY,
        Curves.easeOutCubic.transform(
          (controller.value / _t(2.5)).clamp(0.0, 1.0),
        ),
      )!;
    } else if (controller.value <= _t(3.0)) {
      return centerY;
    } else if (controller.value <= _t(4.2)) {
      return ui.lerpDouble(
        centerY,
        110.0,
        Curves.easeInOutCubic.transform(
          ((controller.value - _t(3.0)) / (_t(4.2) - _t(3.0))).clamp(
            0.0,
            1.0,
          ),
        ),
      )!;
    } else if (controller.value <= _t(8.0)) {
      return 110.0;
    } else if (controller.value <= _t(10.0)) {
      return ui.lerpDouble(
        110.0,
        10.0,
        Curves.easeInOutCubic.transform(
          ((controller.value - _t(8.0)) / (_t(10.0) - _t(8.0))).clamp(
            0.0,
            1.0,
          ),
        ),
      )!;
    } else {
      return 10.0;
    }
  }
  double get walletWobbleRotation =>
      math.sin(bobController.value * math.pi * 2) *
      _piecewiseTravel(controller.value, <_TimelinePoint>[
        _TimelinePoint(_t(0.0), 0.0),
        _TimelinePoint(_t(10.0), 0.0),
        _TimelinePoint(_t(11.0), 0.03, curve: Curves.easeOut),
      ]);
  double get walletBobOffset =>
      math.sin(bobController.value * math.pi * 2) *
      _piecewiseTravel(controller.value, <_TimelinePoint>[
        _TimelinePoint(_t(0.0), 0.0),
        _TimelinePoint(_t(10.0), 0.0),
        _TimelinePoint(_t(11.0), 2.0, curve: Curves.easeOut),
      ]);

  double get wordmarkOpacity => fade(_t(4.2), _t(5.5));
  double get wordmarkLift => (1 - _intervalValue(_t(4.2), _t(5.5))) * 6;

  double get moneyOpacity => fade(_t(5.5), _t(6.8));
  double get moneyLift => (1 - _intervalValue(_t(5.5), _t(6.8))) * 10;
  double get moneyScale => scale(
    _t(5.5),
    _t(6.8),
    begin: 0.75,
    finish: 1.0,
    curve: Curves.easeOutBack,
  );

  double cardOpacity(int index) {
    final double start = 10.0 + (index * 0.6);
    return fade(_t(start), _t(start + 1.8));
  }

  double cardLift(int index) {
    final double start = 10.0 + (index * 0.6);
    return (1 - _intervalValue(_t(start), _t(start + 1.8), curve: Curves.easeOutBack)) * 80;
  }

  double get settingsOpacity => fade(_t(13.0), _t(15.5));
  double get settingsScale => scale(
    _t(13.0),
    _t(15.5),
    begin: 0.92,
    finish: 1.0,
    curve: Curves.easeOutBack,
  );

  double get chromeOpacity => fade(_t(13.0), _t(15.5));
  double get chromeScale => scale(
    _t(13.0),
    _t(15.5),
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
