import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Constant/api_auth.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/login.dart';

/// تجديد JWT مع Bearer إجباري — عند الفشل يُصفَّر الجلسة.
class TokenRefreshService {
  TokenRefreshService._();

  static Future<bool> refreshCurrentUserToken() async {
    final box = GetStorage();
    final uid = SessionStorage.userId(box);
    final token = SessionStorage.token(box);
    if (uid <= 0 || token.isEmpty) {
      await forceLogout();
      return false;
    }
    try {
      final res = await http.post(
        Uri.https(AppLink.apiUrl, AppLink.refreshToken(uid)),
        headers: ApiAuth.headers(),
      );
      if (res.statusCode == 401) {
        await forceLogout();
        return false;
      }
      if (res.statusCode != 200) {
        await forceLogout();
        return false;
      }
      final body = json.decode(res.body);
      if (body is! Map || body['success'] != true) {
        await forceLogout();
        return false;
      }
      final data = body['data'];
      String? newToken;
      if (data is Map) {
        newToken = (data['token'] ?? data['Token'])?.toString();
      } else if (data is String) {
        newToken = data;
      }
      if (newToken == null || newToken.isEmpty) {
        await forceLogout();
        return false;
      }
      await box.write('token', newToken);
      return true;
    } catch (_) {
      await forceLogout();
      return false;
    }
  }

  static Future<void> forceLogout() async {
    if (Get.isRegistered<ProfileuserController>()) {
      await Get.find<ProfileuserController>().deleteuser();
    } else {
      final box = GetStorage();
      await box.write('islogin', false);
      await box.write('UserId', 0);
      await box.write('userId', 0);
      await box.write('token', '');
    }
    Get.offAll(() => const Login(),
        duration: const Duration(milliseconds: 400),
        transition: Transition.fade);
  }
}
