import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:url_launcher/url_launcher.dart';

/// رقم دعم تطبيق الزبائن (appType = 1).
class SupportPhoneController extends GetxController {
  static SupportPhoneController get instance =>
      Get.isRegistered<SupportPhoneController>()
          ? Get.find<SupportPhoneController>()
          : Get.put(SupportPhoneController(), permanent: true);

  RxString phone = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetch();
  }

  Future<void> fetch() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final forApp = await _getForApp(AppLink.carouselAppType);
      if (forApp.isNotEmpty) {
        phone.value = forApp;
        return;
      }
      final all = await _getAllForApps();
      phone.value = all['user'] ?? '';
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _getForApp(int appType) async {
    final res = await http.get(
      Uri.https(AppLink.apiUrl, AppLink.supportPhoneForApp, {
        'appType': appType.toString(),
      }),
    );
    if (res.statusCode != 200) return '';
    final body = json.decode(res.body);
    if (body is! Map || body['success'] != true) return '';
    return _parsePhone(body['data']);
  }

  Future<Map<String, String>> _getAllForApps() async {
    final res = await http.get(
      Uri.https(AppLink.apiUrl, AppLink.supportPhoneAllForApps),
    );
    if (res.statusCode != 200) return {};
    final body = json.decode(res.body);
    if (body is! Map || body['success'] != true) return {};
    final data = body['data'];
    if (data is! Map) return {};
    return {
      'user': data['user']?.toString().trim() ?? '',
      'restaurant': data['restaurant']?.toString().trim() ?? '',
      'driver': data['driver']?.toString().trim() ?? '',
    };
  }

  String _parsePhone(dynamic data) {
    if (data == null) return '';
    if (data is String) return data.trim();
    if (data is Map) {
      return (data['phone'] ??
              data['Phone'] ??
              data['number'] ??
              data['value'])
          ?.toString()
          .trim() ??
          '';
    }
    return data.toString().trim();
  }

  String get whatsAppDigits {
    var p = phone.value.replaceAll(RegExp(r'[^0-9]'), '');
    if (p.startsWith('0')) p = '964${p.substring(1)}';
    if (!p.startsWith('964') && p.length >= 10) p = '964$p';
    return p;
  }

  Future<void> openCall() async {
    if (phone.value.isEmpty) {
      ErrorMessage.SnackMessage('رقم الدعم غير متوفر حالياً', Colors.orange);
      return;
    }
    final uri = Uri(scheme: 'tel', path: phone.value);
    if (!await launchUrl(uri)) {
      ErrorMessage.SnackMessage('تعذر فتح تطبيق الاتصال', Colors.red);
    }
  }

  Future<void> openWhatsApp({String? message}) async {
    if (phone.value.isEmpty) {
      ErrorMessage.SnackMessage('رقم الدعم غير متوفر حالياً', Colors.orange);
      return;
    }
    final digits = whatsAppDigits;
    if (digits.isEmpty) {
      ErrorMessage.SnackMessage('رقم الدعم غير صالح', Colors.red);
      return;
    }
    final text = message != null ? '?text=${Uri.encodeComponent(message)}' : '';
    final uri = Uri.parse('https://wa.me/$digits$text');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ErrorMessage.SnackMessage('تعذر فتح واتساب', Colors.red);
    }
  }

  void showContactSheet({String? whatsAppMessage}) {
    if (phone.value.isEmpty) {
      fetch().then((_) {
        if (phone.value.isEmpty) {
          ErrorMessage.SnackMessage('رقم الدعم غير متوفر حالياً', Colors.orange);
        } else {
          showContactSheet(whatsAppMessage: whatsAppMessage);
        }
      });
      return;
    }
    Get.bottomSheet(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تواصل مع الدعم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                phone.value,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.phone_rounded, color: Get.theme.primaryColor),
                title: const Text('اتصال هاتفي'),
                onTap: () {
                  Get.back();
                  openCall();
                },
              ),
              ListTile(
                leading: const Icon(Icons.chat_rounded, color: Color(0xFF25D366)),
                title: const Text('واتساب'),
                onTap: () {
                  Get.back();
                  openWhatsApp(message: whatsAppMessage);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
