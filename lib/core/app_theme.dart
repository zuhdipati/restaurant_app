import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/core/styles.dart';

class MyAppTheme {
  static final theme = ThemeData(
      textTheme: myTextTheme,
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
      colorScheme: Get.theme.colorScheme.copyWith(
        primary: primaryColor,
        onPrimary: Colors.black,
        secondary: secondaryColor,
      ));
}
