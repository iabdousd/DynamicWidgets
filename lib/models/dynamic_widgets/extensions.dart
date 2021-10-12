import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'dynamic_widget.dart';

extension ImageDimensionExtension on ImageDimension {
  String get name =>
      describeEnum(this).substring(0, 1).toUpperCase() +
      describeEnum(this).substring(1);
}

extension EdgeInsetsFieldsExtension on EdgeInsetsFields {
  String get name =>
      describeEnum(this).substring(0, 1).toUpperCase() +
      describeEnum(this).substring(1);
}

extension DynamicWidgetTypeExtension on DynamicWidgetType {
  String get name =>
      describeEnum(this).substring(0, 1).toUpperCase() +
      describeEnum(this).substring(1);
}

extension DynamicWidgetTypeSerializer on DynamicWidgetType {
  String get asString => describeEnum(this);

  static DynamicWidgetType fromString(String string) =>
      DynamicWidgetType.values.firstWhere(
        (element) => element.asString == string,
      );
}

extension EdgeInsetsSerializer on EdgeInsets {
  Map<String, double> toMap() => {
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
      };

  static EdgeInsets fromMap(Map<String, dynamic>? map) {
    if (map == null) return EdgeInsets.zero;

    return EdgeInsets.only(
      left: map['left']?.toDouble() ?? 0.0,
      top: map['top']?.toDouble() ?? 0.0,
      right: map['right']?.toDouble() ?? 0.0,
      bottom: map['bottom']?.toDouble() ?? 0.0,
    );
  }
}

extension HexColor on Color {
  static Color fromHex(String? hexString) {
    if (hexString == null) return Colors.black;

    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex() {
    return '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
  }
}

extension FontWeightSerializer on FontWeight {
  String get asString => toString().split('.').last;

  static FontWeight fromString(String? fontWeight) {
    if (fontWeight == 'bold') return FontWeight.bold;

    return FontWeight.values.firstWhere(
      (element) => element.asString == fontWeight,
      orElse: () => FontWeight.normal,
    );
  }
}

extension TextStyleSerializer on TextStyle {
  Map<String, dynamic> toMap() => {
        'fontSize': fontSize,
        'height': height,
        'fontWeight': fontWeight?.asString,
        'color': color?.toHex(),
      };

  static TextStyle fromMap(Map<String, dynamic>? map) {
    if (map == null) return const TextStyle();

    return TextStyle(
      fontSize: map['fontSize']?.toDouble() ?? 0.0,
      height: map['height'],
      fontWeight: FontWeightSerializer.fromString(map['fontWeight']),
      color: HexColor.fromHex(map['color']),
    );
  }
}

extension TextAlignSerializer on TextAlign {
  String get asString => describeEnum(this);

  static TextAlign fromString(String? string) => TextAlign.values.firstWhere(
        (element) => element.asString == string,
        orElse: () => TextAlign.left,
      );
}

extension AlignmentSerializer on Alignment {
  static Map<Alignment, String> values = {
    Alignment.centerLeft: 'left',
    Alignment.center: 'center',
    Alignment.centerRight: 'right',
  };

  String? get asString => values[this];

  static Alignment fromString(String? string) => values.keys.firstWhere(
        (key) => key.asString == string,
        orElse: () => Alignment.center,
      );
}
