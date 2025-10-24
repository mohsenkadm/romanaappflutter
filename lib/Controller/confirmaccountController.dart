import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quiver/async.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/MainApp.dart';

class confirmaccountController extends GetxController {
  final numb1Controller = TextEditingController(); 

  RxBool onEditing = true.obs; 
  RxBool islodedbtn = false.obs;
  var countdown = CountdownTimer(Duration(seconds: 30), const Duration(seconds: 1));
  RxBool isTimerRunning = false.obs;
  RxInt Counter=30.obs;
  
  final box = GetStorage();
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
                .post(Uri.https(AppLink.apiUrl, AppLink.SendOTPCodeToPhoneNo+phone));
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
  final ProfileuserController _controller = Get.find<ProfileuserController>();
   Future<void> confirmaccount() async {
    var para = Get.arguments;
    if (para != null) {
      String phone = para[0].toString();
      if (islodedbtn.value) return;
      islodedbtn.value = true;
      try {
        if (numb1Controller.text.isNotEmpty ) {
          String code = numb1Controller.text ;
          final response = await http.post(Uri.https(
              AppLink.apiUrl, '${AppLink.ConfirmCode}$code,$phone'));
          if (response.statusCode == 200) {
            final result = json.decode(response.body);
            if (result['success'] == false) {
              ErrorMessage.SnackMessage(
                  result['msg'].toString(), Colors.red[400]!);
              return;
            }
            var data = result['data'];

            UsersModel _usersModel = UsersModel.fromJson(data);
            await box.write('islogin', true);
            await box.write('UserId', _usersModel.userId);
            await box.write('token', _usersModel.Token.toString());
            await box.write('Name', _usersModel.Name);
            await box.write('Phone', _usersModel.Phone);
            await box.write('Address', _usersModel.Address);
            await box.write('FunctionPoint', _usersModel.FunctionPoint);
            OneSignal.login(_usersModel.userId.toString());
            _controller.fetchData();
            Get.offAll(const MainApp(),
                duration: const Duration(milliseconds: 500),
                transition: Transition.fade);
            ErrorMessage.SnackMessage('تم التحقق بنجاح', Colors.green[400]!);
          } else {
            ErrorMessage.SnackMessage(
                'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
          }
        } else {
          ErrorMessage.SnackMessage('اكتب الرمز اولا ', Colors.red[400]!);
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
