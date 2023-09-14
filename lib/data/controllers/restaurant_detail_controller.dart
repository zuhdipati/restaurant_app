import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:restaurant_app/data/model/restaurant_detail_model.dart';

class DetailController extends GetxController {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _detail = 'detail/';

  var detail = DetailRestaurant().obs;
  var restaurantId = ''.obs;

  final isLoading = RxBool(true);

  final hasError = RxBool(false);

  Future getDetailRestaurant(String idListSelected) async {
    var url = Uri.parse(_baseUrl + _detail + idListSelected);

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = DetailRestaurant.fromJson(json.decode(response.body));
      detail.value = data;
      restaurantId.value = data.restaurant!.id!;
      isLoading.value = false;
    } else {
      isLoading.value = false;
      hasError.value = true;
      throw Exception('Failed to load restaurant details');
    }
  }

  void updateData() {
    getDetailRestaurant(restaurantId.value);
  }
}
