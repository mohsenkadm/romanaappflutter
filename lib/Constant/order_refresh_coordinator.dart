import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/DriverTrackingController.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/OrderDetailsController.dart';

/// Refreshes open order UIs after SignalR / push events.
class OrderRefreshCoordinator {
  OrderRefreshCoordinator._();

  static Future<void> refreshForOrder(int? orderId) async {
    if (Get.isRegistered<MyOrderController>()) {
      await Get.find<MyOrderController>().fetchData();
    }

    if (orderId != null && orderId > 0) {
      if (Get.isRegistered<DriverTrackingController>() &&
          Get.find<DriverTrackingController>().orderId == orderId) {
        await Get.find<DriverTrackingController>().refreshData();
      }
      if (Get.isRegistered<OrderDetailsController>()) {
        final ctrl = Get.find<OrderDetailsController>();
        if (ctrl.OrderId == orderId.toString()) {
          await ctrl.fetchData(silent: true);
        }
      }
    } else if (Get.isRegistered<OrderDetailsController>()) {
      await Get.find<OrderDetailsController>().fetchData(silent: true);
    }
  }
}
