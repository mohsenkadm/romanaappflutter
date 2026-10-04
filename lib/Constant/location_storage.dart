import 'package:get_storage/get_storage.dart';

/// إحداثيات GPS المحفوظة بعد اجتياز بوابة التغطية.
class LocationStorage {
  LocationStorage._();

  static const _latKey = 'userLat';
  static const _lngKey = 'userLng';
  static const _coverageOkKey = 'coverageOk';
  static const _zoneIdKey = 'userZoneId';
  static const _zoneNameKey = 'userZoneName';
  static const _requestSubmittedKey = 'coverageRequestSubmitted';

  static bool _isTrue(dynamic v) {
    if (v == true || v == 1) return true;
    return v?.toString().toLowerCase() == 'true';
  }

  static bool get requestSubmitted =>
      _isTrue(GetStorage().read(_requestSubmittedKey));

  static Future<void> markRequestSubmitted() async {
    await GetStorage().write(_requestSubmittedKey, true);
  }

  static bool get hasSavedCoordinates {
    final box = GetStorage();
    final lat = double.tryParse(box.read(_latKey)?.toString() ?? '') ?? 0;
    final lng = double.tryParse(box.read(_lngKey)?.toString() ?? '') ?? 0;
    return lat.abs() > 0.0001 && lng.abs() > 0.0001;
  }

  static bool get coverageVerified =>
      _isTrue(GetStorage().read(_coverageOkKey)) && hasSavedCoordinates;

  static ({double lat, double lng})? read() {
    final box = GetStorage();
    final lat = double.tryParse(box.read(_latKey)?.toString() ?? '');
    final lng = double.tryParse(box.read(_lngKey)?.toString() ?? '');
    if (lat == null || lng == null) return null;
    if (lat.abs() <= 0.0001 && lng.abs() <= 0.0001) return null;
    return (lat: lat, lng: lng);
  }

  static Future<void> saveCoordinatesOnly(double lat, double lng) async {
    final box = GetStorage();
    await box.write(_latKey, lat);
    await box.write(_lngKey, lng);
  }

  static Future<void> save(
    double lat,
    double lng, {
    int? zoneId,
    String? zoneName,
  }) async {
    final box = GetStorage();
    await box.write(_latKey, lat);
    await box.write(_lngKey, lng);
    await box.write(_coverageOkKey, true);
    if (zoneId != null && zoneId > 0) {
      await box.write(_zoneIdKey, zoneId);
    }
    if (zoneName != null && zoneName.isNotEmpty) {
      await box.write(_zoneNameKey, zoneName);
    }
  }

  static int? get zoneId {
    final v = GetStorage().read(_zoneIdKey);
    if (v == null) return null;
    return int.tryParse(v.toString());
  }

  static String? get zoneName =>
      GetStorage().read(_zoneNameKey)?.toString();

  static Future<void> clearCoverage() async {
    final box = GetStorage();
    await box.remove(_coverageOkKey);
    await box.remove(_zoneIdKey);
    await box.remove(_zoneNameKey);
    await box.remove(_requestSubmittedKey);
  }

  static Future<void> clear() async {
    final box = GetStorage();
    await box.remove(_latKey);
    await box.remove(_lngKey);
    await box.remove(_coverageOkKey);
    await box.remove(_zoneIdKey);
    await box.remove(_zoneNameKey);
    await box.remove(_requestSubmittedKey);
  }
}
