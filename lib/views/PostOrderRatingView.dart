import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/StarsController.dart';
import 'package:romanaappflutter/main.dart';

/// Shown when an order's status becomes Completed.
/// Lets the user rate (1) food quality and (2) delivery driver.
/// Both ratings are optional but each can only be submitted once.
class PostOrderRatingView extends StatefulWidget {
  const PostOrderRatingView({Key? key, required this.orderId}) : super(key: key);
  final int orderId;

  @override
  State<PostOrderRatingView> createState() => _PostOrderRatingViewState();
}

class _PostOrderRatingViewState extends State<PostOrderRatingView> {
  final StarsController _controller = Get.put(StarsController());

  late bool _foodSubmitted;
  late bool _driverSubmitted;

  @override
  void initState() {
    super.initState();
    _foodSubmitted = _controller.hasRatedFood(widget.orderId);
    _driverSubmitted = _controller.hasRatedDriver(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.close,
                color: Theme.of(context).primaryColor),
          ),
          title: Text(
            'تقييم الطلب',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _ratingCard(
                title: 'جودة الطعام',
                icon: Icons.restaurant_rounded,
                submitted: _foodSubmitted,
                initialRating: _controller.foodStars.value,
                commentController: _controller.foodCommentController,
                isLoadingObs: _controller.isLoadingFood,
                onRatingChanged: (r) => _controller.foodStars.value = r,
                onSubmit: () async {
                  final ok =
                      await _controller.submitFoodRating(widget.orderId);
                  if (ok) setState(() => _foodSubmitted = true);
                },
              ),
              const SizedBox(height: 16),
              _ratingCard(
                title: 'سائق التوصيل',
                icon: Icons.delivery_dining_rounded,
                submitted: _driverSubmitted,
                initialRating: _controller.driverStars.value,
                commentController: _controller.driverCommentController,
                isLoadingObs: _controller.isLoadingDriver,
                onRatingChanged: (r) => _controller.driverStars.value = r,
                onSubmit: () async {
                  final ok =
                      await _controller.submitDriverRating(widget.orderId);
                  if (ok) setState(() => _driverSubmitted = true);
                },
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'تخطي',
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ratingCard({
    required String title,
    required IconData icon,
    required bool submitted,
    required double initialRating,
    required TextEditingController commentController,
    required RxBool isLoadingObs,
    required ValueChanged<double> onRatingChanged,
    required Future<void> Function() onSubmit,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).secondaryHeaderColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor)),
              const SizedBox(width: 8),
              Icon(icon, color: Theme.of(context).primaryColor),
            ],
          ),
          const SizedBox(height: 12),
          AbsorbPointer(
            absorbing: submitted,
            child: Opacity(
              opacity: submitted ? 0.6 : 1.0,
              child: RatingBar.builder(
                initialRating: initialRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (_, __) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: onRatingChanged,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: commentController,
              enabled: !submitted,
              decoration: const InputDecoration(
                hintTextDirection: TextDirection.rtl,
                hintText: 'اكتب تعليقاً (اختياري)',
                contentPadding: EdgeInsets.all(12),
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: submitted ? null : () => onSubmit(),
              icon: Icon(
                submitted ? Icons.check_circle : Icons.send_rounded,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: submitted
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              label: Obx(() => Text(
                    submitted
                        ? 'تم الإرسال'
                        : (isLoadingObs.value
                            ? 'جاري الإرسال...'
                            : 'إرسال التقييم'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
