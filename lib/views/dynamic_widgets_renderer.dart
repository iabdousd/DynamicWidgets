import 'package:dynamic_widgets_app/controllers/landing.dart';
import 'package:dynamic_widgets_app/models/dynamic_widgets/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DynamicWidgetsRenderer extends StatelessWidget {
  const DynamicWidgetsRenderer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LandingController>(
      builder: (controller) {
        final widgets = controller.config.widgets;
        return ListView.builder(
          itemBuilder: (context, index) {
            final widget = widgets[index];

            if (widget is TextWidget) {
              return Padding(
                key: Key(widget.name),
                padding: widget.margin,
                child: Text(
                  widget.text,
                  style: widget.style,
                  textAlign: widget.textAlign,
                ),
              );
            } else if (widget is ImageWidget) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return Padding(
                    key: Key(widget.name),
                    padding: widget.margin,
                    child: Align(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: widget.maxWidth,
                          maxHeight: widget.maxHeight,
                        ),
                        child: widget.url.endsWith('svg')
                            ? SvgPicture.network(
                                widget.url,
                                width: widget.width,
                                height: widget.height,
                              )
                            : Image.network(
                                widget.url,
                                width: widget.width,
                                height: widget.height,
                              ),
                      ),
                      alignment: widget.alignment,
                    ),
                  );
                },
              );
            }

            return SizedBox.shrink(key: Key(widget.name));
          },
          itemCount: widgets.length,
        );
      },
    );
  }
}
