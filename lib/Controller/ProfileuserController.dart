import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';

import 'package:http/http.dart' as http;
import 'package:romanaappflutter/linkapi.dart';

class ProfileuserController extends GetxController{
 
  final user = Rxn<UsersModel>();
  RxBool togglenotification = true.obs; 
  @override
  void onInit() {
    super.onInit();
    fetchData();
  }
  Future<void> toggle() async {
    if(togglenotification.value){
    await OneSignal.User.pushSubscription.optOut();
    togglenotification.value=false;
    }
    else{
      await OneSignal.User.pushSubscription.optIn();
      togglenotification.value=true;
    }
  }
  Future<void> fetchData() async {  
    final box= GetStorage();  
    box.read('UserId')==0? user.value=null:
    user.value=UsersModel(userId: box.read('UserId')??0, Name: box.read('Name'), 
    Phone: box.read('Phone'), Address: box.read('Address'), FunctionPoint: box.read('FunctionPoint'));
     user.value!=null?
OneSignal.login(user.value!.userId.toString()):null; 
  }


  final box = GetStorage();
  Future<void> deleteuser({int id = 0}) async {
   // try {
      // String userid = "";
      // if (id == 0) {
      //   var data = Get.arguments;
      //   if (data != null) userid = data[0].toString();
      // } else {
      //   userid = id.toString();
      // }
      // final Map<String, String> _queryParameters = <String, String>{
      //   'Id': userid,
      // };
      // var authToken = box.read('token');
      // var headers = {'Authorization': 'Bearer $authToken'};
      // var response = await http.delete(
      //   Uri.https(AppLink.apiUrl, AppLink.DeleteUser, _queryParameters),
      //   headers: headers,
      // );
      // if (response.statusCode == 200) {
      //   var data = jsonDecode(response.body.toString());
      //   if (data['success'] == false) {
      //     ErrorMessage.SnackMessage(
      //         'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
      //     return;
      //   } else {
          ErrorMessage.SnackMessage('تم تسجيل اخروج من الحساب بنجاح', Colors.green[400]!);
             await box.write('islogin', true);
          await box.write('UserId', 0);
          await box.write('token','');
          await box.write('Name', '');
          await box.write('Phone', '');
          await box.write('Address', '');
          await box.write('FunctionPoint', '');
          await box.write('Password', '');
          OneSignal.logout();
          fetchData();
     
    //     }
    //   } else {
    //     ErrorMessage.SnackMessage(
    //         'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
    //     return;
    //   }
    // } catch (ex) {
    //   ErrorMessage.SnackMessage(
    //       'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
    //   return;
    // }
  }

}