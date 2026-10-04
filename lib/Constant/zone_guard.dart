import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/views/CoverageGate.dart';

/// يفرض GPS + تغطية الزون قبل استخدام التطبيق.
class ZoneGuard {
  static bool get canEnterApp =>
      LocationStorage.coverageVerified || LocationStorage.requestSubmitted;

  static Future<void> ensureZoneSelected() async {
    if (!SessionStorage.isLoggedIn(GetStorage())) return;
    if (canEnterApp) return;

    await Future.delayed(const Duration(milliseconds: 300));
    Get.offAll(const CoverageGate());
  }
}
