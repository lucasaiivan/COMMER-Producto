import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';

import 'dynamicTheme_lb.dart';

class WidgetsUtilsApp extends StatelessWidget {
  WidgetsUtilsApp({Key? key}) : super(key: key);

  final appdata = GetStorage(); // instance of GetStorage

  Widget buttonThemeBrightness({required BuildContext context, Color? color}) {
    if (color == null)
      color = Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
    return IconButton(
        icon: Icon(
            Theme.of(context).brightness == Brightness.light
                ? Icons.brightness_high
                : Icons.brightness_3,
            color: color),
        onPressed: ThemeService().switchTheme);
  }

  Function() switchTheme() => ThemeService().switchTheme;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
