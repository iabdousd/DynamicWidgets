import 'package:dynamic_widgets_app/models/dynamic_widgets/dynamic_widget.dart';
import 'package:dynamic_widgets_app/models/views/preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingController extends GetxController {
  late PreviewConfig config;

  @override
  void onInit() {
    super.onInit();
    config = PreviewConfig();
  }

  void import() {
    //
  }

  void changeDeviceType(DeviceType newType) {
    config.deviceType = newType;
    update();
  }

  void addWidget(DynamicWidgetType? selectedType) {
    switch (selectedType) {
      case DynamicWidgetType.text:
        config.widgets.add(TextWidget(
          text: '(Enter text here)',
          name: 'Widget #${config.widgets.length + 1}',
          margin: const EdgeInsets.all(16.0),
        ));
        break;
      case DynamicWidgetType.image:
        config.widgets.add(ImageWidget(
          url: 'https://i.stack.imgur.com/y9DpT.jpg',
          name: 'Widget #${config.widgets.length + 1}',
          margin: const EdgeInsets.all(16.0),
        ));
        break;
      default:
        break;
    }
    update();
  }

  void removeWidget(int widgetIndex) {
    config.widgets.removeAt(widgetIndex);
    update();
  }

  void updateText(int widgetIndex, String text) {
    config.widgets.replaceRange(
      widgetIndex,
      widgetIndex + 1,
      [(config.widgets[widgetIndex] as TextWidget)..text = text],
    );
    update();
  }

  void updateImageUrl(int widgetIndex, String url) {
    config.widgets.replaceRange(
      widgetIndex,
      widgetIndex + 1,
      [(config.widgets[widgetIndex] as ImageWidget)..url = url],
    );
    update();
  }

  void updateImageDimension(
    int widgetIndex,
    ImageDimension dimension,
    double value,
  ) {
    ImageWidget newImage = config.widgets[widgetIndex] as ImageWidget;

    switch (dimension) {
      case ImageDimension.width:
        newImage.width = value;
        break;
      case ImageDimension.height:
        newImage.height = value;
        break;
      case ImageDimension.maxWidth:
        newImage.maxWidth = value;
        break;
      case ImageDimension.maxHeight:
        newImage.maxHeight = value;
        break;
    }

    config.widgets.replaceRange(
      widgetIndex,
      widgetIndex + 1,
      [newImage],
    );
    update();
  }

  void updateMargin(int widgetIndex, EdgeInsetsFields field, double value) {
    EdgeInsets newMargin = config.widgets[widgetIndex].margin;

    switch (field) {
      case EdgeInsetsFields.top:
        newMargin = newMargin.copyWith(top: value);
        break;
      case EdgeInsetsFields.left:
        newMargin = newMargin.copyWith(left: value);
        break;
      case EdgeInsetsFields.bottom:
        newMargin = newMargin.copyWith(bottom: value);
        break;
      case EdgeInsetsFields.right:
        newMargin = newMargin.copyWith(right: value);
        break;
    }

    config.widgets.replaceRange(
      widgetIndex,
      widgetIndex + 1,
      [config.widgets[widgetIndex]..margin = newMargin],
    );
    update();
  }
}
