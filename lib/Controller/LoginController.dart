import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/MainApp.dart';
import 'package:romanaappflutter/views/confirmaccount.dart';

class LoginController extends GetxController {
  final passController = TextEditingController();
  final phoneController = TextEditingController();
  RxBool islodedbtn = false.obs;
  final box = GetStorage();
  @override
  void onInit() {
    passController.text =
        box.read('Password') == null ? "" : box.read("Password").toString();
    phoneController.text =
        box.read('Phone') == null ? "" : box.read("Phone").toString();

    super.onInit();
  }

  final ProfileuserController _controller = Get.find<ProfileuserController>();
  Future<void> loginbtn() async {
    if (islodedbtn.value) return;
    islodedbtn.value = true;
    try {
      if (passController.text.isNotEmpty &&
          phoneController.text.isNotEmpty) {
        final Map<String, String> _queryParameters = <String, String>{
          'UserName': phoneController.text,
          'password': passController.text
        };
        final response = await http.get(
            Uri.https(AppLink.apiUrl, AppLink.loginUsers, _queryParameters));
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['success'] == false) {
            ErrorMessage.SnackMessage(
                result['msg'].toString(), Colors.red[400]!);
            if (result['msg'] == "حسابك غير مؤكد") {
             // send otp 
            final response1 = await http
                .post(Uri.https(AppLink.apiUrl, AppLink.SendOTPCodeToPhoneNo+phoneController.text));
            if (response1.statusCode == 200) {
               var data1 = jsonDecode(response1.body.toString());
              if (data1['success'] == false) {
                ErrorMessage.SnackMessage(data1['msg'], Colors.red[400]!);
                return;
              }
              Get.to(const confirmaccount(),
                  arguments: [phoneController.text.toString()],
                  duration: const Duration(milliseconds: 500),
                  transition: Transition.fade);
             }
              return;
            } 
            return;
          }
          var data = result['data'];

          final usersModel = UsersModel.fromJson(data);
          await SessionStorage.persistUser(box, usersModel);
          await box.write('Password', passController.text);
          OneSignal.login(usersModel.userId.toString());
          await _controller.applySession(usersModel);
          Get.offAll(const MainApp(),
              duration: const Duration(milliseconds: 500),
              transition: Transition.fade);
          ErrorMessage.SnackMessage(
              'تم تسجيل الدخول بنجاح', Colors.green[400]!);
        }
      } else {
        ErrorMessage.SnackMessage(
            'اكتب كلمة المرور او اسم المستخدم', Colors.red[400]!);
      }
    } catch (ex) {
      ErrorMessage.SnackMessage(
          'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
    } finally {
      islodedbtn.value = false;
    }
  }
}
