import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';

/// Validates and resolves GPS coordinates before order submission.
///
/// On some OEM Androids (Huawei / Xiaomi / Oppo) and after a fresh install,
/// a single high-accuracy fused-location call hangs or fails even when the
/// user already enabled location. We try a short timeout, a native
/// LocationManager fallback, last-known, then the already-verified pin.
class LocationGuard {
  LocationGuard._();

  static const _gpsTimeout = Duration(seconds: 8);

  static bool isValid(double lat, double lng) =>
      lat.abs() > 0.0001 && lng.abs() > 0.0001;

  static bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool _canUseGps(LocationPermission p) =>
      p == LocationPermission.always ||
      p == LocationPermission.whileInUse ||
      p == LocationPermission.unableToDetermine;

  static Future<bool> ensurePermission({bool showSnackbar = true}) async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (showSnackbar) _snack('يجب تشغيل خدمة الموقع');
        return false;
      }
    } catch (_) {
      // Some OEM ROMs lie about the service flag; keep going and try GPS.
    }

    LocationPermission p;
    try {
      p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) {
        p = await Geolocator.requestPermission();
      }
    } catch (_) {
      if (showSnackbar) _snack('تعذر التحقق من صلاحية الموقع');
      return false;
    }

    if (p == LocationPermission.denied) {
      if (showSnackbar) _snack('يجب تفعيل صلاحية الوصول للموقع');
      return false;
    }
    if (p == LocationPermission.deniedForever) {
      if (showSnackbar) {
        _snack('صلاحية الموقع مرفوضة — فعّلها من إعدادات الجهاز');
      }
      return false;
    }
    return true;
  }

  /// Returns valid coordinates or null after permission + GPS attempt.
  ///
  /// When [allowSavedFallback] is true (default), a previously confirmed
  /// pin is accepted if live GPS cannot be read. That is the normal case
  /// at order-send time.
  ///
  /// [preferSaved] skips live GPS when a verified pin already exists so
  /// sending an order is never blocked by a slow or broken GPS chip.
  static Future<({double lat, double lng})?> ensureCoordinates({
    bool showSnackbar = true,
    bool allowSavedFallback = true,
    bool preferSaved = false,
  }) async {
    final saved = allowSavedFallback ? LocationStorage.read() : null;
    if (preferSaved && saved != null) return saved;

    LocationPermission permission = LocationPermission.denied;
    try {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
    } catch (_) {}

    if (_canUseGps(permission)) {
      final gps = await _readGps();
      if (gps != null) return gps;
    }

    if (saved != null) return saved;

    if (!showSnackbar) return null;

    if (permission == LocationPermission.deniedForever) {
      _snack('صلاحية الموقع مرفوضة — فعّلها من إعدادات الجهاز');
    } else if (permission == LocationPermission.denied) {
      _snack('يجب تفعيل صلاحية الوصول للموقع');
    } else {
      try {
        if (!await Geolocator.isLocationServiceEnabled()) {
          _snack('يجب تشغيل خدمة الموقع');
          return null;
        }
      } catch (_) {}
      _snack('تعذر تحديد موقعك — حرّك الخريطة أو أعد المحاولة');
    }
    return null;
  }

  static Future<({double lat, double lng})?> _readGps() async {
    try {
      final pos = await _current(LocationAccuracy.medium, forceNative: false);
      if (pos != null && isValid(pos.latitude, pos.longitude)) {
        return (lat: pos.latitude, lng: pos.longitude);
      }
    } catch (_) {}

    try {
      final last = await _lastKnown();
      if (last != null && isValid(last.latitude, last.longitude)) {
        return (lat: last.latitude, lng: last.longitude);
      }
    } catch (_) {}

    if (_isAndroid) {
      try {
        final pos = await _current(LocationAccuracy.medium, forceNative: true);
        if (pos != null && isValid(pos.latitude, pos.longitude)) {
          return (lat: pos.latitude, lng: pos.longitude);
        }
      } catch (_) {}
    }
    return null;
  }

  static Future<Position?> _current(
    LocationAccuracy accuracy, {
    required bool forceNative,
  }) {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: accuracy,
      forceAndroidLocationManager: forceNative,
      timeLimit: _gpsTimeout,
    ).timeout(_gpsTimeout);
  }

  static Future<Position?> _lastKnown() =>
      Geolocator.getLastKnownPosition(forceAndroidLocationManager: _isAndroid);

  static Future<void> openAppSettings() => Geolocator.openAppSettings();

  static void _snack(String msg) {
    Get.rawSnackbar(
      messageText: Text(msg,
          style: const TextStyle(color: Colors.white, fontSize: 14)),
      isDismissible: true,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.orange[700]!,
      margin: EdgeInsets.zero,
      snackStyle: SnackStyle.FLOATING,
      icon: const Icon(Icons.location_on, color: Colors.white, size: 28),
    );
  }
}
