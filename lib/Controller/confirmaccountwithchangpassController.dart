import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/login.dart';

class confirmaccountwithchangpassController extends GetxController {
  final numb1Controller = TextEditingController();
  RxBool onEditing = true.obs;
  final passController = TextEditingController();
  RxBool islodedbtn = false.obs;
  final box = GetStorage();

  RxBool isTimerRunning = false.obs;
  RxInt Counter = OtpPolicy.resendCooldownSeconds.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    numb1Controller.dispose();
    passController.dispose();
    super.onClose();
  }

  Future<void> restartTimer() async {
    if (isTimerRunning.value) {
      ErrorMessage.SnackMessage(
          'انتظر ${Counter.value} ثانية قبل اعادة ارسال الكود',
          Colors.orange[700]!);
      return;
    }
    var para = Get.arguments;
    if (para != null) {
      String phone = para[0].toString();
      final response1 = await http
          .post(Uri.https(AppLink.apiUrl, AppLink.forgatepassUsers + phone));
      if (response1.statusCode == 200) {
        var data1 = jsonDecode(response1.body.toString());
        final msg = data1['msg']?.toString() ?? '';
        if (data1['success'] == false) {
          final wait = OtpPolicy.parseWaitSeconds(msg);
          if (wait != null) startTimer(seconds: wait);
          ErrorMessage.SnackMessage(msg, Colors.red[400]!);
          return;
        }
        ErrorMessage.SnackMessage(msg, Colors.green[400]!);
        startTimer();
      }
    }
  }

  void startTimer({int? seconds}) {
    _timer?.cancel();
    Counter.value = seconds ?? OtpPolicy.resendCooldownSeconds;
    isTimerRunning.value = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (Counter.value <= 1) {
        Counter.value = 0;
        isTimerRunning.value = false;
        t.cancel();
      } else {
        Counter.value--;
      }
    });
  }

  Future<void> confirmaccount() async {
    var para = Get.arguments;
    if (para != null) {
      String phone = para[0].toString();
      if (islodedbtn.value) return;
      islodedbtn.value = true;
      try {
        final code = numb1Controller.text.trim();
        final pass = passController.text.trim();
        if (!OtpPolicy.isValidCode(code)) {
          ErrorMessage.SnackMessage(
              'أدخل كود التحقق المكون من ${OtpPolicy.codeLength} أرقام',
              Colors.red[400]!);
          return;
        }
        if (!OtpPolicy.isValidPassword(pass)) {
          ErrorMessage.SnackMessage(
              'كلمة المرور يجب أن تكون ${OtpPolicy.minPasswordLength} أحرف على الأقل',
              Colors.red[400]!);
          return;
        }
        final response = await http.post(Uri.https(AppLink.apiUrl,
            '${AppLink.Update_Pass_WithCode}$pass,$phone,$code'));
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          final msg = result['msg']?.toString() ?? '';
          if (result['success'] == false) {
            ErrorMessage.SnackMessage(
                msg.isNotEmpty ? msg : 'فشل التحديث', Colors.red[400]!);
            if (OtpPolicy.isExpiredOrExhausted(msg)) {
              numb1Controller.clear();
            }
            return;
          }
          Get.offAll(const Login(),
              duration: const Duration(milliseconds: 500),
              transition: Transition.fade);
          ErrorMessage.SnackMessage(
              msg.isNotEmpty ? msg : 'تم تغيير كلمة المرور بنجاح',
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
}
