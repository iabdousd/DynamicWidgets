import 'package:dynamic_widgets_app/controllers/landing.dart';
import 'package:dynamic_widgets_app/views/sidebar.dart';
import 'package:dynamic_widgets_app/views/widgets_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LandingView extends GetView<LandingController> {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Widgets Builder'),
        actions: [
          ElevatedButton(
            onPressed: controller.clear,
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: controller.import,
            child: const Text('Import'),
          ),
          ElevatedButton(
            onPressed: controller.export,
            child: const Text('Export'),
          ),
        ],
      ),
      body: Row(
        children: const [
          Expanded(
            flex: 5,
            child: WidgetsPreview(),
          ),
          Expanded(
            flex: 2,
            child: SideBar(),
          ),
        ],
      ),
    );
  }
}
