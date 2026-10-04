import 'package:get/get.dart';

import '../views/DriverTrackingScreen.dart';

/// Opens driver live map for mid/late delivery; customer can still tap track
/// button earlier (driver assigned) from order details.
class DriverTrackingNavigation {
  DriverTrackingNavigation._();

  static bool shouldOpenTracking({String? statusKey, int? statusCode}) {
    // Auto-open map only when package is moving toward customer.
    if (statusKey == 'picked_up' || statusKey == 'out_for_delivery') {
      return true;
    }
    final code = statusCode ?? -1;
    return code >= 5 && code < 8;
  }

  /// Show track CTA on order details once a driver is assigned.
  static bool canShowTrackButton({String? statusKey, int? statusCode}) {
    if (statusKey == 'driver_assigned' ||
        statusKey == 'driver_en_route' ||
        statusKey == 'picked_up' ||
        statusKey == 'out_for_delivery') {
      return true;
    }
    final code = statusCode ?? -1;
    return code >= 3 && code < 8;
  }

  static void openIfTrackable(
    int orderId, {
    String? statusKey,
    int? statusCode,
    bool replace = false,
  }) {
    if (orderId <= 0) return;
    if (!shouldOpenTracking(statusKey: statusKey, statusCode: statusCode)) {
      return;
    }
    if (Get.isDialogOpen == true) return;

    final route = Get.currentRoute;
    if (route.contains('DriverTrackingScreen')) return;

    final page = DriverTrackingScreen(orderId: orderId);
    if (replace) {
      Get.off(() => page);
    } else {
      Get.to(
        () => page,
        duration: const Duration(milliseconds: 400),
        transition: Transition.rightToLeftWithFade,
      );
    }
  }
}
