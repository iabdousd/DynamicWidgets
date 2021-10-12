import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'extensions.dart';
export 'extensions.dart';

enum DynamicWidgetType { text, image }

enum EdgeInsetsFields { top, left, bottom, right }

enum ImageDimension { width, height, maxWidth, maxHeight }

class DynamicWidget {
  String name;
  DynamicWidgetType type;
  EdgeInsets margin;

  DynamicWidget({
    required this.name,
    required this.type,
    required this.margin,
  });

  @mustCallSuper
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.asString,
      'margin': margin.toMap(),
    };
  }

  factory DynamicWidget.fromMap(Map<String, dynamic> map) {
    final type = DynamicWidgetTypeSerializer.fromString(map['type']);
    final name = map['name'];
    final margin = EdgeInsetsSerializer.fromMap(map['margin']);

    switch (type) {
      case DynamicWidgetType.text:
        {
          return TextWidget(
            name: name,
            margin: margin,
            text: map['text'],
            textAlign: TextAlignSerializer.fromString(map['textAlign']),
            style: TextStyleSerializer.fromMap(map['style']),
          );
        }
      case DynamicWidgetType.image:
        {
          return ImageWidget(
            name: name,
            margin: margin,
            url: map['url'],
            width: map['width'],
            height: map['height'],
            maxWidth: map['maxWidth']?.toDouble() ?? double.infinity,
            maxHeight: map['maxHeight']?.toDouble() ?? double.infinity,
            alignment: AlignmentSerializer.fromString(map['alignment']),
          );
        }
      default:
        {
          return DynamicWidget(
            margin: margin,
            name: name,
            type: type,
          );
        }
    }
  }

  String toJson() => json.encode(toMap());

  factory DynamicWidget.fromJson(String source) =>
      DynamicWidget.fromMap(json.decode(source));
}

class TextWidget extends DynamicWidget {
  String text;
  TextStyle? style;
  TextAlign textAlign;

  TextWidget({
    required String name,
    EdgeInsets margin = EdgeInsets.zero,
    required this.text,
    this.style,
    this.textAlign = TextAlign.left,
  }) : super(
          name: name,
          type: DynamicWidgetType.text,
          margin: margin,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'text': text,
      'style': style?.toMap(),
      'textAlign': textAlign.asString,
    };
  }
}

class ImageWidget extends DynamicWidget {
  String url;
  double? width;
  double? height;
  double maxWidth;
  double maxHeight;
  Alignment alignment;

  ImageWidget({
    required String name,
    EdgeInsets margin = EdgeInsets.zero,
    required this.url,
    this.width,
    this.height,
    this.maxWidth = double.infinity,
    this.maxHeight = double.infinity,
    this.alignment = Alignment.center,
  }) : super(
          name: name,
          type: DynamicWidgetType.image,
          margin: margin,
        );

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'url': url,
      'width': width,
      'height': height,
      'maxWidth': maxWidth == double.infinity ? null : maxWidth,
      'maxHeight': maxHeight == double.infinity ? null : maxHeight,
      'alignment': alignment.asString,
    };
  }
}
