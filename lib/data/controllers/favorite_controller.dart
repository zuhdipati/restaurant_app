import 'package:get/get.dart';

class FavoriteController extends GetxController {
  final favoriteRestaurantIds = RxList();

  void toggleFavorite(String restaurantId) {
    if (favoriteRestaurantIds.contains(restaurantId)) {
      favoriteRestaurantIds.remove(restaurantId);
    } else {
      favoriteRestaurantIds.add(restaurantId);
    }
  }

  bool isFavorite(String restaurantId) {
    return favoriteRestaurantIds.contains(restaurantId);
  }
}
