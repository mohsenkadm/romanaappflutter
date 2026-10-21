import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/Constant/token_refresh_service.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';
import 'package:romanaappflutter/core/api/api_client.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/ConfirmPhoneChangeView.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final functionPointController = TextEditingController();
  final isSaving = false.obs;
  final box = GetStorage();

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    functionPointController.dispose();
    super.onClose();
  }

  void loadFromSession() {
    final user = SessionStorage.userFromBox(box);
    nameController.text = user.Name;
    phoneController.text = user.Phone;
    addressController.text = user.Address?.toString() ?? '';
    functionPointController.text = user.FunctionPoint;
  }

  String? validateName(String? value) {
    final name = (value ?? '').trim();
    if (name.isEmpty) return 'profile.name_required'.tr;
    final phone = phoneController.text.trim();
    if (name == phone || RegExp(r'^\d+$').hasMatch(name)) {
      return 'profile.name_not_phone'.tr;
    }
    return null;
  }

  String? validateAddress(String? value) {
    if ((value ?? '').trim().isEmpty) return 'profile.address_required'.tr;
    return null;
  }

  String? validateFunctionPoint(String? value) {
    if ((value ?? '').trim().isEmpty) {
      return 'profile.function_point_required'.tr;
    }
    return null;
  }

  String? validatePhone(String? value) {
    final p = (value ?? '').trim();
    if (!RegExp(r'^\d{11}$').hasMatch(p)) {
      return 'profile.phone_invalid'.tr;
    }
    return null;
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

  Future<void> _applyUser(UsersModel user) async {
    if (Get.isRegistered<ProfileuserController>()) {
      await Get.find<ProfileuserController>().applySession(user);
    } else {
      await SessionStorage.persistUser(box, user);
    }
  }

  Future<void> save({bool popOnSuccess = true, bool requireComplete = false}) async {
    if (isSaving.value) return;
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    if (validateName(name) != null) {
      ErrorMessage.SnackMessage(validateName(name)!, Colors.red[400]!);
      return;
    }
    if (validatePhone(phone) != null) {
      ErrorMessage.SnackMessage(validatePhone(phone)!, Colors.red[400]!);
      return;
    }
    if (requireComplete) {
      if (validateAddress(addressController.text) != null) {
        ErrorMessage.SnackMessage(
            validateAddress(addressController.text)!, Colors.red[400]!);
        return;
      }
      if (validateFunctionPoint(functionPointController.text) != null) {
        ErrorMessage.SnackMessage(
            validateFunctionPoint(functionPointController.text)!,
            Colors.red[400]!);
        return;
      }
    }

    final client = _clientOrLogout();
    if (client == null) return;

    isSaving.value = true;
    try {
      final res = await client.postMultipart(AppLink.updateProfile, {
        'Name': name,
        'Phone': phone,
        'Address': addressController.text.trim(),
        'FunctionPoint': functionPointController.text.trim(),
      });
      final msg = (res.msg ?? '').trim();
      if (!res.success) {
        ErrorMessage.SnackMessage(
            msg.isNotEmpty ? msg : 'error.generic'.tr, Colors.red[400]!);
        return;
      }

      final data = _asMap(res.data);
      if (data == null) {
        ErrorMessage.SnackMessage(
            msg.isNotEmpty ? msg : 'error.generic'.tr, Colors.red[400]!);
        return;
      }

      if (data['requiresPhoneVerification'] == true) {
        final pending = data['pendingPhone']?.toString() ?? '';
        final userMap = _asMap(data['user']);
        if (userMap != null) {
          await _applyUser(UsersModel.fromJson(userMap));
        }
        ErrorMessage.SnackMessage(
            msg.isNotEmpty ? msg : 'profile.otp_sent'.tr, Colors.green[400]!);
        if (pending.isEmpty) return;
        Get.to(
          () => ConfirmPhoneChangeView(pendingPhone: pending),
          duration: const Duration(milliseconds: 400),
          transition: Transition.rightToLeftWithFade,
        );
        return;
      }

      await _applyUser(UsersModel.fromJson(data));
      ErrorMessage.SnackMessage(
          msg.isNotEmpty ? msg : 'common.success'.tr, Colors.green[400]!);
      if (popOnSuccess) Get.back();
    } catch (_) {
      ErrorMessage.SnackMessage('error.fetch'.tr, Colors.red[400]!);
    } finally {
      if (!isClosed) isSaving.value = false;
    }
  }
}
