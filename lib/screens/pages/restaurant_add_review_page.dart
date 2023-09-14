import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/core/styles.dart';
import 'package:restaurant_app/data/controllers/restaurant_add_review_controller.dart';
import 'package:restaurant_app/data/controllers/restaurant_detail_controller.dart';

class ReviewPage extends StatelessWidget {
  final reviewController = Get.put(ReviewController());
  final DetailController detailController = Get.find();

  ReviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Review'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              TextField(
                controller: reviewController.namaController,
                decoration: const InputDecoration(
                  hintText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: reviewController.reviewController,
                decoration: const InputDecoration(
                  hintText: 'Review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: secondaryColor,
                  ),
                  onPressed: () async {
                    final id = detailController.restaurantId.value;
                    final nama = reviewController.namaController.text;
                    final ulasan = reviewController.reviewController.text;

                    await reviewController.addReview(id, nama, ulasan);

                    Get.back();
                    detailController.updateData();
                    Get.rawSnackbar(
                      message: "Review Berhasil Dikirim",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: secondaryColor,
                    );
                  },
                  child: const Text(
                    'Kirim Ulasan',
                    style: TextStyle(color: primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
