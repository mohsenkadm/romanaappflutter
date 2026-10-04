
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/location_guard.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';

class determinePositionLocation extends GetxService {
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    hydrateFromStorage();
  }

  void hydrateFromStorage() {
    final saved = LocationStorage.read();
    if (saved == null) return;
    latitude.value = saved.lat;
    longitude.value = saved.lng;
  }

  void apply(double lat, double lng) {
    latitude.value = lat;
    longitude.value = lng;
  }

  Future getCurrentLocation() async {
    hydrateFromStorage();
    final coords = await LocationGuard.ensureCoordinates(
      showSnackbar: !LocationGuard.isValid(latitude.value, longitude.value),
      allowSavedFallback: true,
      preferSaved: LocationStorage.coverageVerified,
    );
    if (coords == null) return;
    apply(coords.lat, coords.lng);
  }
}
