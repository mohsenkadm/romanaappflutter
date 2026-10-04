import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Controller/DriverTrackingController.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverTrackingScreen extends StatefulWidget {
  const DriverTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  final int orderId;

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  final MapController _mapController = MapController();
  static const double _driverFocusZoom = 17;
  bool _highlightDriver = false;
  bool _didFitRoute = false;
  int _lastRoutePointCount = 0;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _maybeFitMapToRoute(DriverTrackingController ctrl) {
    final count = ctrl.routePoints.length;
    if (count < 2 || (_didFitRoute && count == _lastRoutePointCount)) return;
    _lastRoutePointCount = count;
    _didFitRoute = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final points = List<LatLng>.from(ctrl.routePoints);
      _mapController.fitCamera(
        CameraFit.coordinates(
          coordinates: points,
          padding: const EdgeInsets.fromLTRB(48, 96, 48, 220),
        ),
      );
    });
  }

  void _focusOnDriver(DriverTrackingController ctrl) {
    final point = ctrl.driverLocation;
    if (point == null) {
      Get.snackbar(
        'الموقع',
        'موقع السائق غير متوفر بعد — انتظر تحرك السائق',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      return;
    }
    setState(() => _highlightDriver = true);
    _mapController.move(point, _driverFocusZoom);
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(DriverTrackingController(orderId: widget.orderId));
    final primary = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: primary),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'تتبع السائق',
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
      ),
      body: Obx(() {
        if (ctrl.isLoading.value && ctrl.mapCenter == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (ctrl.isDelivered.value) {
          return _deliveredView(primary, ctrl);
        }

        return Column(
          children: [
            Expanded(child: _map(ctrl, primary)),
            _bottomPanel(primary, ctrl),
          ],
        );
      }),
    );
  }

  Widget _deliveredView(Color primary, DriverTrackingController ctrl) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green[600], size: 80),
            const SizedBox(height: 16),
            Text(
              'تم التسليم',
              style: GoogleFonts.cairo(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              OrderStatusHelper.labelAr(ctrl.statusCode.value),
              style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey[700]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(backgroundColor: primary),
              child: Text(
                'العودة',
                style: GoogleFonts.cairo(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _map(DriverTrackingController ctrl, Color primary) {
    final center = ctrl.mapCenter ?? const LatLng(33.3152, 44.3661);
    _maybeFitMapToRoute(ctrl);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 14,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
            onMapEvent: (event) {
              if (_highlightDriver && event is MapEventMove) {
                setState(() => _highlightDriver = false);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.romanaappflutter.app',
            ),
            if (ctrl.routePoints.isNotEmpty) ...[
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: ctrl.routePoints,
                    color: Colors.black.withValues(alpha: 0.18),
                    strokeWidth: 10,
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: ctrl.routePoints,
                    color: Colors.white,
                    strokeWidth: 7,
                  ),
                ],
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: ctrl.routePoints,
                    color: primary,
                    strokeWidth: 5,
                    borderColor: primary.withValues(alpha: 0.45),
                    borderStrokeWidth: 1.5,
                  ),
                ],
              ),
            ],
            MarkerLayer(
              markers: [
                ..._marker(
                  ctrl.restaurantLat.value,
                  ctrl.restaurantLng.value,
                  Colors.green,
                  Icons.store,
                  'المطعم',
                ),
                if (!_highlightDriver)
                  ..._marker(
                    ctrl.customerLat.value,
                    ctrl.customerLng.value,
                    Colors.red,
                    Icons.home,
                    'موقعك',
                  ),
                ..._driverMarker(
                  ctrl.driverLat.value,
                  ctrl.driverLng.value,
                  primary,
                ),
              ],
            ),
          ],
        ),
        Positioned(
          top: 12,
          right: 12,
          child: ctrl.isRouteLoading.value
              ? Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: InkWell(
              onTap: () => _focusOnDriver(ctrl),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.gps_fixed, color: primary, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      'موقع السائق',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Marker> _driverMarker(double? lat, double? lng, Color primary) {
    if (lat == null || lng == null) return const [];
    if (lat.abs() < 0.0001 && lng.abs() < 0.0001) return const [];

    return [
      Marker(
        point: LatLng(lat, lng),
        width: 80,
        height: 80,
        alignment: Alignment.bottomCenter,
        child: _DriverMapMarker(color: primary),
      ),
    ];
  }

  List<Marker> _marker(
    double? lat,
    double? lng,
    Color color,
    IconData icon,
    String label,
  ) {
    if (lat == null || lng == null) return const [];
    if (lat.abs() < 0.0001 && lng.abs() < 0.0001) return const [];

    return [
      Marker(
        point: LatLng(lat, lng),
        width: 48,
        height: 48,
        alignment: Alignment.bottomCenter,
        child: Tooltip(
          message: label,
          child: Container(
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
      ),
    ];
  }

  Widget _bottomPanel(Color primary, DriverTrackingController ctrl) {
    final code = ctrl.statusCode.value;
    final step = OrderStatusHelper.trackingStepIndex(code)
        .clamp(0, OrderStatusHelper.trackingStepLabels.length - 1);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              OrderStatusHelper.labelAr(code),
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: primary,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _miniStepper(step, primary),
          if (ctrl.routePoints.isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.15)),
              ),
              child: Row(
                children: [
                  Icon(Icons.route_rounded, color: primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ctrl.routeKind.value == 'driver'
                          ? 'مسار السائق إلى موقعك على الشوارع'
                          : 'مسار التوصيل من المطعم إلى موقعك',
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (ctrl.distanceKm.value > 0) ...[
            const SizedBox(height: 8),
            Text(
              'المسافة على الطريق: ${ctrl.distanceKm.value.toStringAsFixed(1)} كم'
              '${ctrl.etaMinutes.value > 0 ? ' • ${ctrl.etaMinutes.value.round()} دقيقة تقريباً' : ''}',
              style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[700]),
            ),
          ],
          if (ctrl.driverName.value.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'السائق: ${ctrl.driverName.value}',
              style: GoogleFonts.cairo(fontSize: 14),
            ),
          ],
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _focusOnDriver(ctrl),
              icon: Icon(Icons.my_location, color: primary),
              label: Text(
                'التوجه إلى موقع السائق على الخريطة',
                style: GoogleFonts.cairo(
                  color: primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          if (ctrl.driverPhone.value.isNotEmpty) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _callDriver(ctrl.driverPhone.value),
                icon: const Icon(Icons.phone, color: Colors.white),
                label: Text(
                  'اتصال بالسائق',
                  style: GoogleFonts.cairo(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _miniStepper(int activeStep, Color primary) {
    final labels = OrderStatusHelper.trackingStepLabels;
    final step = activeStep.clamp(0, labels.length - 1);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < labels.length; i++) ...[
          if (i > 0)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 3,
                  color: i <= step ? primary : Colors.grey[300],
                ),
              ),
            ),
          SizedBox(
            width: 56,
            child: Column(
              children: [
                Container(
                  width: i == step ? 26 : 22,
                  height: i == step ? 26 : 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: i <= step ? primary : Colors.grey[200],
                    border: i == step
                        ? Border.all(
                            color: primary.withValues(alpha: 0.35), width: 3)
                        : null,
                  ),
                  child: Icon(
                    i < step
                        ? Icons.check_rounded
                        : (i == step
                            ? Icons.radio_button_checked
                            : Icons.circle_outlined),
                    color: i <= step ? Colors.white : Colors.grey[400],
                    size: i == step ? 14 : 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.cairo(
                    fontSize: 9,
                    fontWeight: i == step ? FontWeight.bold : FontWeight.w500,
                    color: i <= step ? primary : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _callDriver(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

/// أيقونة السائق — دراجة توصيل بدون خلفية، مع نبض خفيف.
class _DriverMapMarker extends StatefulWidget {
  const _DriverMapMarker({required this.color});

  final Color color;

  @override
  State<_DriverMapMarker> createState() => _DriverMapMarkerState();
}

class _DriverMapMarkerState extends State<_DriverMapMarker>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 44.0;

    return Tooltip(
      message: 'السائق',
      child: SizedBox(
        width: 72,
        height: 72,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // نبض خفيف تحت الأيقونة — بدون خلفية صلبة
            AnimatedBuilder(
              animation: _pulse,
              builder: (context, child) {
                final t = _pulse.value;
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Transform.scale(
                      scale: 0.85 + t * 0.55,
                      child: Opacity(
                        opacity: (1 - t) * 0.35,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.color.withValues(alpha: 0.55),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7 + t * 0.4,
                      child: Opacity(
                        opacity: (1 - t) * 0.22,
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: widget.color.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            // ظل الأيقونة
            Transform.translate(
              offset: const Offset(0, 3),
              child: Icon(
                Icons.two_wheeler_rounded,
                size: iconSize,
                color: Colors.black.withValues(alpha: 0.22),
              ),
            ),
            // حد أبيض رفيع حول الأيقونة للوضوح على الخريطة
            Icon(
              Icons.two_wheeler_rounded,
              size: iconSize + 3,
              color: Colors.white.withValues(alpha: 0.95),
            ),
            // دراجة التوصيل — بدون خلفية
            Icon(
              Icons.two_wheeler_rounded,
              size: iconSize,
              color: widget.color,
              shadows: const [
                Shadow(color: Colors.white, blurRadius: 8),
                Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            // نقطة مرساة صغيرة أسفل الأيقونة
            Positioned(
              bottom: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.45),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
