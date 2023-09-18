import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:restaurant_app/data/model/restaurant_list_model.dart';

class ListController extends GetxController {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _list = 'list';

  var list = ListRestaurant().obs;
  var idList = ''.obs;

  final isLoading = RxBool(true);

  final hasError = RxBool(false);

  Future getListRestaurant() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      isLoading.value = false;
      hasError.value = true;
      return;
    }

    var url = Uri.parse(_baseUrl + _list);

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = ListRestaurant.fromJson(json.decode(response.body));
      list.value = data;
      isLoading.value = false;
      refresh();
    } else {
      isLoading.value = false;
      hasError.value = true;
      throw Exception('Failed to load list of restaurants');
    }
  }

  @override
  void onInit() {
    super.onInit();
    getListRestaurant();
  }
}
