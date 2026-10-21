import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/Constant/token_refresh_service.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';
import 'package:romanaappflutter/core/api/api_client.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/ForceProfileCompletionDialog.dart';

class ConfirmPhoneChangeController extends GetxController {
  ConfirmPhoneChangeController({required this.pendingPhone});

  final String pendingPhone;
  final codeController = TextEditingController();
  final isLoading = false.obs;
  final resendSeconds = 0.obs;
  final box = GetStorage();
  Timer? _resendTimer;

  bool get canResend => resendSeconds.value <= 0 && !isLoading.value;

  @override
  void onInit() {
    super.onInit();
    startResendCooldown();
  }

  @override
  void onClose() {
    _resendTimer?.cancel();
    codeController.dispose();
    super.onClose();
  }

  void startResendCooldown([int? seconds]) {
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

  ApiClient? _clientOrLogout() {
    final token = SessionStorage.token(box);
    if (token.isEmpty) {
      ErrorMessage.SnackMessage(
          'غير مصرح — سجّل الدخول مجدداً', Colors.red[400]!);
      TokenRefreshService.forceLogout();
      return null;
    }
    return ApiClient(token: token);
  }

  Map<String, dynamic>? _asMap(dynamic raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  Future<void> confirm(String code) async {
    final trimmed = code.trim();
    if (!OtpPolicy.isValidCode(trimmed)) {
      ErrorMessage.SnackMessage(
          'أدخل كود التحقق المكون من ${OtpPolicy.codeLength} أرقام',
          Colors.red[400]!);
      return;
    }
    if (isLoading.value) return;

    final client = _clientOrLogout();
    if (client == null) return;

    isLoading.value = true;
    try {
      final res =
          await client.postEmpty(AppLink.confirmPhoneChange(trimmed));
      final msg = (res.msg ?? '').trim();
      if (!res.success) {
        ErrorMessage.SnackMessage(
            msg.isNotEmpty ? msg : 'login.otp_wrong'.tr, Colors.red[400]!);
        if (OtpPolicy.isExpiredOrExhausted(msg)) {
          codeController.clear();
        }
        return;
      }

      final data = _asMap(res.data) ?? {};
      final current = SessionStorage.userFromBox(box);
      final parsed = UsersModel.fromJson(data);
      final merged = UsersModel(
        userId: parsed.userId > 0 ? parsed.userId : current.userId,
        Name: parsed.Name.isNotEmpty ? parsed.Name : current.Name,
        Phone: parsed.Phone.isNotEmpty ? parsed.Phone : pendingPhone,
        Address: parsed.Address ?? current.Address,
        FunctionPoint: parsed.FunctionPoint.isNotEmpty
            ? parsed.FunctionPoint
            : current.FunctionPoint,
        Token: (parsed.Token != null && parsed.Token!.isNotEmpty)
            ? parsed.Token
            : current.Token,
        CityId: parsed.CityId ?? current.CityId,
        needsProfileCompletion: parsed.needsProfileCompletion ??
            current.needsProfileCompletion,
      );

      if (Get.isRegistered<ProfileuserController>()) {
        await Get.find<ProfileuserController>().applySession(merged);
      } else {
        await SessionStorage.persistUser(box, merged);
      }

      ErrorMessage.SnackMessage(
          msg.isNotEmpty ? msg : 'common.success'.tr, Colors.green[400]!);
      if (!isClosed) isLoading.value = false;
      Get.back();
      Get.back();
      ForceProfileCompletion.closeIfComplete();
    } catch (_) {
      ErrorMessage.SnackMessage('login.verify_error'.tr, Colors.red[400]!);
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }

  Future<void> resend() async {
    if (!canResend) {
      ErrorMessage.SnackMessage(
          'انتظر ${resendSeconds.value} ثانية قبل اعادة ارسال الكود',
          Colors.orange[700]!);
      return;
    }
    if (isLoading.value) return;

    final client = _clientOrLogout();
    if (client == null) return;

    isLoading.value = true;
    try {
      final res = await client.postEmpty(AppLink.resendPhoneChangeOtp);
      final msg = (res.msg ?? '').trim();
      if (res.success) {
        codeController.clear();
        startResendCooldown();
        ErrorMessage.SnackMessage(
            msg.isNotEmpty ? msg : 'login.otp_sent'.tr, Colors.green[400]!);
        return;
      }
      final wait = OtpPolicy.parseWaitSeconds(msg);
      if (wait != null && wait > 0) startResendCooldown(wait);
      ErrorMessage.SnackMessage(
          msg.isNotEmpty ? msg : 'login.send_fail'.tr, Colors.red[400]!);
    } catch (_) {
      ErrorMessage.SnackMessage('login.connection_error'.tr, Colors.red[400]!);
    } finally {
      if (!isClosed) isLoading.value = false;
    }
  }
}
