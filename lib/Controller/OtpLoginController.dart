import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/CoverageGate.dart';
import 'package:romanaappflutter/views/MainApp.dart';

class OtpLoginController extends GetxController {
  final phoneController = TextEditingController();
  final codeController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool codeSent = false.obs;
  final RxInt resendSeconds = 0.obs;
  final box = GetStorage();
  Timer? _resendTimer;

  @override
  void onClose() {
    _resendTimer?.cancel();
    phoneController.dispose();
    codeController.dispose();
    super.onClose();
  }

  bool get canResend => resendSeconds.value <= 0 && !isLoading.value;

  String? _normalizePhone() {
    final p = phoneController.text.trim().replaceAll(RegExp(r'\s+'), '');
    if (p.length != 11) return null;
    return p;
  }

  void _startResendCooldown([int? seconds]) {
    _resendTimer?.cancel();
    resendSeconds.value = seconds ?? OtpPolicy.resendCooldownSeconds;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (resendSeconds.value <= 1) {
        resendSeconds.value = 0;
        t.cancel();
      } else {
        resendSeconds.value--;
      }
    });
  }

  Future<void> sendOtp() async {
    final phone = _normalizePhone();
    if (phone == null) {
      ErrorMessage.SnackMessage('login.phone_invalid'.tr, Colors.red[400]!);
      return;
    }
    if (!canResend && codeSent.value) {
      ErrorMessage.SnackMessage(
          'انتظر ${resendSeconds.value} ثانية قبل اعادة ارسال الكود',
          Colors.orange[700]!);
      return;
    }
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final res = await http.post(
        Uri.https(AppLink.apiUrl, AppLink.sendOtpLogin(phone)),
      );
      final result = json.decode(res.body);
      final msg = result['msg']?.toString() ?? '';
      if (result['success'] == true) {
        codeSent.value = true;
        codeController.clear();
        _startResendCooldown();
        ErrorMessage.SnackMessage(
            msg.isNotEmpty ? msg : 'login.otp_sent'.tr, Colors.green[400]!);
      } else {
        final wait = OtpPolicy.parseWaitSeconds(msg);
        if (wait != null && wait > 0) _startResendCooldown(wait);
        ErrorMessage.SnackMessage(
            msg.isNotEmpty ? msg : 'login.send_fail'.tr, Colors.red[400]!);
      }
    } catch (_) {
      ErrorMessage.SnackMessage('login.connection_error'.tr, Colors.red[400]!);
    } finally {
      isLoading.value = false;
    }
  }

  /// يتحقق من OTP ويحفظ الجلسة دون الانتقال — الـ UI يتولى الأنيميشن ثم [goAfterSuccess].
  Future<bool> verifyOtp() async {
    final phone = _normalizePhone();
    final code = codeController.text.trim();
    if (phone == null) {
      ErrorMessage.SnackMessage('login.phone_invalid'.tr, Colors.red[400]!);
      return false;
    }
    if (!OtpPolicy.isValidCode(code)) {
      ErrorMessage.SnackMessage(
          'أدخل كود التحقق المكون من ${OtpPolicy.codeLength} أرقام',
          Colors.red[400]!);
      return false;
    }
    if (isLoading.value) return false;
    isLoading.value = true;
    try {
      final res = await http.post(
        Uri.https(AppLink.apiUrl, AppLink.verifyOtpLogin(phone, code)),
      );
      final result = json.decode(res.body);
      final msg = result['msg']?.toString() ?? '';
      if (result['success'] != true) {
        ErrorMessage.SnackMessage(
            msg.isNotEmpty ? msg : 'login.otp_wrong'.tr, Colors.red[400]!);
        if (OtpPolicy.isExpiredOrExhausted(msg)) {
          codeController.clear();
        }
        return false;
      }
      final raw = result['data'];
      final data = raw is Map<String, dynamic>
          ? raw
          : Map<String, dynamic>.from(raw as Map);
      final userModel =
          SessionStorage.fromOtpPayload(data, phoneFallback: phone);
      if (userModel.userId <= 0) {
        ErrorMessage.SnackMessage(
            'تعذر قراءة بيانات الحساب من الخادم', Colors.red[400]!);
        return false;
      }
      await SessionStorage.persistUser(box, userModel);
      OneSignal.login(userModel.userId.toString());
      if (Get.isRegistered<ProfileuserController>()) {
        await Get.find<ProfileuserController>().applySession(userModel);
      }
      return true;
    } catch (_) {
      ErrorMessage.SnackMessage('login.verify_error'.tr, Colors.red[400]!);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void goAfterSuccess() {
    Get.offAll(
      LocationStorage.coverageVerified
          ? const MainApp()
          : const CoverageGate(),
      duration: const Duration(milliseconds: 500),
      transition: Transition.fade,
    );
    ErrorMessage.SnackMessage('login.success'.tr, Colors.green[400]!);
  }

  void resetToPhoneStep() {
    codeSent.value = false;
    codeController.clear();
    resendSeconds.value = 0;
    _resendTimer?.cancel();
  }
}
