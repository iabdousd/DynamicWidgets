import 'package:dynamic_widgets_app/controllers/landing.dart';
import 'package:dynamic_widgets_app/views/landing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => const LandingView(),
      },
      initialBinding: BindingsBuilder.put(() => LandingController()),
    );
  }
}
