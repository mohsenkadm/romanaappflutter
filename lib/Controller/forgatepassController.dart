import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart'; 
import 'package:romanaappflutter/Model/UsersModel.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/confirmaccountwithchangpass.dart';

class forgatepassController extends GetxController {
  final phoneController = TextEditingController(); 
  RxBool islodedbtn = false.obs;
   final box= GetStorage(); 
   @override
  void onInit() { 
      
    super.onInit();
  }
  final ProfileuserController _controller = Get.find<ProfileuserController>();
  Future<void> forgatepassbtn() async {
    if (islodedbtn.value) return;
    islodedbtn.value = true;
    try {
      if (phoneController.text.isNotEmpty ) { 
        if(phoneController.text.length!=11){
           ErrorMessage.SnackMessage(
            'اكتب رقم الهاتف 11 رقما', Colors.red[400]!);
          return;
        }
        final response =
            await http.post(Uri.https(AppLink.apiUrl, AppLink.forgatepassUsers+phoneController.text));
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['success'] == false) {
            ErrorMessage.SnackMessage(
               result['msg'].toString(), Colors.red[400]!);
            return;
          }
        //  var data = result['data'];
          
        //  UsersModel _usersModel = UsersModel.fromJson(data);
          
           Get.to(const confirmaccountwithchangpass(), 
             arguments: [phoneController.text.toString()],
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
                     ErrorMessage.SnackMessage('تم ارسال كود التحقق بنجاح', Colors.green[400]!);
        }
        else {
           ErrorMessage.SnackMessage(
          'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
        }
      } else {
        ErrorMessage.SnackMessage(
            'اكتب رقم الهاتف', Colors.red[400]!);
       }
    } catch (ex) {
      ErrorMessage.SnackMessage(
          'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
    } finally {
      islodedbtn.value = false;
    }
  }
}
