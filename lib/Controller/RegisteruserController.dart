import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/MainApp.dart';
import 'package:romanaappflutter/views/confirmaccount.dart';

class RegisteruserController extends GetxController {
  RxBool islodedbtn = false.obs;
  RxBool isloded = true.obs;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final functionPointController = TextEditingController();
  final phoneController = TextEditingController();
  final passController = TextEditingController();

  final ProfileuserController _controller = Get.find<ProfileuserController>();
  var itemcategories = [].obs;
  final determinePositionLocation locationService =
      Get.put(determinePositionLocation());

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  final box = GetStorage();

  Future<void> saveuser() async {
    if (islodedbtn.value) return;
    islodedbtn.value = true;
    try {
      var data = Get.arguments;
      int userId = 0;
      if (data != null) {
        userId = data[0];
      }
      var uri =
          Uri.parse("https://" + AppLink.apiUrl + "/" + AppLink.PostUsers);

      var request = http.MultipartRequest('POST', uri);

      var latitude = locationService.latitude.value;
      var longitude = locationService.longitude.value;
      request.fields['userId'] = userId.toString();
      request.fields['name'] = nameController.text;
      request.fields['address'] = addressController.text;
      request.fields['functionPoint'] = functionPointController.text;
      request.fields['password'] = passController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['lat'] = latitude.toString();
      request.fields['long'] = longitude.toString();
      request.fields['isDelete'] = false.toString();
      request.fields['isConfirm'] = false.toString();
      request.fields['isActive'] = true.toString();

      var response = await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        if (data['success'] == false) {
          ErrorMessage.SnackMessage(data['msg'], Colors.red[400]!);
          return;
        } else {
          UsersModel userModel = UsersModel.fromJson(data['data']);
          if (userId > 0) {
            await box.write('islogin', true);
            await box.write('UserId', userModel.userId);
            await box.write('token', userModel.Token.toString());
            await box.write('Name', userModel.Name);
            await box.write('Phone', userModel.Phone);
            await box.write('Address', userModel.Address);
            await box.write('FunctionPoint', userModel.FunctionPoint);
           await box.write('Password', passController.text);
          } else {
            await box.write('Password', passController.text);
            await box.write('Phone', userModel.Phone);
          }
          OneSignal.login(userModel.userId.toString());

          if (userId > 0) {
            Get.offAll(const MainApp(),
                duration: const Duration(milliseconds: 500),
                transition: Transition.fade);
                _controller.fetchData();
          } else {
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
          }
          if (userId > 0) {
            ErrorMessage.SnackMessage(
                'تم تعديل معلوماتك  بنجاح', Colors.green[400]!);
          } else {
            ErrorMessage.SnackMessage(
                'يجب تاكيد حسابك سوف نرسل اليك رمز برسالة', Colors.green[400]!);
          }
        }
      } else {
        ErrorMessage.SnackMessage(
            'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
        return;
      }
    } catch (ex) {
      ErrorMessage.SnackMessage(
          'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
      return;
    } finally {
      islodedbtn.value = false;
    }
  }

  Future<void> fetchData() async {
    isloded.value = true;
    try {
      var data = Get.arguments;
      if (data != null) {
        var id = data[0].toString();
        final Map<String, String> _queryParameters = <String, String>{
          'Id': id,
        };
        final response = await http.get(
            Uri.https(AppLink.apiUrl, AppLink.getuserById, _queryParameters));
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['success'] == false) {
            ErrorMessage.SnackMessage(
                'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
            isloded.value = false;
            return;
          }
          var data = result['data'];

          var item = UsersModel.fromJson(data);
          nameController.text = item.Name!;
          addressController.text = item.Address.toString();
          functionPointController.text = item.FunctionPoint.toString();
          passController.text = item.Password.toString();
          phoneController.text = item.Phone.toString();
        } else {
          ErrorMessage.error;
        }
      }
    } catch (ex) {
      ErrorMessage.error;
    } finally {
      isloded.value = false;
    }
  }
}
