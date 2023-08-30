import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/common/styles.dart';
import 'package:restaurant_app/data/model/restaurant.dart';
import 'package:restaurant_app/pages/restaurant_detail.dart';
import 'package:restaurant_app/widgets/platform_widget.dart';

class RestaurantListPage extends StatefulWidget {
  static const routeName = '/home_page';

  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

Widget _buildAndroid(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Dashboard'),
    ),
    body: _restaurantList(context),
  );
}

Widget _buildIos(BuildContext context) {
  return CupertinoPageScaffold(
    navigationBar: const CupertinoNavigationBar(
      middle: Text('Dashboard'),
      transitionBetweenRoutes: false,
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
      FutureBuilder<String>(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/local_restaurant.json'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('No data available');
          } else {
            final List<RestaurantElement> restaurants =
                parseRestaurants(snapshot.data);
            return ListView.builder(
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return Material(
                  child: ListTile(
                    leading: Image.network(
                      restaurant.pictureId,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    title: Text(restaurant.name),
                    subtitle: Text(restaurant.city),
                    trailing: Text('Rating: ${restaurant.rating.toString()}'),
                    onTap: () {
                      Navigator.pushNamed(context, RestaurantDetail.routeName,
                          arguments: restaurant);
                    },
                  ),
                );
              },
            );
          }
        },
      )
    ],
  );
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  @override
  Widget build(BuildContext context) {
    return const PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}
