import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Model/NotifModel.dart';
import '../linkapi.dart';

// ignore: camel_case_types
class notificationController extends GetxController {
  var items = [].obs;
  RxBool isloded = true.obs;
  final RxInt unreadCount = 0.obs;

  final ProfileuserController _profileuserController =
      Get.find<ProfileuserController>();
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void markAllRead() {
    unreadCount.value = 0;
  }

  Future<void> fetchData() async {
    try {
      var user = _profileuserController.user.value;
      int UserId = user == null ? 0 : _profileuserController.user.value!.userId;
      final Map<String, String> _queryParameters = <String, String>{
        'UserId': UserId.toString(),
      };
      final response = await http.get(
          Uri.https(AppLink.apiUrl, AppLink.getNotification, _queryParameters));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == false) {
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);

      isloded.value = false;
          return;
        }
        var data = result['data'];

        items.value = data.map((json) => NotifModel.fromJson(json)).toList();
      } else {
        ErrorMessage.error;
      }
    } catch (ex) {
      ErrorMessage.error;
    } finally {
      isloded.value = false;
    }
  }
}
