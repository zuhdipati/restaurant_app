import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class RestaurantDetail extends StatelessWidget {
  static const routeName = '/restaurant_detail';

  final RestaurantElement restaurant;
  final Divider _divider = const Divider(
    thickness: 2,
    indent: 15,
    endIndent: 15,
  );

  const RestaurantDetail({super.key, required this.restaurant});

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
      body: _detailRestaurant(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(restaurant.name),
        transitionBetweenRoutes: false,
      ),
      child: _detailRestaurant(),
    );
  }

  ListView _detailRestaurant() {
    return ListView(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          child: Image.network(
            restaurant.pictureId,
            height: 250,
            fit: BoxFit.cover,
          ),
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
                    restaurant.name,
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
                    restaurant.city,
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
                restaurant.description,
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
        const SizedBox(height: 5),
        _divider,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Menu: ",
                style: myTextTheme.bodyLarge,
              ),
              const SizedBox(height: 5),
              const Text("Foods: "),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    restaurant.menus.foods.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 10, top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          restaurant.menus.foods[index].name,
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
                    restaurant.menus.drinks.length,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 10, top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          restaurant.menus.drinks[index].name,
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
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
