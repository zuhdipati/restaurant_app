import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/data/model/restaurant_list_model.dart';
import 'package:http/http.dart' as http;

class SearchResController extends GetxController {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _search = 'search?q=';

  final isLoading = RxBool(true);
  var listSearch = [].obs;
  TextEditingController searchController = TextEditingController();

  Future<void> searchRestaurant(String query) async {
    try {
      isLoading.value = true;
      var url = Uri.parse(_baseUrl + _search + query);

      var response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final listRestaurant = ListRestaurant.fromJson(jsonResponse);
        if (query.isEmpty) {
          // listSearch.assignAll(listRestaurant.restaurants!);
          isLoading.value = false;
        } else {
          final filteredRestaurants = listRestaurant.restaurants!
              .where((restaurant) =>
                  restaurant.name!.toLowerCase().contains(query.toLowerCase()))
              .toList();
          listSearch.assignAll(filteredRestaurants);
          isLoading.value = false;
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data $e');
    }
  }
}
