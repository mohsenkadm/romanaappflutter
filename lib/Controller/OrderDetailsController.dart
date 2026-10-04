import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Service/order_api_http.dart';
import 'package:romanaappflutter/Constant/api_auth.dart';
import 'package:romanaappflutter/Constant/order_full_details_parser.dart';
import 'package:romanaappflutter/Constant/order_status_resolver.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/Model/DriverModel.dart';
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';

class OrderDetailsController extends GetxController {
  RxDouble netAmount = 0.0.obs;
  RxDouble totalprice = 0.0.obs;
  RxDouble discountprice = 0.0.obs;
  RxDouble costDelivery = 0.0.obs;
  var itemscurrent = <OrderDetailModel>[].obs;
  Rx<OrdersModel?> order = Rx<OrdersModel?>(null);
  Rx<DriverModel?> driver = Rx<DriverModel?>(null);
  RxInt statusCode = (-1).obs;
  String OrderId = '0';
  RxBool isloded = true.obs;

  Timer? _pollingTimer;

  @override
  void onInit() async {
    var data = Get.arguments;
    if (data != null) {
      OrderId = data[0].toString();
      await fetchData();
      _startPolling();
    }
    super.onInit();
  }

  @override
  void onClose() {
    _pollingTimer?.cancel();
    super.onClose();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    // Poll every 10 seconds to refresh order status
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isloded.value) fetchData(silent: true);
    });
  }

  Future<void> fetchData({bool silent = false}) async {
    if (!silent) isloded.value = true;
    try {
      final oid = int.tryParse(OrderId) ?? 0;
      final path = oid > 0
          ? AppLink.getOrderFullDetails(oid)
          : AppLink.getOrderById + OrderId;
      final response = await OrderApiHttp.get(
        Uri.https(AppLink.apiUrl, path),
        headers: ApiAuth.headers(),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final parsed = OrderFullDetailsParser.parse(result['data']);
        if (parsed != null) {
          if (parsed.order != null) order.value = parsed.order;
          if (parsed.details.isNotEmpty) itemscurrent.value = parsed.details;
          driver.value = parsed.driver;
          if (parsed.order != null) {
            statusCode.value = OrderStatusResolver.effectiveCode(
              parsed.order,
              parsed.statusCode,
            );
            _sumPrices(parsed.order!);
          }
        } else if (result['data'] != null) {
          final data = result['data'];
          if (data is List) {
            final list = data as List;
            if (list.isEmpty) { isloded.value = false; return; }
            final first = list[0] as Map<String, dynamic>;
            final isFlat = first.containsKey('orderDetailId') ||
                first.containsKey('OrderDetailId');
            if (isFlat) {
              _parseFromFlatList(list, first);
            } else {
              final ord = OrdersModel.fromJson(first);
              order.value = ord;
              if (ord.orderDetails != null) itemscurrent.value = ord.orderDetails!;
              _sumPrices(ord);
            }
          }
        }
      } else {
        if (!silent) ErrorMessage.error;
      }
    } catch (ex) {
      if (!silent) ErrorMessage.error;
    } finally {
      isloded.value = false;
    }
    update();
  }

  // ── Flat-list parser ──────────────────────────────────────────────────────
  // The backend returns a List<OrderDetail> where every row duplicates the
  // parent Order fields. We build an OrdersModel from the first row's header
  // fields and a List<OrderDetailModel> from all rows.
  void _parseFromFlatList(List list, Map<String, dynamic> first) {
    dynamic f(String c, String p) => first[c] ?? first[p];

    final ord = OrdersModel(
      orderId:       f('orderId', 'OrderId') as int?,
      orderNo:       f('orderNo', 'OrderNo') as int?,
      orderDate:     DateTime.tryParse(f('orderDate', 'OrderDate')?.toString() ?? '') ??
                     DateTime.now(),
      restaurantId:  (f('restaurantId', 'RestaurantId') ?? 0) as int,
      total:         double.tryParse(f('total', 'Total')?.toString() ?? ''),
      totalDiscount: double.tryParse(f('totalDiscount', 'TotalDiscount')?.toString() ?? ''),
      netAmount:     double.tryParse(f('netAmount', 'NetAmount')?.toString() ?? ''),
      costDelivery:  double.tryParse(f('costDelivery', 'CostDelivery')?.toString() ?? ''),
      isCancel:      f('isCancel', 'IsCancel') as bool?,
      isApporve:     f('isApporve', 'IsApporve') as bool?,
      isDone:        f('isDone', 'IsDone') as bool?,
      restaurantName:f('restaurantName', 'RestaurantName') as String?,
      logo:          f('logo', 'Logo') as String?,
      SaleManId:     f('saleManId', 'SaleManId') as int?,
      SaleManName:   f('saleManName', 'SaleManName') as String?,
      IsSaleManApprove: f('isSaleManApprove', 'IsSaleManApprove') as bool?,
      IsSaleManCancel:  f('isSaleManCancel', 'IsSaleManCancel') as bool?,
      notes:         f('notes', 'Notes') as String?,
      Reason:        f('reason', 'Reason')?.toString(),
      isPreparing: f('isPreparing', 'IsPreparing') as bool?,
      isDriverEnRouteToPickup:
          f('isDriverEnRouteToPickup', 'IsDriverEnRouteToPickup') as bool?,
      isPickedUpFromRestaurant:
          f('isPickedUpFromRestaurant', 'IsPickedUpFromRestaurant') as bool?,
      isOutForDelivery: f('isOutForDelivery', 'IsOutForDelivery') as bool?,
      isDeliveryConfirmed:
          f('isDeliveryConfirmed', 'IsDeliveryConfirmed') as bool?,
      isDelivered: f('isDelivered', 'IsDelivered') as bool?,
      statusCode: int.tryParse(f('statusCode', 'StatusCode')?.toString() ?? ''),
    );

    final details = list
        .map((d) => _safeParseDetail(d as Map<String, dynamic>))
        .whereType<OrderDetailModel>()
        .toList();

    ord.orderDetails = details;
    order.value = ord;
    itemscurrent.value = details;
    statusCode.value = OrderStatusResolver.effectiveCode(ord, ord.statusCode);
    _sumPrices(ord);
  }

  OrderDetailModel? _safeParseDetail(Map<String, dynamic> d) {
    try {
      dynamic f(String c, String p) => d[c] ?? d[p];
      int    ii(String c, String p) => int.tryParse(f(c, p)?.toString() ?? '0') ?? 0;
      double? dd(String c, String p) => double.tryParse(f(c, p)?.toString() ?? '');
      bool?  bb(String c, String p) => f(c, p) as bool?;
      String ss(String c, String p) => f(c, p)?.toString() ?? '';

      return OrderDetailModel(
        orderDetailId:       f('orderDetailId', 'OrderDetailId') as int?,
        orderId:             f('orderId', 'OrderId') as int?,
        productsId:          ii('productsId', 'ProductsId'),
        price:               dd('price', 'Price'),
        count:               ii('count', 'Count').clamp(1, 999),
        productsName:        ss('productsName', 'ProductsName'),
        productsDetails:     ss('productsDetails', 'ProductsDetails'),
        productsImage:       ss('productsImage', 'ProductsImage'),
        subCategoriesName:   ss('subCategoriesName', 'SubCategoriesName'),
        orderNo:             f('orderNo', 'OrderNo') as int?,
        orderDate:           DateTime.tryParse(f('orderDate', 'OrderDate')?.toString() ?? ''),
        restaurantId:        ii('restaurantId', 'RestaurantId'),
        userId:              f('userId', 'UserId') as int?,
        total:               dd('total', 'Total'),
        totalDiscount:       dd('totalDiscount', 'TotalDiscount'),
        netAmount:           dd('netAmount', 'NetAmount'),
        isCancel:            bb('isCancel', 'IsCancel'),
        isApporve:           bb('isApporve', 'IsApporve'),
        isDone:              bb('isDone', 'IsDone'),
        notes2:              f('notes2', 'Notes2') as String?,
        selectedSizeId:      f('selectedSizeId', 'SelectedSizeId') as int?,
        selectedSizeName:    f('selectedSizeName', 'SelectedSizeName') as String?,
        selectedSizePrice:   dd('selectedSizePrice', 'SelectedSizePrice'),
        selectedIngredients: f('selectedIngredients', 'SelectedIngredients') as String?,
      );
    } catch (_) {
      return null;
    }
  }

  void _sumPrices(OrdersModel ord) {
    totalprice.value = ord.total ?? 0;
    discountprice.value = ord.totalDiscount ?? 0;
    netAmount.value = ord.netAmount ?? 0;
    costDelivery.value = ord.costDelivery ?? 0;
  }

  int getStatusStep(OrdersModel? ord) => OrderStatusResolver.stepIndex(
        ord,
        statusCode.value >= 0 ? statusCode.value : null,
      );

  bool get isTrackable =>
      statusCode.value >= 3 && statusCode.value < 8;

  /// الزبون يلغي فقط قبل موافقة المطعم.
  static bool canCustomerCancel(OrdersModel? ord) {
    if (ord == null) return false;
    if (ord.isCancel == true) return false;
    if (ord.isDone == true) return false;
    if (ord.isApporve == true) return false;
    final code = OrderStatusResolver.effectiveCode(ord, ord.statusCode);
    return code <= 0;
  }

  bool get canCancelAsCustomer =>
      canCustomerCancel(order.value) &&
      (statusCode.value < 0 || statusCode.value <= 0);

  final RxBool isCancelling = false.obs;

  Future<bool> cancelOrderByCustomer() async {
    final ord = order.value;
    if (!canCustomerCancel(ord) || isCancelling.value) return false;
    final oid = int.tryParse(OrderId) ?? ord?.orderId ?? 0;
    if (oid <= 0) return false;

    isCancelling.value = true;
    try {
      final response = await OrderApiHttp.delete(
        Uri.https(AppLink.apiUrl, AppLink.setIsCancel(oid)),
        headers: ApiAuth.headers(),
      );
      if (response.statusCode != 200) {
        ErrorMessage.SnackMessage(
            'error.cancel_order'.tr, Colors.red[400]!);
        return false;
      }
      final data = json.decode(response.body);
      if (data is Map && data['success'] == false) {
        ErrorMessage.SnackMessage(
            data['msg']?.toString() ?? 'error.cancel_order_fail'.tr, Colors.red[400]!);
        return false;
      }
      if (order.value != null) {
        order.value!.isCancel = true;
        order.refresh();
      }
      statusCode.value = 9;
      if (Get.isRegistered<MyOrderController>()) {
        await MyOrderController.instance.fetchData();
      }
      return true;
    } catch (_) {
      ErrorMessage.SnackMessage(
          'error.cancel_order'.tr, Colors.red[400]!);
      return false;
    } finally {
      isCancelling.value = false;
    }
  }
}
