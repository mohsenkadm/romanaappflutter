import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:romanaappflutter/Constant/api_auth.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Constant/order_full_details_parser.dart';
import 'package:romanaappflutter/Constant/order_status_resolver.dart';
import 'package:romanaappflutter/Model/DriverModel.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:romanaappflutter/Service/order_api_http.dart';
import 'package:romanaappflutter/Service/osrm_routing_service.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:http/http.dart' as http;

class DriverTrackingController extends GetxController {
  DriverTrackingController({required this.orderId});

  final int orderId;

  final RxBool isLoading = true.obs;
  final RxBool isDelivered = false.obs;
  final RxInt statusCode = (-1).obs;
  final RxnDouble driverLat = RxnDouble();
  final RxnDouble driverLng = RxnDouble();
  final RxnDouble customerLat = RxnDouble();
  final RxnDouble customerLng = RxnDouble();
  final RxnDouble restaurantLat = RxnDouble();
  final RxnDouble restaurantLng = RxnDouble();
  final RxList<LatLng> routePoints = <LatLng>[].obs;
  final RxString driverName = ''.obs;
  final RxString driverPhone = ''.obs;
  final RxDouble distanceKm = 0.0.obs;
  final RxDouble etaMinutes = 0.0.obs;
  final RxString statusLabel = ''.obs;
  /// `driver` = السائق → الزبون | `restaurant` = المطعم → الزبون (احتياطي)
  final RxString routeKind = ''.obs;
  final RxBool isRouteLoading = false.obs;

  Timer? _pollTimer;
  DriverModel? _driver;
  LatLng? _lastRouteFrom;
  LatLng? _lastRouteTo;
  bool _routeFetchInFlight = false;

  @override
  void onInit() {
    super.onInit();
    refreshData();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => refreshData());
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  static const _samePointThreshold = 0.00015; // ~15m

  bool _isSamePoint(double lat1, double lng1, double lat2, double lng2) {
    return (lat1 - lat2).abs() < _samePointThreshold &&
        (lng1 - lng2).abs() < _samePointThreshold;
  }

  bool _isValidCoord(double? lat, double? lng) {
    if (lat == null || lng == null) return false;
    return lat.abs() > 0.0001 || lng.abs() > 0.0001;
  }

  void _setDriverCoords(double lat, double lng) {
    final cLat = customerLat.value;
    final cLng = customerLng.value;
    if (cLat != null &&
        cLng != null &&
        _isSamePoint(lat, lng, cLat, cLng)) {
      return;
    }
    driverLat.value = lat;
    driverLng.value = lng;
  }

  /// SignalR hook — update driver marker immediately when backend broadcasts.
  void applyDriverLocation(double lat, double lng) {
    _setDriverCoords(lat, lng);
    _lastRouteFrom = null;
    _lastRouteTo = null;
    _updateRoute();
  }

  Future<void> refreshData() async {
    try {
      final response = await OrderApiHttp.get(
        Uri.https(AppLink.apiUrl, AppLink.getOrderFullDetails(orderId)),
        headers: ApiAuth.headers(),
      );
      if (response.statusCode != 200) return;

      final result = json.decode(response.body);
      final parsed = OrderFullDetailsParser.parse(result['data']);
      if (parsed == null) return;

      _driver = parsed.driver;
      statusCode.value = OrderStatusResolver.effectiveCode(
        parsed.order,
        parsed.statusCode,
      );
      if (_driver != null) {
        driverName.value = _driver!.name ?? '';
        driverPhone.value = _driver!.phone ?? '';
      }

      await _resolveCustomerCoordinates(parsed.order);
      await _resolveRestaurantCoordinates(parsed.order);

      // Live GPS first; static SaleMan coords often duplicate the customer address.
      await _tryDedicatedDriverLocationEndpoint();
      if (!_isValidCoord(driverLat.value, driverLng.value) && _driver != null) {
        final dLat = double.tryParse(_driver!.lat ?? '');
        final dLng = double.tryParse(_driver!.long ?? '');
        if (dLat != null && dLng != null) {
          _setDriverCoords(dLat, dLng);
        }
      }

      isDelivered.value = statusCode.value >= 7;
      await _updateRoute();
    } catch (_) {
      // Best-effort polling.
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _tryDedicatedDriverLocationEndpoint() async {
    try {
      final res = await OrderApiHttp.get(
        Uri.https(AppLink.apiUrl, AppLink.getDriverLocation(orderId)),
        headers: ApiAuth.headers(),
      );
      if (res.statusCode != 200) return;
      final body = json.decode(res.body);
      final data = body is Map ? (body['data'] ?? body) : null;
      if (data is! Map) return;
      final lat = double.tryParse(data['lat']?.toString() ?? '');
      final lng = double.tryParse(data['lng']?.toString() ?? '');
      if (lat != null && lng != null) {
        _setDriverCoords(lat, lng);
      }
    } catch (_) {}
  }

  Future<void> _resolveCustomerCoordinates(OrdersModel? order) async {
    final oLat = double.tryParse(order?.lat ?? '');
    final oLng = double.tryParse(order?.long ?? '');
    if (oLat != null && oLng != null && (oLat.abs() > 0.0001 || oLng.abs() > 0.0001)) {
      customerLat.value = oLat;
      customerLng.value = oLng;
      return;
    }
    if (Get.isRegistered<determinePositionLocation>()) {
      final loc = Get.find<determinePositionLocation>();
      if (loc.latitude.value.abs() > 0.0001 || loc.longitude.value.abs() > 0.0001) {
        customerLat.value = loc.latitude.value;
        customerLng.value = loc.longitude.value;
        return;
      }
      await loc.getCurrentLocation();
      customerLat.value = loc.latitude.value;
      customerLng.value = loc.longitude.value;
    }
  }

  Future<void> _resolveRestaurantCoordinates(OrdersModel? order) async {
    final rid = order?.restaurantId ?? 0;
    if (rid <= 0) return;
    try {
      final response = await http.get(
        Uri.https(
          AppLink.apiUrl,
          AppLink.getRestaurantById,
          {'Id': rid.toString()},
        ),
      );
      if (response.statusCode != 200) return;
      final result = json.decode(response.body);
      if (result is! Map || result['success'] != true) return;
      final data = result['data'];
      if (data is! Map) return;
      final lat = double.tryParse(data['lat']?.toString() ?? '');
      final lng = double.tryParse(
        data['long']?.toString() ?? data['lng']?.toString() ?? '',
      );
      if (lat != null && lng != null) {
        restaurantLat.value = lat;
        restaurantLng.value = lng;
      }
    } catch (_) {}
  }

  ({LatLng from, LatLng to})? _resolveRouteEndpoints() {
    final cLat = customerLat.value;
    final cLng = customerLng.value;
    if (!_isValidCoord(cLat, cLng)) return null;

    final customer = LatLng(cLat!, cLng!);
    final dLat = driverLat.value;
    final dLng = driverLng.value;

    if (_isValidCoord(dLat, dLng) &&
        !_isSamePoint(dLat!, dLng!, cLat, cLng)) {
      routeKind.value = 'driver';
      return (from: LatLng(dLat, dLng), to: customer);
    }

    final rLat = restaurantLat.value;
    final rLng = restaurantLng.value;
    if (_isValidCoord(rLat, rLng) &&
        !_isSamePoint(rLat!, rLng!, cLat, cLng)) {
      routeKind.value = 'restaurant';
      return (from: LatLng(rLat, rLng), to: customer);
    }

    routeKind.value = '';
    return null;
  }

  bool _routeNeedsRefresh(LatLng from, LatLng to) {
    if (_lastRouteFrom == null || _lastRouteTo == null) return true;
    const d = Distance();
    final fromMoved = d.as(
          LengthUnit.Meter,
          _lastRouteFrom!,
          from,
        ) >
        35;
    final toMoved =
        d.as(LengthUnit.Meter, _lastRouteTo!, to) > 35;
    return fromMoved || toMoved;
  }

  Future<void> _updateRoute() async {
    final endpoints = _resolveRouteEndpoints();
    if (endpoints == null) {
      routePoints.clear();
      distanceKm.value = 0;
      etaMinutes.value = 0;
      return;
    }

    final from = endpoints.from;
    final to = endpoints.to;
    if (_isSamePoint(from.latitude, from.longitude, to.latitude, to.longitude)) {
      routePoints.clear();
      distanceKm.value = 0;
      etaMinutes.value = 0;
      return;
    }

    if (!_routeNeedsRefresh(from, to) || _routeFetchInFlight) return;

    _routeFetchInFlight = true;
    isRouteLoading.value = true;
    try {
      final result = await OsrmRoutingService.fetchRoute(from, to);
      _lastRouteFrom = from;
      _lastRouteTo = to;

      if (result.points.length >= 2) {
        routePoints.assignAll(result.points);
        distanceKm.value = result.distanceKm > 0
            ? result.distanceKm
            : OsrmRoutingService.distanceKm(from, to);
        etaMinutes.value = result.durationMinutes;
      } else {
        routePoints.assignAll([from, to]);
        distanceKm.value = OsrmRoutingService.distanceKm(from, to);
        etaMinutes.value = 0;
      }
    } finally {
      _routeFetchInFlight = false;
      isRouteLoading.value = false;
    }
  }

  LatLng? get driverLocation {
    final lat = driverLat.value;
    final lng = driverLng.value;
    if (lat == null || lng == null) return null;
    if (lat.abs() < 0.0001 && lng.abs() < 0.0001) return null;
    return LatLng(lat, lng);
  }

  LatLng? get mapCenter {
    final points = <LatLng>[];
    void add(double? lat, double? lng) {
      if (lat != null && lng != null) points.add(LatLng(lat, lng));
    }

    add(driverLat.value, driverLng.value);
    add(customerLat.value, customerLng.value);
    add(restaurantLat.value, restaurantLng.value);
    if (points.isEmpty) return null;

    var latSum = 0.0;
    var lngSum = 0.0;
    for (final p in points) {
      latSum += p.latitude;
      lngSum += p.longitude;
    }
    return LatLng(latSum / points.length, lngSum / points.length);
  }
}
