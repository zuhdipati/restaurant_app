import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurant_app/core/app_route.dart';
import 'package:restaurant_app/core/styles.dart';
import 'package:restaurant_app/data/controllers/favorite_controller.dart';
import 'package:restaurant_app/data/controllers/restaurant_detail_controller.dart';
import 'package:restaurant_app/data/controllers/restaurant_list_controller.dart.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class RestaurantFavPage extends GetView {
  final listRestaurant = Get.put(ListController());
  final detailRestaurant = Get.put(DetailController());
  final box = GetStorage();
  final favoriteController = Get.put(FavoriteController());

  RestaurantFavPage({super.key});

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites Page'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Favorites",
              style: myTextTheme.headlineMedium,
            ),
          ),
          _favList()
        ],
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Favorites Page'),
      ),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Favorites",
              style: myTextTheme.headlineMedium,
            ),
          ),
          _favList()
        ],
      ),
    );
  }

  Widget _favList() {
    return Obx(() {
      if (listRestaurant.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(
            color: secondaryColor,
          ),
        );
      } else if (listRestaurant.hasError.value) {
        return const Center(
          child: Text(
            'No Internet',
            style: TextStyle(color: Colors.red),
          ),
        );
      } else {
        final favoriteIds = box
            .getKeys()
            .where((key) => key is String && key.startsWith("fav_"));

        if (favoriteIds.isEmpty) {
          return const Center(
              child: Text(
            'No favorite restaurants yet.',
          ));
        }

        final favoriteRestaurants =
            listRestaurant.list.value.restaurants!.where((index) {
          final restaurantId = index.id.toString();
          return favoriteIds.contains("fav_$restaurantId");
        }).toList();

        return ListView.builder(
          physics: const ScrollPhysics(),
          shrinkWrap: true,
          itemCount: favoriteRestaurants.length,
          itemBuilder: (context, index) {
            var restaurant = favoriteRestaurants[index];

            return Material(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  leading: Hero(
                    tag: restaurant.pictureId!,
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId!}",
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    restaurant.name!,
                    style: myTextTheme.labelLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listRestaurant.list.value.restaurants![index].city!,
                          style: myTextTheme.labelMedium),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                          ),
                          Text('Rating: ${restaurant.rating}',
                              style: myTextTheme.labelMedium),
                        ],
                      ),
                    ],
                  ),
                  trailing: Obx(() => InkWell(
                        child: Icon(
                          favoriteController.isFavorite(restaurant.id!)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: 25,
                        ),
                        onTap: () {
                          listRestaurant.getListRestaurant();
                          favoriteController.toggleFavorite(restaurant.id!);
                          if (favoriteController.isFavorite(restaurant.id!)) {
                            box.write("fav_${restaurant.id}", true);
                            Get.rawSnackbar(
                                message: "Berhasil menambahkan ke favorit",
                                backgroundColor: secondaryColor,
                                instantInit: true,
                                duration: const Duration(milliseconds: 800));
                          } else {
                            box.remove("fav_${restaurant.id}");
                            Get.rawSnackbar(
                                message: "Dihapus dari favorit",
                                backgroundColor: secondaryColor,
                                instantInit: true,
                                duration: const Duration(milliseconds: 800));
                          }
                        },
                      )),
                  onTap: () async {
                    var connectivityResult =
                        await (Connectivity().checkConnectivity());

                    if (connectivityResult == ConnectivityResult.none) {
                      Get.rawSnackbar(message: 'No internet');
                    } else {
                      Get.dialog(const Center(
                        child: CircularProgressIndicator(),
                      ));
                      await detailRestaurant
                          .getDetailRestaurant(favoriteRestaurants[index].id!);
                      Get.back();
                      Get.toNamed(Routes.detail, arguments: restaurant);
                    }
                  },
                ),
              ),
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
