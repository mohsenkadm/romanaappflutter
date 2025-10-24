import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:quiver/async.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/login.dart';

class confirmaccountwithchangpassController extends GetxController {
  final numb1Controller = TextEditingController(); 
  RxBool onEditing = true.obs; 
  final passController = TextEditingController();
  RxBool islodedbtn = false.obs;
  final box = GetStorage();

  var countdown = CountdownTimer(Duration(seconds: 30), const Duration(seconds: 1));
  RxBool isTimerRunning = false.obs;
  RxInt Counter=30.obs;
  @override
  void onInit() {
    super.onInit();

    startTimer();
  }

Future<void> restartTimer() async {
    countdown.cancel(); 
     countdown=CountdownTimer(Duration(seconds: 30), const Duration(seconds: 1));
    var para = Get.arguments;
    if (para != null) {
      String phone = para[0].toString();
     final response1 = await http
                .post(Uri.https(AppLink.apiUrl, AppLink.forgatepassUsers+phone));
            if (response1.statusCode == 200) {
               var data1 = jsonDecode(response1.body.toString());
              if (data1['success'] == false) {
                ErrorMessage.SnackMessage(data1['msg'], Colors.red[400]!);
                return;
              } 
                ErrorMessage.SnackMessage(data1['msg'], Colors.green[400]!);
              
            } 
            }
            startTimer();
  }
  

void startTimer()  { 
    isTimerRunning.value = true;
     countdown.listen((event) {
      Counter.value=event.remaining.inSeconds;
      if (event.remaining.inSeconds == 0) {
        Counter.value=30;
        isTimerRunning.value = false;
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
        if (numb1Controller.text.isNotEmpty 
           ) {
          String code = numb1Controller.text;
          final response = await http.post(Uri.https(
              AppLink.apiUrl, '${AppLink.Update_Pass_WithCode}${passController.text},$phone,$code'));
          if (response.statusCode == 200) {
            final result = json.decode(response.body);
            if (result['success'] == false) {
              ErrorMessage.SnackMessage(
                  result['msg'].toString(), Colors.red[400]!);
              return;
            } 
            Get.offAll(const Login(),
                duration: const Duration(milliseconds: 500),
                transition: Transition.fade);
            ErrorMessage.SnackMessage('تم تغيير كلمة المرور بنجاح', Colors.green[400]!);
          } else {
            ErrorMessage.SnackMessage(
                'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
          }
        } else {
          ErrorMessage.SnackMessage('اكتب رمز وكلمة المرور الجديدة', Colors.red[400]!);
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
