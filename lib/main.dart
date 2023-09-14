import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/core/app_page.dart';
import 'package:restaurant_app/core/app_theme.dart';
import 'package:restaurant_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Restaurant App',
      theme: MyAppTheme.theme,
      home: const SplashScreen(),
      getPages: AppPages.pages,
    );
  }
}
