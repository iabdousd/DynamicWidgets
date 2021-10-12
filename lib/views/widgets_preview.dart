import 'package:dynamic_widgets_app/controllers/landing.dart';
import 'package:dynamic_widgets_app/models/views/preview.dart';
import 'package:dynamic_widgets_app/views/dynamic_widgets_renderer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WidgetsPreview extends StatelessWidget {
  const WidgetsPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: GetBuilder<LandingController>(
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _PreviewDeviceButton(
                      name: 'Desktop',
                      icon: const Icon(Icons.desktop_mac),
                      clickEvent: () =>
                          controller.changeDeviceType(DeviceType.desktop),
                      selected:
                          controller.config.deviceType == DeviceType.desktop,
                    ),
                    _PreviewDeviceButton(
                      name: 'Mobile',
                      icon: const Icon(Icons.mobile_friendly),
                      clickEvent: () =>
                          controller.changeDeviceType(DeviceType.mobile),
                      selected:
                          controller.config.deviceType == DeviceType.mobile,
                    ),
                  ],
                ),
              ),
              const Expanded(child: _ContentPreviewer()),
            ],
          );
        },
      ),
    );
  }
}

class _PreviewDeviceButton extends StatelessWidget {
  final String name;
  final Widget icon;
  final bool selected;
  final VoidCallback clickEvent;
  const _PreviewDeviceButton({
    Key? key,
    required this.name,
    required this.icon,
    required this.clickEvent,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickEvent,
      child: AnimatedContainer(
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.white,
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          borderRadius: BorderRadius.circular(3.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        duration: const Duration(milliseconds: 200),
        child: Row(
          children: [
            IconTheme(
              data:
                  IconThemeData(color: selected ? Colors.white : Colors.black),
              child: icon,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                name,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContentPreviewer extends GetWidget<LandingController> {
  const _ContentPreviewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LandingController>(
      builder: (controller) {
        final deviceType = controller.config.deviceType;

        return Container(
          width: deviceType == DeviceType.desktop ? double.infinity : 512,
          height: double.infinity,
          margin: const EdgeInsets.all(32.0),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const DynamicWidgetsRenderer(),
        );
      },
    );
  }
}
