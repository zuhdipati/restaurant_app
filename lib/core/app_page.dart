import 'package:get/get.dart';
import 'package:restaurant_app/core/app_route.dart';
import 'package:restaurant_app/screens/pages/home_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_add_review_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_detail_page.dart';
import 'package:restaurant_app/screens/pages/restaurant_search.dart';

class AppPages {
  static const initial = Routes.splash;
  static final pages = [
    GetPage(name: Routes.home, page: () => RestaurantListPage()),
    GetPage(name: Routes.detail, page: () => RestaurantDetailPage()),
    GetPage(name: Routes.search, page: () => RestaurantSearchPage()),
    GetPage(name: Routes.review, page: () => ReviewPage()),
  ];
}
