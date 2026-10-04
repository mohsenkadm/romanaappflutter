import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/api_auth.dart';
import 'package:romanaappflutter/Model/StarsModel.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/linkapi.dart';

class StarsController extends GetxController {
    
   RxBool isloded=false.obs;
   RxBool isLoadingFood = false.obs;
   RxBool isLoadingDriver = false.obs;
   RxDouble starCount=3.0.obs;
   RxDouble foodStars = 5.0.obs;
   RxDouble driverStars = 5.0.obs;
  final commentController=TextEditingController(); 
  final foodCommentController = TextEditingController();
  final driverCommentController = TextEditingController();
  
  @override
  void onInit() {
    super.onInit();
    starCount.value=3.0;
  }

  static const String _ratedFoodKeyPrefix = 'rated_food_';
  static const String _ratedDriverKeyPrefix = 'rated_driver_';

  bool hasRatedFood(int orderId) =>
      GetStorage().read('$_ratedFoodKeyPrefix$orderId') == true;
  bool hasRatedDriver(int orderId) =>
      GetStorage().read('$_ratedDriverKeyPrefix$orderId') == true;

  Map<String, String> get _ratingHeaders => ApiAuth.headers(json: true);

  bool _httpOk(int code) => code >= 200 && code < 300;

  /// يفسر استجابة POST /orders/{id}/rating/...
  bool _parseRatingResponse(http.Response response, String fallbackError) {
    if (!_httpOk(response.statusCode)) {
      if (response.statusCode == 401) {
        ErrorMessage.SnackMessage(
          'يرجى تسجيل الدخول مجدداً',
          Colors.red[400]!,
        );
      } else {
        ErrorMessage.SnackMessage(fallbackError, Colors.red[400]!);
      }
      return false;
    }
    if (response.body.trim().isEmpty) return true;
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data['success'] == false) {
        ErrorMessage.SnackMessage(
          data['msg']?.toString() ?? fallbackError,
          Colors.red[400]!,
        );
        return false;
      }
    } catch (_) {
      // بعض الاستجابات 200 بدون JSON
    }
    return true;
  }

  /// Submits the food / store rating for [orderId]. Can only succeed once.
  Future<bool> submitFoodRating(int orderId) async {
    if (isLoadingFood.value) return false;
    if (hasRatedFood(orderId)) {
      ErrorMessage.SnackMessage(
          'تم تقييم جودة الطعام لهذا الطلب مسبقاً', Colors.orange[400]!);
      return false;
    }
    if (_ratingHeaders['Authorization'] == null) {
      ErrorMessage.SnackMessage(
        'يرجى تسجيل الدخول لإرسال التقييم',
        Colors.orange[400]!,
      );
      return false;
    }
    isLoadingFood.value = true;
    try {
      final comment = foodCommentController.text.trim();
      final body = jsonEncode({
        'stars': foodStars.value.toInt(),
        if (comment.isNotEmpty) 'comment': comment,
      });
      final response = await http.post(
        Uri.https(AppLink.apiUrl, AppLink.ratingStore(orderId)),
        headers: _ratingHeaders,
        body: body,
      );
      if (!_parseRatingResponse(response, 'تعذر إرسال التقييم')) {
        return false;
      }
      await GetStorage().write('$_ratedFoodKeyPrefix$orderId', true);
      ErrorMessage.SnackMessage(
          'شكراً على تقييم جودة الطعام', Colors.green[400]!);
      return true;
    } catch (_) {
      ErrorMessage.SnackMessage('تعذر إرسال التقييم', Colors.red[400]!);
      return false;
    } finally {
      isLoadingFood.value = false;
    }
  }

  /// Submits the delivery driver rating for [orderId]. Can only succeed once.
  Future<bool> submitDriverRating(int orderId) async {
    if (isLoadingDriver.value) return false;
    if (hasRatedDriver(orderId)) {
      ErrorMessage.SnackMessage(
          'تم تقييم السائق لهذا الطلب مسبقاً', Colors.orange[400]!);
      return false;
    }
    if (_ratingHeaders['Authorization'] == null) {
      ErrorMessage.SnackMessage(
        'يرجى تسجيل الدخول لإرسال التقييم',
        Colors.orange[400]!,
      );
      return false;
    }
    isLoadingDriver.value = true;
    try {
      final comment = driverCommentController.text.trim();
      final body = jsonEncode({
        'stars': driverStars.value.toInt(),
        if (comment.isNotEmpty) 'comment': comment,
      });
      final response = await http.post(
        Uri.https(AppLink.apiUrl, AppLink.ratingDriver(orderId)),
        headers: _ratingHeaders,
        body: body,
      );
      if (!_parseRatingResponse(response, 'تعذر إرسال التقييم')) {
        return false;
      }
      await GetStorage().write('$_ratedDriverKeyPrefix$orderId', true);
      ErrorMessage.SnackMessage(
          'شكراً على تقييم السائق', Colors.green[400]!);
      return true;
    } catch (_) {
      ErrorMessage.SnackMessage('تعذر إرسال التقييم', Colors.red[400]!);
      return false;
    } finally {
      isLoadingDriver.value = false;
    }
  }
  
  

  Future<void> sendStars() async{
    if(isloded.value) return;
    isloded.value=true;
    try { 
      var data = Get.arguments;
   if(data!=null){
    var resId=data[0];
     StarsModel stars=StarsModel(starsId: 0, 
      starsCount: starCount.value.toInt(),
      restaurantId: int.tryParse(resId), 
      
      comments: commentController.text);
  var body=jsonEncode(stars.toJson());
  var response = await http.post(
      Uri.https(AppLink.apiUrl, AppLink.sendStars),
      headers: ApiAuth.headers(json: true),
      body: body,
      );
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body.toString());
    if(data['success']==false){ 
    isloded.value=false; 
     ErrorMessage.SnackMessage('حدث خطا اثناء عملية جلب البيانات',Colors.red[400]!);
    return;
     }
    else{  
      navigator?.pop(); 
     ErrorMessage.SnackMessage('تم تقييم بنجاح',Colors.green[400]!); 
    }
  } else { 
     ErrorMessage.SnackMessage('حدث خطا اثناء عملية جلب البيانات',Colors.red[400]!);
     return;
  }
  }
} 
catch (ex) {
     ErrorMessage.SnackMessage('حدث خطا اثناء عملية جلب البيانات',Colors.red[400]!);
     return;
} 
   finally{
    isloded.value=false; 
   }
  }

  
}