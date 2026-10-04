import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/StarsController.dart';
import 'package:romanaappflutter/main.dart';

class StarsView extends StatefulWidget {
  const StarsView({Key? key}) : super(key: key);

  @override
  _StarsViewState createState() => _StarsViewState();
}

// ignore: camel_case_types
class _StarsViewState extends State<StarsView> {
  final StarsController _controller = Get.put(StarsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          RatingBar.builder(
            initialRating: 3,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              _controller.starCount.value = rating;
            },
          ),
          const SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .secondaryHeaderColor, // Set your desired background color here
              borderRadius:
                  BorderRadius.circular(8.0), // Optional: Add rounded corners
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: double.infinity,
            child: TextField(
                controller: _controller.commentController,
                decoration: const InputDecoration(
                  hintTextDirection: TextDirection.rtl,
                  hintText: 'تعليق',
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                )),
          ),
          const SizedBox(height: 10,),
          ElevatedButton.icon(
              onPressed: () => {_controller.sendStars()},
              icon: const Icon(
                Icons.stars,
                color: Colors.white,
              ),
              style: ElevatedButton.styleFrom(
                  backgroundColor: myTheme.primaryColor),
              label: _controller.isloded.value
                    ? const Center(child: CircularProgressIndicator())
                    : const Text(
                        'ارسال التقييم',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
        ]),
        backgroundColor: Colors.white,
      );
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
        leading: IconButton(
            onPressed: () {
              navigator?.pop();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "تقييم",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
