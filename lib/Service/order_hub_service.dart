import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Constant/PushNotificationHandler.dart';
import 'package:romanaappflutter/Constant/driver_tracking_navigation.dart';
import 'package:romanaappflutter/Constant/order_refresh_coordinator.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Controller/DriverTrackingController.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/OrderDetailsController.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/PostOrderRatingView.dart';
import 'package:signalr_netcore/signalr_client.dart';

class OrderHubService extends GetxService {
  HubConnection? _connection;
  final _box = GetStorage();

  Future<void> connect() async {
    final token = _box.read('token')?.toString();
    final userId = _box.read('UserId') ?? _box.read('userId');
    if (token == null || token.isEmpty || userId == null) return;
    await disconnect();
    final url =
        'https://${AppLink.apiUrl}/hubs/orders?access_token=$token';
    _connection = HubConnectionBuilder().withUrl(url).build();
    _connection!.on('OrderUpdated', _onOrderUpdated);
    _connection!.on('DriverLocationUpdated', _onDriverLocationUpdated);
    await _connection!.start();
    await _connection!.invoke('JoinUser', args: [userId]);
  }

  void _onOrderUpdated(List<Object?>? args) async {
    Map<String, dynamic>? payload;
    if (args != null && args.isNotEmpty && args[0] is Map) {
      payload = Map<String, dynamic>.from(args[0] as Map);
    }

    final orderId = int.tryParse(payload?['orderId']?.toString() ?? '');
    await OrderRefreshCoordinator.refreshForOrder(orderId);

    final title = payload?['title']?.toString() ?? 'تحديث الطلب';
    final message = payload?['message']?.toString() ?? '';
    final statusKey = payload?['statusKey']?.toString() ?? '';
    final statusCode = OrderStatusHelper.codeFromPayload(payload) ??
        OrderStatusHelper.statusKeyToCode[statusKey];

    if (Get.isRegistered<AppBadgeController>()) {
      Get.find<AppBadgeController>().bumpNotification();
    }

    PushNotificationHandler.showInAppBanner(
      title: title,
      body: message.isNotEmpty
          ? message
          : (statusCode != null
              ? OrderStatusHelper.labelFor(statusCode)
              : _statusMessage(statusKey)),
      data: {
        'type': 'order_status',
        'orderId': orderId,
        'statusKey': statusKey,
        if (statusCode != null) 'statusCode': statusCode,
      },
    );

    if (orderId != null &&
        DriverTrackingNavigation.shouldOpenTracking(
          statusKey: statusKey,
          statusCode: statusCode,
        )) {
      DriverTrackingNavigation.openIfTrackable(
        orderId,
        statusKey: statusKey,
        statusCode: statusCode,
      );
    }

    if (statusKey == 'confirmed' ||
        statusKey == 'done' ||
        statusKey == 'delivery_confirmed') {
      _promptRating(orderId);
    }
  }

  void _onDriverLocationUpdated(List<Object?>? args) {
    if (args == null || args.isEmpty || args[0] is! Map) return;
    final payload = Map<String, dynamic>.from(args[0] as Map);
    final lat = double.tryParse(payload['lat']?.toString() ?? '');
    final lng = double.tryParse(payload['lng']?.toString() ?? '');
    if (lat == null || lng == null) return;

    if (Get.isRegistered<DriverTrackingController>()) {
      Get.find<DriverTrackingController>().applyDriverLocation(lat, lng);
    }
  }

  String _statusMessage(String key) {
    switch (key) {
      case 'preparing':
        return 'طلبك قيد التحضير';
      case 'driver_assigned':
        return 'تم تعيين سائق لطلبك';
      case 'driver_en_route':
        return 'السائق في الطريق لاستلام طلبك';
      case 'picked_up':
        return 'تم استلام طلبكم من المطعم';
      case 'out_for_delivery':
        return 'السائق في الطريق إليك';
      case 'confirmed':
        return 'تم تأكيد استلام الطلب';
      case 'approved':
        return 'تمت موافقة المطعم على طلبك';
      default:
        return 'تم تحديث حالة طلبك';
    }
  }

  void _promptRating(int? orderId) {
    if (orderId == null || orderId <= 0) return;
    final key = 'rating_prompted_$orderId';
    if (_box.read(key) == true) return;
    _box.write(key, true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context == null) return;
      Get.to(
        () => PostOrderRatingView(orderId: orderId),
        duration: const Duration(milliseconds: 400),
        transition: Transition.downToUp,
      );
    });
  }

  Future<void> disconnect() async {
    try {
      await _connection?.stop();
    } catch (_) {}
    _connection = null;
  }

  @override
  void onClose() {
    disconnect();
    super.onClose();
  }
}
