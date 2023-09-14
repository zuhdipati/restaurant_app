import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ReviewController extends GetxController {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  static const String _review = 'review';

  final isLoading = RxBool(true);
  TextEditingController namaController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  Future addReview(String id, String nama, String review) async {
    var url = Uri.parse(_baseUrl + _review);
    var headers = {'Content-Type': 'application/json'};
    var body = {"id": id, "name": nama, "review": review};

    var jsonBody = jsonEncode(body);

    var response = await http.post(url, headers: headers, body: jsonBody);
    if (response.statusCode == 200) {
      isLoading.value = false;
      refresh();
    }
  }
}
