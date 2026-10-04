import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/confirmaccountwithchangpass.dart';

class forgatepassController extends GetxController {
  final phoneController = TextEditingController();
  RxBool islodedbtn = false.obs;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> forgatepassbtn() async {
    if (islodedbtn.value) return;
    islodedbtn.value = true;
    try {
      final phone = phoneController.text.trim();
      if (phone.isEmpty) {
        ErrorMessage.SnackMessage('اكتب رقم الهاتف', Colors.red[400]!);
        return;
      }
      if (phone.length != 11) {
        ErrorMessage.SnackMessage(
            'اكتب رقم الهاتف 11 رقما', Colors.red[400]!);
        return;
      }
      final response = await http.post(
          Uri.https(AppLink.apiUrl, AppLink.forgatepassUsers + phone));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final msg = result['msg']?.toString() ?? '';
        if (result['success'] == false) {
          ErrorMessage.SnackMessage(
              msg.isNotEmpty ? msg : 'فشل الإرسال', Colors.red[400]!);
          return;
        }
        Get.to(const confirmaccountwithchangpass(),
            arguments: [phone],
            duration: const Duration(milliseconds: 500),
            transition: Transition.fade);
        ErrorMessage.SnackMessage(
            msg.isNotEmpty
                ? msg
                : 'تم ارسال كود التحقق المكون من ${OtpPolicy.codeLength} أرقام',
            Colors.green[400]!);
      } else {
        ErrorMessage.SnackMessage(
            'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
      }
    } catch (ex) {
      ErrorMessage.SnackMessage(
          'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
    } finally {
      islodedbtn.value = false;
    }
  }
}
