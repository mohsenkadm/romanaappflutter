import 'package:romanaappflutter/Model/CoverageResult.dart';
import 'package:romanaappflutter/core/api/api_client.dart';
import 'package:romanaappflutter/linkapi.dart';

class QuoteResult {
  final num total;
  final String? pricingSource;
  final String? fromZone;
  final String? toZone;
  final num zoneFee;
  final num routeDistanceKm;
  final num lzaKm;
  final num ecaKm;
  final num ecaPricePerKm;
  final num ecaFee;
  final bool nearRestaurantApplied;

  QuoteResult({
    required this.total,
    this.pricingSource,
    this.fromZone,
    this.toZone,
    this.zoneFee = 0,
    this.routeDistanceKm = 0,
    this.lzaKm = 0,
    this.ecaKm = 0,
    this.ecaPricePerKm = 0,
    this.ecaFee = 0,
    this.nearRestaurantApplied = false,
  });

  factory QuoteResult.fromJson(Map<String, dynamic> j) => QuoteResult(
        total: j['total'] ?? 0,
        pricingSource: j['pricingSource']?.toString(),
        fromZone: j['fromZone']?.toString(),
        toZone: j['toZone']?.toString(),
        zoneFee: j['zoneFee'] ?? 0,
        routeDistanceKm: j['routeDistanceKm'] ?? 0,
        lzaKm: j['lzaKm'] ?? 0,
        ecaKm: j['ecaKm'] ?? 0,
        ecaPricePerKm: j['ecaPricePerKm'] ?? 0,
        ecaFee: j['ecaFee'] ?? 0,
        nearRestaurantApplied: j['nearRestaurantApplied'] == true,
      );

  bool get isZoneEca =>
      pricingSource == 'zone_eca' || pricingSource == 'zone';
}

Future<QuoteResult> fetchDeliveryQuote(
  ApiClient api, {
  required int restaurantId,
  required int cityId,
  required double pickupLat,
  required double pickupLng,
  required double dropoffLat,
  required double dropoffLng,
  bool forceZonePricing = true,
}) async {
  final r = await api.postJson(AppLink.pricingQuote, {
    'restaurantId': restaurantId,
    'cityId': cityId,
    'pickupLat': pickupLat,
    'pickupLng': pickupLng,
    'dropoffLat': dropoffLat,
    'dropoffLng': dropoffLng,
    'forceZonePricing': forceZonePricing,
  });
  api.throwIfFailed(r);
  return QuoteResult.fromJson(r.data as Map<String, dynamic>);
}

Future<CoverageResult> checkCoverage(
  ApiClient api, {
  required double lat,
  required double lng,
}) async {
  final r = await api.get(
    AppLink.pricingCoverageCheck,
    query: {'lat': lat.toString(), 'lng': lng.toString()},
  );
  api.throwIfFailed(r);
  final data = r.data;
  if (data is! Map<String, dynamic>) {
    throw Exception('استجابة التغطية غير صالحة');
  }
  return CoverageResult.fromJson(data);
}

Future<ZoneResolveResult?> resolveZone(
  ApiClient api, {
  required double lat,
  required double lng,
}) async {
  final r = await api.get(
    AppLink.pricingZonesResolve,
    query: {'lat': lat.toString(), 'lng': lng.toString()},
  );
  if (!r.success) return null;
  final data = r.data;
  if (data is! Map<String, dynamic>) return null;
  return ZoneResolveResult.fromJson(data);
}

class ZoneResolveResult {
  final bool inCoverage;
  final int? zoneId;
  final String? zoneName;

  ZoneResolveResult({
    required this.inCoverage,
    this.zoneId,
    this.zoneName,
  });

  factory ZoneResolveResult.fromJson(Map<String, dynamic> j) =>
      ZoneResolveResult(
        inCoverage: j['inCoverage'] == true || j['covered'] == true,
        zoneId: j['zoneId'] as int?,
        zoneName: j['zoneName']?.toString(),
      );
}

Future<int> submitCoverageRequest({
  required String name,
  required String phone,
  required String address,
  required double lat,
  required double lng,
}) async {
  final api = ApiClient();
  final r = await api.postJson(AppLink.coverageRequests, {
    'name': name,
    'phone': phone,
    'address': address,
    'lat': lat,
    'lng': lng,
  });
  api.throwIfFailed(r);
  final data = r.data;
  if (data is Map) {
    final id = data['serviceCoverageRequestId'];
    if (id is int) return id;
    return int.tryParse(id?.toString() ?? '') ?? 0;
  }
  return 0;
}
