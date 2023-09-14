import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/core/styles.dart';
import 'package:restaurant_app/core/app_route.dart';
import 'package:restaurant_app/data/controllers/restaurant_detail_controller.dart';
import 'package:restaurant_app/data/controllers/restaurant_list_controller.dart.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class RestaurantListPage extends GetView {
  final listRestaurant = Get.put(ListController());
  final detailRestaurant = Get.put(DetailController());

  RestaurantListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                onPressed: () async {
                  final connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.none) {
                    Get.rawSnackbar(message: 'No internet');
                  } else {
                    Get.toNamed(Routes.search);
                  }
                },
                icon: const Icon(Icons.search),
              )),
        ],
      ),
      body: _restaurantList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Dashboard'),
        trailing: CupertinoButton(
          onPressed: () async {
            final connectivityResult =
                await (Connectivity().checkConnectivity());
            if (connectivityResult == ConnectivityResult.none) {
              Get.rawSnackbar(message: 'No internet');
            } else {
              Get.toNamed(Routes.search);
            }
          },
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.search,
            size: 24,
          ),
        ),
      ),
      child: _restaurantList(context),
    );
  }

  ListView _restaurantList(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Restaurant",
                style: myTextTheme.headlineMedium,
              ),
              const Text(
                "Recommendation restaurant for you!",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        Obx(() {
          if (listRestaurant.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: secondaryColor,
              ),
            );
          } else if (listRestaurant.hasError.value) {
            return const Center(
              child: Text(
                'Failed to load restaurant details',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return ListView.builder(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemCount: listRestaurant.list.value.restaurants!.length,
              itemBuilder: (context, index) {
                var restaurant = listRestaurant.list.value.restaurants![index];
                return Material(
                  child: ListTile(
                    leading: Image.network(
                      "https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId!}",
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(
                        listRestaurant.list.value.restaurants![index].name!),
                    subtitle: Text(
                        listRestaurant.list.value.restaurants![index].city!),
                    trailing: Text(
                        'Rating: ${listRestaurant.list.value.restaurants![index].rating}'),
                    onTap: () async {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());

                      if (connectivityResult == ConnectivityResult.none) {
                        Get.rawSnackbar(message: 'No internet');
                      } else {
                        Get.dialog(const Center(
                          child: CircularProgressIndicator(),
                        ));
                        await detailRestaurant.getDetailRestaurant(
                            listRestaurant.list.value.restaurants![index].id!);
                        Get.back();
                        Get.toNamed(Routes.detail, arguments: restaurant);
                      }
                    },
                  ),
                );
              },
            );
          }
        })
      ],
    );
  }
}
