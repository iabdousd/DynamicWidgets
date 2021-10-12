import 'package:dynamic_widgets_app/configs/validators.dart';
import 'package:dynamic_widgets_app/controllers/landing.dart';
import 'package:dynamic_widgets_app/models/dynamic_widgets/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SideBar extends GetWidget<LandingController> {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(-2, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        children: [
          Expanded(
            child: GetBuilder<LandingController>(
              builder: (controller) {
                return ListView.builder(
                  itemBuilder: (context, index) =>
                      _WidgetConfiguration(index: index),
                  itemCount: controller.config.widgets.length,
                );
              },
            ),
          ),
          ElevatedButton.icon(
            onPressed: addWidget,
            icon: const Icon(Icons.add),
            label: const Text('Add Widget'),
          ),
        ],
      ),
    );
  }

  void addWidget() async {
    final selectedType = await Get.dialog<DynamicWidgetType>(
      AlertDialog(
        title: const Text('Select Widget type'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: DynamicWidgetType.values.map((type) {
            return TextButton(
              onPressed: () => Get.back(result: type),
              child: Text(type.name),
            );
          }).toList(),
        ),
      ),
    );
    controller.addWidget(selectedType);
  }
}

class _WidgetConfiguration extends GetWidget<LandingController> {
  final int index;
  const _WidgetConfiguration({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final widget = controller.config.widgets[index];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black54, width: .5),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.name,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: () => controller.removeWidget(index),
                icon: const Icon(Icons.close),
                color: Colors.red,
              ),
            ],
          ),
          const Divider(height: 20),

          // Margin
          _MarginConfig(index: index),
          const Divider(height: 24),

          if (widget is TextWidget) ...[
            _TextConfig(index: index),
            const Divider(height: 24)
          ],
          if (widget is ImageWidget) ...[
            _ImageUrlConfig(index: index),
            const Divider(height: 24),
            _ImageDimensionsConfig(index: index),
            const Divider(height: 24),
          ],
        ],
      ),
    );
  }
}

class _MarginConfig extends GetWidget<LandingController> {
  final int index;
  const _MarginConfig({required this.index});

  @override
  Widget build(BuildContext context) {
    final widget = controller.config.widgets[index];
    final marginsValues = [
      widget.margin.top,
      widget.margin.left,
      widget.margin.bottom,
      widget.margin.right
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Margin:', style: Get.theme.textTheme.subtitle2),
        Row(
          children: EdgeInsetsFields.values.map((field) {
            final i = EdgeInsetsFields.values.indexOf(field);

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: TextFormField(
                  initialValue: marginsValues[i].toString(),
                  decoration: InputDecoration(
                    label: Text(field.name),
                  ),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null) {
                      controller.updateMargin(index, field, parsed);
                    }
                  },
                  validator: InputValidators.isNumberValdiator,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}

class _TextConfig extends GetWidget<LandingController> {
  final int index;
  const _TextConfig({required this.index});

  @override
  Widget build(BuildContext context) {
    final widget = controller.config.widgets[index] as TextWidget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Text:', style: Get.theme.textTheme.subtitle2),
        TextFormField(
          initialValue: widget.text,
          decoration: const InputDecoration(
            hintText: 'Enter text here',
          ),
          onChanged: (val) {
            controller.updateText(index, val);
          },
          validator: InputValidators.textValdiator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}

class _ImageUrlConfig extends GetWidget<LandingController> {
  final int index;
  const _ImageUrlConfig({required this.index});

  @override
  Widget build(BuildContext context) {
    final widget = controller.config.widgets[index] as ImageWidget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Image URL:', style: Get.theme.textTheme.subtitle2),
        TextFormField(
          initialValue: widget.url,
          decoration: const InputDecoration(
            hintText: 'Enter image URL here',
          ),
          onChanged: (val) {
            if (InputValidators.imageURLValdiator(val) != null) return;

            controller.updateImageUrl(index, val);
          },
          validator: InputValidators.imageURLValdiator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }
}

class _ImageDimensionsConfig extends GetWidget<LandingController> {
  final int index;
  const _ImageDimensionsConfig({required this.index});

  @override
  Widget build(BuildContext context) {
    final widget = controller.config.widgets[index] as ImageWidget;
    final dimensions = {
      ImageDimension.width: widget.width,
      ImageDimension.height: widget.height,
      ImageDimension.maxWidth: widget.maxWidth,
      ImageDimension.maxHeight: widget.maxHeight,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Image dimensions:', style: Get.theme.textTheme.subtitle2),
        Row(
          children: ImageDimension.values
              .map(
                (dimension) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextFormField(
                      initialValue: dimensions[dimension]?.toStringAsFixed(2),
                      decoration: InputDecoration(
                        labelText: dimension.name,
                      ),
                      onChanged: (val) {
                        if (InputValidators.isNumberValdiator(val) != null) {
                          return;
                        }

                        controller.updateImageDimension(
                          index,
                          dimension,
                          double.parse(val),
                        );
                      },
                      validator: InputValidators.isNumberValdiator,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
