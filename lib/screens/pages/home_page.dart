import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/core/styles.dart';
import 'package:restaurant_app/screens/pages/restaurant_favorit_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_list_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_settings_page.dart';

class HomePage extends GetView {
  final PageController pageController = PageController();
  final _currentIndex = 0.obs;

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            RestaurantListPage(),
            RestaurantFavPage(),
            const SettingsPage()
          ],
        ),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            currentIndex: _currentIndex.value,
            selectedItemColor: secondaryColor,
            onTap: (index) {
              _currentIndex.value = index;
              pageController.jumpToPage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorite',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
          ),
        ));
  }
}
