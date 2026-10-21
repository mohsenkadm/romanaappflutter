import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Constant/location_guard.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/core/api/api_client.dart';
import 'package:romanaappflutter/core/pricing/pricing_service.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/CoverageRequestPage.dart';
import 'package:romanaappflutter/views/MainApp.dart';

enum _GatePhase { loadingGps, mapReady, checking, outsideZone, error }

/// خريطة + موقع الزبون ثم فحص التغطية.
class CoverageGate extends StatefulWidget {
  const CoverageGate({super.key});

  @override
  State<CoverageGate> createState() => _CoverageGateState();
}

class _CoverageGateState extends State<CoverageGate> {
  final MapController _mapController = MapController();

  _GatePhase _phase = _GatePhase.loadingGps;
  String? _message;
  double? _lat;
  double? _lng;
  String? _zoneName;

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  static const _fallbackLat = 33.3152;
  static const _fallbackLng = 44.3661;
  bool _pinMoved = false;

  Future<void> _initLocation() async {
    setState(() {
      _phase = _GatePhase.loadingGps;
      _message = null;
      _pinMoved = false;
    });

    if (LocationStorage.coverageVerified) {
      final saved = LocationStorage.read();
      if (saved != null) {
        _applyCoords(saved.lat, saved.lng);
        _zoneName = LocationStorage.zoneName;
        setState(() => _phase = _GatePhase.mapReady);
        return;
      }
    }

    final coords = await LocationGuard.ensureCoordinates(
      showSnackbar: false,
      allowSavedFallback: true,
    );
    if (coords != null) {
      _applyCoords(coords.lat, coords.lng);
      setState(() => _phase = _GatePhase.mapReady);
      return;
    }

    _applyCoords(_fallbackLat, _fallbackLng);
    setState(() {
      _phase = _GatePhase.mapReady;
      _message = 'تعذر قراءة GPS — اضغط على الخريطة لتحديد موقعك';
    });
  }

  void _applyCoords(double lat, double lng) {
    _lat = lat;
    _lng = lng;
    _showOnMap(lat, lng);
    if (Get.isRegistered<determinePositionLocation>()) {
      Get.find<determinePositionLocation>().apply(lat, lng);
    }
  }

  void _finishSuccess() {
    if (!mounted) return;
    if (Navigator.of(context).canPop()) {
      Get.back(result: true);
    } else {
      Get.offAll(() => const MainApp());
    }
  }

  void _showOnMap(double lat, double lng, {double? zoom}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final z = zoom ?? _safeZoom(fallback: 16);
        _mapController.move(LatLng(lat, lng), z);
      } catch (_) {}
    });
  }

  double _safeZoom({double fallback = 16}) {
    try {
      return _mapController.camera.zoom;
    } catch (_) {
      return fallback;
    }
  }

  void _zoomBy(double delta) {
    try {
      final camera = _mapController.camera;
      final next = (camera.zoom + delta).clamp(3.0, 19.0);
      _mapController.move(camera.center, next);
    } catch (_) {}
  }

  Future<void> _goToMyLocation() async {
    setState(() {
      _phase = _GatePhase.loadingGps;
      _message = null;
    });

    final coords = await LocationGuard.ensureCoordinates(
      showSnackbar: true,
      allowSavedFallback: false,
      preferSaved: false,
    );

    if (!mounted) return;

    if (coords == null) {
      setState(() {
        _phase = _GatePhase.mapReady;
        _message = 'تعذر قراءة موقعك الحالي — فعّل GPS أو اضغط على الخريطة';
      });
      return;
    }

    _pinMoved = true;
    _zoneName = null;
    _applyCoords(coords.lat, coords.lng);
    _showOnMap(coords.lat, coords.lng, zoom: 16);
    setState(() {
      _phase = _GatePhase.mapReady;
      _message = null;
    });
  }

  Future<void> _checkCoverage() async {
    if (_lat == null || _lng == null) return;
    setState(() {
      _phase = _GatePhase.checking;
      _message = null;
    });

    try {
      final api = ApiClient();
      final coverage = await checkCoverage(api, lat: _lat!, lng: _lng!);

      if (!coverage.covered) {
        setState(() {
          _phase = _GatePhase.outsideZone;
          _message = coverage.message ?? 'أنت خارج مناطق التغطية الحالية';
        });
        return;
      }

      final zone = await resolveZone(api, lat: _lat!, lng: _lng!);
      await LocationStorage.save(
        _lat!,
        _lng!,
        zoneId: zone?.zoneId ?? coverage.zoneId,
        zoneName: zone?.zoneName ?? coverage.zoneName,
      );
      if (Get.isRegistered<determinePositionLocation>()) {
        Get.find<determinePositionLocation>().apply(_lat!, _lng!);
      }

      if (!mounted) return;
      _finishSuccess();
    } catch (e) {
      setState(() {
        _phase = _GatePhase.error;
        _message = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _openCoverageRequest() {
    if (_lat == null || _lng == null) return;
    Get.to(() => CoverageRequestPage(lat: _lat!, lng: _lng!));
  }

  @override
  Widget build(BuildContext context) {
    final primary = myTheme.primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تحديد موقعك',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (_lat != null && _lng != null)
                  FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(_lat!, _lng!),
                      initialZoom: 16,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.all,
                      ),
                      onTap: (tapPosition, point) {
                        _pinMoved = true;
                        _zoneName = null;
                        _applyCoords(point.latitude, point.longitude);
                        setState(() {
                          _phase = _GatePhase.mapReady;
                          _message = null;
                        });
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.alaman.romanaappflutter',
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(_lat!, _lng!),
                            width: 48,
                            height: 48,
                            alignment: Alignment.bottomCenter,
                            child: Icon(
                              Icons.location_pin,
                              size: 48,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  const Center(child: CircularProgressIndicator()),
                if (_lat != null && _lng != null) ...[
                  Positioned(
                    right: 12,
                    bottom: 16,
                    child: _mapZoomControls(primary),
                  ),
                  Positioned(
                    left: 12,
                    bottom: 16,
                    child: _myLocationButton(primary),
                  ),
                ],
                if (_phase == _GatePhase.loadingGps ||
                    _phase == _GatePhase.checking)
                  Container(
                    color: Colors.black26,
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 12),
                              Text(
                                _phase == _GatePhase.checking
                                    ? 'جاري التحقق من التغطية...'
                                    : 'جاري تحديد موقعك...',
                                style: GoogleFonts.cairo(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          _bottomPanel(primary),
        ],
      ),
    );
  }

  Widget _mapZoomControls(Color primary) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _mapIconButton(
            icon: Icons.add,
            tooltip: 'تكبير',
            onTap: () => _zoomBy(1),
            primary: primary,
          ),
          Container(width: 36, height: 1, color: Colors.grey.shade200),
          _mapIconButton(
            icon: Icons.remove,
            tooltip: 'تصغير',
            onTap: () => _zoomBy(-1),
            primary: primary,
          ),
        ],
      ),
    );
  }

  Widget _myLocationButton(Color primary) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: InkWell(
        onTap: _phase == _GatePhase.loadingGps || _phase == _GatePhase.checking
            ? null
            : _goToMyLocation,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.my_location, color: primary, size: 20),
              const SizedBox(width: 6),
              Text(
                'موقعي الحالي',
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
    );
  }

  Widget _mapIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    required Color primary,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: primary),
        ),
      ),
    );
  }

  Widget _bottomPanel(Color primary) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_lat != null && _lng != null) ...[
            Text(
              'خط العرض: ${_lat!.toStringAsFixed(5)}  |  خط الطول: ${_lng!.toStringAsFixed(5)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'اضغط على الخريطة لتعديل الموقع',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
          if (_zoneName != null && _zoneName!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'الزون: $_zoneName',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                _message!,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: _phase == _GatePhase.outsideZone
                      ? Colors.orange[800]
                      : Colors.red[700],
                  fontSize: 14,
                ),
              ),
            ),
          if (_phase == _GatePhase.mapReady ||
              _phase == _GatePhase.error ||
              LocationStorage.coverageVerified)
            ElevatedButton(
              onPressed: _phase == _GatePhase.checking
                  ? null
                  : () {
                      if (LocationStorage.coverageVerified &&
                          _phase == _GatePhase.mapReady &&
                          !_pinMoved) {
                        _finishSuccess();
                      } else {
                        _checkCoverage();
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                LocationStorage.coverageVerified
                    ? 'متابعة إلى التطبيق'
                    : 'تأكيد الموقع والتحقق من التغطية',
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          if (_phase == _GatePhase.outsideZone) ...[
            ElevatedButton(
              onPressed: _openCoverageRequest,
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'طلب توفير الخدمة في منطقتي',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _initLocation,
              child: const Text('تحديث الموقع على الخريطة'),
            ),
          ] else if (_phase == _GatePhase.error) ...[
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: _initLocation,
              child: const Text('إعادة المحاولة'),
            ),
            TextButton(
              onPressed: LocationGuard.openAppSettings,
              child: const Text('فتح إعدادات الموقع'),
            ),
          ],
        ],
      ),
    );
  }
}
