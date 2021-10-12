import 'package:dynamic_widgets_app/models/dynamic_widgets/dynamic_widget.dart';

enum DeviceType {
  desktop,
  mobile,
}

class PreviewConfig {
  List<DynamicWidget> widgets = [];
  DeviceType deviceType;

  PreviewConfig({this.deviceType = DeviceType.desktop});
}
