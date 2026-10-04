import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:get/get.dart';

/// معاملات موقع الزبون لـ GetByUserLocation.
class RestaurantLocationQuery {
  static Map<String, String> build() {
    final saved = LocationStorage.read();
    if (saved != null) {
      return {
        'lat': saved.lat.toString(),
        'lng': saved.lng.toString(),
        'radius_km': '100',
      };
    }
    if (Get.isRegistered<determinePositionLocation>()) {
      final loc = Get.find<determinePositionLocation>();
      if (loc.latitude.value.abs() > 0.0001 || loc.longitude.value.abs() > 0.0001) {
        return {
          'lat': loc.latitude.value.toString(),
          'lng': loc.longitude.value.toString(),
          'radius_km': '15',
        };
      }
    }
    final box = GetStorage();
    return {
      'lat': box.read('userLat')?.toString() ?? '0',
      'lng': box.read('userLng')?.toString() ?? '0',
      'radius_km': '15',
    };
  }
}
