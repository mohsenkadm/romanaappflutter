import 'package:romanaappflutter/Model/DriverModel.dart';
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';

class OrderFullDetailsResult {
  final OrdersModel? order;
  final List<OrderDetailModel> details;
  final DriverModel? driver;
  final int? statusCode;

  OrderFullDetailsResult({
    this.order,
    this.details = const [],
    this.driver,
    this.statusCode,
  });
}

/// يدعم الشكل الجديد { order, details, driver, statusCode } والأشكال القديمة.
class OrderFullDetailsParser {
  static OrderFullDetailsResult? parse(dynamic data) {
    if (data == null) return null;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('order') || data.containsKey('details')) {
        final orderMap = data['order'] as Map<String, dynamic>?;
        final detailsList = data['details'] as List? ?? [];
        final driverMap = data['driver'] as Map<String, dynamic>?;
        final details = detailsList
            .map((e) => OrderDetailModel.fromJson(e as Map<String, dynamic>))
            .toList();
        OrdersModel? order;
        if (orderMap != null) {
          order = OrdersModel.fromJson(orderMap);
          order.orderDetails = details;
        }
        return OrderFullDetailsResult(
          order: order,
          details: details,
          driver: driverMap != null ? DriverModel.fromJson(driverMap) : null,
          statusCode: _readInt(data['statusCode'] ?? data['StatusCode']) ??
              order?.statusCode,
        );
      }
      if (data.containsKey('orderDetailId') ||
          data.containsKey('OrderDetailId')) {
        return null;
      }
      final order = OrdersModel.fromJson(data);
      if (order.orderDetails != null) {
        return OrderFullDetailsResult(
          order: order,
          details: order.orderDetails!,
        );
      }
    }

    if (data is List && data.isNotEmpty) {
      final first = data[0] as Map<String, dynamic>;
      final isFlat = first.containsKey('orderDetailId') ||
          first.containsKey('OrderDetailId');
      if (isFlat) {
        final details = data
            .map((e) =>
                OrderDetailModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final order = _orderFromFlatRow(first);
        order.orderDetails = details;
        return OrderFullDetailsResult(order: order, details: details);
      }
      final order = OrdersModel.fromJson(first);
      return OrderFullDetailsResult(
        order: order,
        details: order.orderDetails ?? [],
      );
    }
    return null;
  }

  static OrdersModel _orderFromFlatRow(Map<String, dynamic> first) {
    dynamic f(String c, String p) => first[c] ?? first[p];
    return OrdersModel(
      orderId: f('orderId', 'OrderId') as int?,
      orderNo: f('orderNo', 'OrderNo') as int?,
      orderDate: DateTime.tryParse(f('orderDate', 'OrderDate')?.toString() ?? '') ??
          DateTime.now(),
      restaurantId: (f('restaurantId', 'RestaurantId') ?? 0) as int,
      total: double.tryParse(f('total', 'Total')?.toString() ?? ''),
      totalDiscount:
          double.tryParse(f('totalDiscount', 'TotalDiscount')?.toString() ?? ''),
      netAmount: double.tryParse(f('netAmount', 'NetAmount')?.toString() ?? ''),
      costDelivery:
          double.tryParse(f('costDelivery', 'CostDelivery')?.toString() ?? ''),
      isCancel: f('isCancel', 'IsCancel') as bool?,
      isUserCancel: f('isUserCancel', 'IsUserCancel') as bool?,
      isApporve: f('isApporve', 'IsApporve') as bool?,
      isDone: f('isDone', 'IsDone') as bool?,
      isPreparing: f('isPreparing', 'IsPreparing') as bool?,
      isDriverEnRouteToPickup:
          f('isDriverEnRouteToPickup', 'IsDriverEnRouteToPickup') as bool?,
      isPickedUpFromRestaurant:
          f('isPickedUpFromRestaurant', 'IsPickedUpFromRestaurant') as bool?,
      isOutForDelivery: f('isOutForDelivery', 'IsOutForDelivery') as bool?,
      isDeliveryConfirmed:
          f('isDeliveryConfirmed', 'IsDeliveryConfirmed') as bool?,
      restaurantName: f('restaurantName', 'RestaurantName') as String?,
      logo: f('logo', 'Logo') as String?,
      SaleManId: f('saleManId', 'SaleManId') as int?,
      SaleManName: f('saleManName', 'SaleManName') as String?,
      IsSaleManApprove: f('isSaleManApprove', 'IsSaleManApprove') as bool?,
      IsSaleManCancel: f('isSaleManCancel', 'IsSaleManCancel') as bool?,
      notes: f('notes', 'Notes') as String?,
      Reason: f('reason', 'Reason')?.toString(),
      phone: f('phone', 'Phone') as String?,
      address: f('address', 'Address') as String?,
      pricingSource: f('pricingSource', 'PricingSource')?.toString(),
      pricingFromZone: f('pricingFromZone', 'PricingFromZone')?.toString(),
      pricingToZone: f('pricingToZone', 'PricingToZone')?.toString(),
      pricingZoneFee: double.tryParse(
          f('pricingZoneFee', 'PricingZoneFee')?.toString() ?? ''),
      pricingEcaFee: double.tryParse(
          f('pricingEcaFee', 'PricingEcaFee')?.toString() ?? ''),
      routeDistanceKm: double.tryParse(
          f('routeDistanceKm', 'RouteDistanceKm')?.toString() ?? ''),
      statusCode: _readInt(f('statusCode', 'StatusCode')),
      isDelivered: f('isDelivered', 'IsDelivered') as bool?,
    );
  }

  static int? _readInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }
}
