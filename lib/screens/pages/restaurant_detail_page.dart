import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restaurant_app/core/app_route.dart';
import 'package:restaurant_app/core/styles.dart';
import 'package:restaurant_app/data/controllers/favorite_controller.dart';
import 'package:restaurant_app/data/controllers/restaurant_detail_controller.dart';
import 'package:restaurant_app/data/controllers/restaurant_list_controller.dart.dart';
import 'package:restaurant_app/data/model/restaurant_list_model.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class RestaurantDetailPage extends GetView {
  final isFav = RxBool(false);
  final box = GetStorage();
  final detailRestaurant = Get.put(DetailController());
  final listRestaurant = Get.put(ListController());
  final restaurantArguments = Get.arguments as Restaurant;
  final favoriteController = Get.put(FavoriteController());
  final Divider _divider = const Divider(
    thickness: 2,
    indent: 15,
    endIndent: 15,
  );

  RestaurantDetailPage({super.key});

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantArguments.name!),
        leading: IconButton(
            onPressed: () async {
              await listRestaurant.getListRestaurant();

              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios_new_outlined)),
      ),
      body: _detailRestaurant(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(restaurantArguments.name!),
        transitionBetweenRoutes: false,
      ),
      child: _detailRestaurant(),
    );
  }

  Widget _detailRestaurant() {
    return Obx(() {
      if (detailRestaurant.detail.value.restaurant == null) {
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        );
      } else if (detailRestaurant.hasError.value) {
        return const Center(
          child: Text(
            'Failed to load restaurant list',
            style: TextStyle(color: Colors.red),
          ),
        );
      } else {
        final restaurant = detailRestaurant.detail.value.restaurant!;
        final isFavorite =
            box.read("fav_${detailRestaurant.detail.value.restaurant!.id}") ??
                false;
        isFav.value = isFavorite;
        return ListView(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: restaurant.pictureId!,
                    child: Image.network(
                      "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId!}",
                      height: 250,
                      width: Get.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Obx(() => Container(
                      margin: const EdgeInsets.all(10),
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        backgroundColor: primaryColor,
                        radius: 21,
                        child: InkWell(
                          child: Icon(
                            favoriteController.isFavorite(restaurant.id!)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.red,
                            size: 35,
                          ),
                          onTap: () {
                            favoriteController.toggleFavorite(restaurant.id!);
                            if (favoriteController.isFavorite(restaurant.id!)) {
                              box.write(
                                  "fav_${detailRestaurant.detail.value.restaurant!.id}",
                                  true);
                              Get.rawSnackbar(
                                  message: "Berhasil menambahkan ke favorit",
                                  backgroundColor: secondaryColor,
                                  instantInit: true,
                                  duration: const Duration(milliseconds: 800));
                            } else {
                              box.remove(
                                  "fav_${detailRestaurant.detail.value.restaurant!.id}");
                              Get.rawSnackbar(
                                  message: "Dihapus dari favorit",
                                  backgroundColor: secondaryColor,
                                  instantInit: true,
                                  duration: const Duration(milliseconds: 800));
                            }
                          },
                        ),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.name!,
                        style: myTextTheme.headlineSmall,
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star),
                          Text(
                            restaurant.rating.toString(),
                            style: myTextTheme.bodyLarge,
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                      ),
                      Text(
                        restaurant.city!,
                        style: myTextTheme.bodyMedium,
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Deskripsi",
                    style: myTextTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    restaurant.description!,
                    textAlign: TextAlign.justify,
                  )
                ],
              ),
            ),
            const SizedBox(height: 5),
            _divider,
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: myTextTheme.bodyLarge,
                    ),
                    Row(
                      children: List.generate(
                        restaurant.categories!.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 10, top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: secondaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              restaurant.categories![index].name,
                              style: const TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Menu",
                    style: myTextTheme.bodyLarge,
                  ),
                  const SizedBox(height: 5),
                  const Text("Foods: "),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        restaurant.menu!.foods!.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 10, top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: secondaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              restaurant.menu!.foods![index].name,
                              style: const TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text("Drinks: "),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        restaurant.menu!.drinks!.length,
                        (index) => Container(
                          margin: const EdgeInsets.only(right: 10, top: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: secondaryColor,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              restaurant.menu!.drinks![index].name,
                              style: const TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20)
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Customer Review",
                    style: myTextTheme.bodyLarge,
                    textAlign: TextAlign.start,
                  ),
                  InkWell(
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, top: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: primaryColor,
                          border: Border.all(color: secondaryColor)),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Add Review",
                          style: TextStyle(color: secondaryColor),
                        ),
                      ),
                    ),
                    onTap: () {
                      Get.toNamed(Routes.review);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                    restaurant.customerReviews!.length,
                    (index) => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Nama"),
                                Text("Tanggal"),
                                Text("Review"),
                                SizedBox(height: 20)
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      ": ${restaurant.customerReviews![index].name!}"),
                                  Text(
                                      ": ${restaurant.customerReviews![index].date!}"),
                                  Text(
                                      ": ${restaurant.customerReviews![index].review!}"),
                                  const SizedBox(height: 20)
                                ],
                              ),
                            ),
                          ],
                        )),
              ),
            )
          ],
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
