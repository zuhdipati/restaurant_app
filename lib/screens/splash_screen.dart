import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/core/styles.dart';
import 'package:restaurant_app/screens/pages/home_page.dart';

class SplashScreen extends GetView {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => HomePage());
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Restaurant App",
          style: myTextTheme.headlineMedium,
        ),
      ),
    );
  }
}
