import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/core/app_route.dart';
import 'package:restaurant_app/core/styles.dart';
import 'package:restaurant_app/data/controllers/restaurant_detail_controller.dart';
import 'package:restaurant_app/data/controllers/restaurant_search_controller.dart';

class RestaurantSearchPage extends StatelessWidget {
  final SearchResController controller = Get.put(SearchResController());
  final detailRestaurant = Get.put(DetailController());

  RestaurantSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Restoran'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller.searchController,
              decoration: const InputDecoration(
                labelText: 'Cari Restoran',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                if (query.isEmpty) {
                  controller.searchRestaurant("123abc");
                } else {
                  controller.searchRestaurant(query);
                }
              },
            ),
          ),
          Obx(() {
            if (controller.listSearch.isEmpty) {
              return const Center(
                child: Text(
                  "Restoran tidak ditemukan",
                ),
              );
            } else if (controller.isLoading.value) {
              return const Center(
                  child: CircularProgressIndicator(
                color: secondaryColor,
              ));
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: controller.listSearch.length,
                  itemBuilder: (context, index) {
                    final restaurant = controller.listSearch[index];
                    return Material(
                      child: ListTile(
                        leading: Image.network(
                          "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId!}",
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        title: Text(restaurant.name!),
                        subtitle: Text(restaurant.city!),
                        trailing: Text('Rating: ${restaurant.rating}'),
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
                                .getDetailRestaurant(restaurant.id!);
                            Get.back();
                            Get.toNamed(Routes.detail, arguments: restaurant);
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ],
      ),
    );
  }
}
