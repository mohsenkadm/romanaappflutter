import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class OsrmRouteResult {
  const OsrmRouteResult({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
  });

  final List<LatLng> points;
  final double distanceKm;
  final double durationMinutes;

  bool get isEmpty => points.isEmpty;
}

/// Fetches driving route geometry from the public OSRM demo server.
class OsrmRoutingService {
  static const _servers = [
    'https://router.project-osrm.org/route/v1/driving',
    'https://routing.openstreetmap.de/routed-car/route/v1/driving',
  ];

  /// Returns a street-following route from [from] to [to].
  static Future<OsrmRouteResult> fetchRoute(LatLng from, LatLng to) async {
    for (final base in _servers) {
      final result = await _fetchFromServer(base, from, to);
      if (!result.isEmpty) return result;
    }
    return const OsrmRouteResult(
      points: [],
      distanceKm: 0,
      durationMinutes: 0,
    );
  }

  /// Returns route points from [from] to [to], or empty if routing fails.
  static Future<List<LatLng>> route(LatLng from, LatLng to) async {
    final result = await fetchRoute(from, to);
    return result.points;
  }

  static Future<OsrmRouteResult> _fetchFromServer(
    String base,
    LatLng from,
    LatLng to,
  ) async {
    try {
      final url =
          '$base/${from.longitude},${from.latitude};${to.longitude},${to.latitude}'
          '?overview=full&geometries=geojson&steps=false';
      final res = await http
          .get(
            Uri.parse(url),
            headers: const {'User-Agent': 'RomanaAppFlutter/1.0'},
          )
          .timeout(const Duration(seconds: 15));
      if (res.statusCode != 200) {
        return const OsrmRouteResult(
          points: [],
          distanceKm: 0,
          durationMinutes: 0,
        );
      }

      final body = json.decode(res.body);
      if (body is! Map || body['code'] != 'Ok') {
        return const OsrmRouteResult(
          points: [],
          distanceKm: 0,
          durationMinutes: 0,
        );
      }

      final routes = body['routes'];
      if (routes is! List || routes.isEmpty) {
        return const OsrmRouteResult(
          points: [],
          distanceKm: 0,
          durationMinutes: 0,
        );
      }

      final route = routes[0];
      if (route is! Map) {
        return const OsrmRouteResult(
          points: [],
          distanceKm: 0,
          durationMinutes: 0,
        );
      }

      final geometry = route['geometry'];
      if (geometry is! Map) {
        return const OsrmRouteResult(
          points: [],
          distanceKm: 0,
          durationMinutes: 0,
        );
      }

      final coords = geometry['coordinates'];
      if (coords is! List) {
        return const OsrmRouteResult(
          points: [],
          distanceKm: 0,
          durationMinutes: 0,
        );
      }

      final points = coords
          .whereType<List>()
          .map((c) {
            if (c.length < 2) return null;
            final lng = (c[0] as num).toDouble();
            final lat = (c[1] as num).toDouble();
            return LatLng(lat, lng);
          })
          .whereType<LatLng>()
          .toList();

      final distanceM = (route['distance'] as num?)?.toDouble() ?? 0;
      final durationS = (route['duration'] as num?)?.toDouble() ?? 0;

      return OsrmRouteResult(
        points: points,
        distanceKm: distanceM / 1000,
        durationMinutes: durationS / 60,
      );
    } catch (_) {
      return const OsrmRouteResult(
        points: [],
        distanceKm: 0,
        durationMinutes: 0,
      );
    }
  }

  /// Straight-line distance in km (fallback when OSRM unavailable).
  static double distanceKm(LatLng a, LatLng b) {
    const d = Distance();
    return d.as(LengthUnit.Kilometer, a, b);
  }
}
