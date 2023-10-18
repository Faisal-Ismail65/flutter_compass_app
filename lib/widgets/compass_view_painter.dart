// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass_app/constants/app_colors.dart';

typedef CardinalityMap = Map<num, String>;

extension on num {
  double toRadian() => this * pi / 180;
}

extension on TextSpan {
  TextPainter toPainter({TextDirection textDirection = TextDirection.ltr}) =>
      TextPainter(text: this, textDirection: textDirection);
}

class CompassViewPainter extends CustomPainter {
  final Color color;
  final int majorTickCount;
  final int minorTickCount;
  final CardinalityMap cardinalityMap;

  CompassViewPainter({
    required this.color,
    this.majorTickCount = 18,
    this.minorTickCount = 90,
    this.cardinalityMap = const {0: 'N', 90: 'E', 180: 'S', 270: 'W'},
  });

  late final majorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color
    ..strokeWidth = 2.0;

  late final minorScalePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = color.withOpacity(0.7)
    ..strokeWidth = 1.0;

  late final majorScaleStyle = TextStyle(
    color: color,
    fontSize: 12,
  );

  late final cardinalityStyle = const TextStyle(
    color: AppColors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  late final _majorTicks = _layoutScale(majorTickCount);

  late final _minorTicks = _layoutScale(minorTickCount);

  late final _angleDegree = _layoutAngleScale(_majorTicks);

  @override
  void paint(Canvas canvas, Size size) {
    final majorTickLength = size.width * 0.08;
    final minorTickLength = size.width * 0.055;

    const origin = Offset.zero;
    final center = size.center(origin);
    final radius = size.width / 2;
    canvas.save();

    // painting major ticks

    for (final angle in _majorTicks) {
      final tickStart = Offset.fromDirection(
        _correctAngle(angle).toRadian(),
        radius,
      );
      final tickEnd = Offset.fromDirection(
        _correctAngle(angle).toRadian(),
        radius - majorTickLength,
      );
      canvas.drawLine(center + tickStart, center + tickEnd, majorScalePaint);
    }

    // painting minor ticks

    for (final angle in _minorTicks) {
      final tickStart =
          Offset.fromDirection(_correctAngle(angle).toRadian(), radius);
      final tickEnd = Offset.fromDirection(
        _correctAngle(angle).toRadian(),
        radius - minorTickLength,
      );
      canvas.drawLine(center + tickStart, center + tickEnd, minorScalePaint);
    }

    // painting angle degree

    for (final angle in _angleDegree) {
      final textPadding = majorTickLength - size.width * 0.02;
      final textPainter = TextSpan(
        text: angle.toStringAsFixed(0),
        style: majorScaleStyle,
      ).toPainter()
        ..layout();

      final layoutOffset = Offset.fromDirection(
          _correctAngle(angle).toRadian(), radius - textPadding);

      final offset = center + layoutOffset;

      canvas.restore();
      canvas.save();
      canvas.translate(offset.dx, offset.dy);

      canvas.rotate(angle.toRadian());

      canvas.translate(-offset.dx, -offset.dy);
      textPainter.paint(
          canvas, Offset(offset.dx - (textPainter.width / 2), offset.dy));
    }

    // painting cardinality text

    for (final cardinality in cardinalityMap.entries) {
      final textPadding = majorTickLength + size.width * 0.01;

      final angle = cardinality.key.toDouble();
      final text = cardinality.value;
      final textPainter = TextSpan(
        text: text,
        style: cardinalityStyle.copyWith(
            color: text == 'N' ? AppColors.red : null),
      ).toPainter()
        ..layout();

      final layoutOffset = Offset.fromDirection(
          _correctAngle(angle).toRadian(), radius - textPadding);

      final offset = center + layoutOffset;

      canvas.restore();
      canvas.save();
      canvas.translate(offset.dx, offset.dy);

      canvas.rotate(angle.toRadian());

      canvas.translate(-offset.dx, -offset.dy);
      textPainter.paint(
          canvas, Offset(offset.dx - (textPainter.width / 2), offset.dy));
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  double _correctAngle(double angle) => angle - 90;

  List<double> _layoutScale(int ticks) {
    final scale = 360 / ticks;
    return List.generate(ticks, (index) => index * scale);
  }

  List<double> _layoutAngleScale(List<double> ticks) {
    List<double> angle = [];
    for (var i = 0; i < ticks.length; i++) {
      if (i == ticks.length - 1) {
        double degreeValue = (ticks[i] + 360) / 2;
        angle.add(degreeValue);
      } else {
        double degreeValue = (ticks[i] + ticks[i + 1]) / 2;
        angle.add(degreeValue);
      }
    }
    return angle;
  }
}
