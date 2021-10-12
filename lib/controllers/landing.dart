import 'dart:convert';
import 'dart:io';

import 'package:dynamic_widgets_app/models/dynamic_widgets/dynamic_widget.dart';
import 'package:dynamic_widgets_app/models/views/preview.dart';
import 'package:dynamic_widgets_app/utils/json.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LandingController extends GetxController {
  final sidebarScrollController = ScrollController();
  late PreviewConfig config;

  @override
  void onInit() {
    super.onInit();
    config = PreviewConfig();
  }

  void clear() {
    config.widgets = [];
    update();
  }

  void import() async {
    List<Map<String, dynamic>> jsonData =
        config.widgets.map((e) => e.toMap()).toList();

    final import = await Get.dialog<bool>(AlertDialog(
      title: const Text('IMPORT AS JSON'),
      content: SizedBox(
        width: Get.width * .75,
        child: TextFormField(
          initialValue: JsonUtils.getPrettyJSONString(jsonData),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            alignLabelWithHint: false,
          ),
          minLines: 8,
          maxLines: null,
          validator: (val) {
            if (val != null) {
              try {
                json.decode(val);
                return null;
              } catch (e) {
                //
              }
            }
            return 'Invalid syntax';
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            if (value.isNotEmpty) {
              try {
                jsonData = List<Map<String, dynamic>>.from(json.decode(value));
              } catch (e) {
                //* Ignored
              }
            }
          },
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Submit'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Choose file'),
        ),
      ],
    ));

    if (import == null) return;

    if (import) {
      final result = await FilePicker.platform.pickFiles();

      if (result != null) {
        final jsonFile = result.files.first;
        if (jsonFile.path != null) {
          jsonData = List<Map<String, dynamic>>.from(json.decode(utf8.decode(
            File(jsonFile.path!).readAsBytesSync(),
          )));
        }
      }
    }

    config.widgets = List<DynamicWidget>.from(
      jsonData.map((e) => DynamicWidget.fromMap(e)),
    );
    update();
  }

  void export() async {
    final jsonData = json.encode(config.widgets.map((e) => e.toMap()).toList());
    Get.dialog(AlertDialog(
      title: const Text('EXPORTED JSON'),
      content: SelectableText(
        jsonData,
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Clipboard.setData(ClipboardData(text: jsonData)),
          child: const Text('Copy'),
        ),
        TextButton(
          onPressed: Get.back,
          child: const Text('Close'),
        ),
      ],
    ));
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
          margin: const EdgeInsets.symmetric(vertical: 16.0),
        ));
        break;
      case DynamicWidgetType.image:
        config.widgets.add(ImageWidget(
          url: 'https://i.stack.imgur.com/y9DpT.jpg',
          name: 'Widget #${config.widgets.length + 1}',
          margin: const EdgeInsets.symmetric(vertical: 16.0),
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
    double? value,
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
        newImage.maxWidth = value ?? double.infinity;
        break;
      case ImageDimension.maxHeight:
        newImage.maxHeight = value ?? double.infinity;
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

  swap(int index) {
    final temp = config.widgets[index];
    config.widgets.replaceRange(index, index + 1, [config.widgets[index + 1]]);
    config.widgets.replaceRange(index + 1, index + 2, [temp]);
    update();
  }
}
