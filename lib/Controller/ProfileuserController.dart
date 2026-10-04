import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';

class ProfileuserController extends GetxController {
  final user = Rxn<UsersModel>();
  RxBool togglenotification = true.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> toggle() async {
    if (togglenotification.value) {
      await OneSignal.User.pushSubscription.optOut();
      togglenotification.value = false;
    } else {
      await OneSignal.User.pushSubscription.optIn();
      togglenotification.value = true;
    }
  }

  Future<void> fetchData() async {
    if (!SessionStorage.isLoggedIn(box)) {
      user.value = null;
      return;
    }
    final model = SessionStorage.userFromBox(box);
    user.value = model;
    OneSignal.login(model.userId.toString());
  }

  Future<void> applySession(UsersModel model) async {
    await SessionStorage.persistUser(box, model);
    user.value = model;
    OneSignal.login(model.userId.toString());
  }

  Future<void> deleteuser({int id = 0}) async {
    ErrorMessage.SnackMessage(
        'تم تسجيل اخروج من الحساب بنجاح', Colors.green[400]!);
    await box.write('islogin', false);
    await box.write('UserId', 0);
    await box.write('userId', 0);
    await box.write('token', '');
    await box.write('Name', '');
    await box.write('Phone', '');
    await box.write('Address', '');
    await box.write('FunctionPoint', '');
    await box.write('Password', '');
    OneSignal.logout();
    user.value = null;
  }
}
