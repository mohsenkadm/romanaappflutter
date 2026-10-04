import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/core/pricing/pricing_service.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/MainApp.dart';

/// شاشة طلب توفير الخدمة خارج مناطق التغطية (PDF §2.1).
class CoverageRequestPage extends StatefulWidget {
  final double lat;
  final double lng;

  const CoverageRequestPage({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  State<CoverageRequestPage> createState() => _CoverageRequestPageState();
}

class _CoverageRequestPageState extends State<CoverageRequestPage> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final box = GetStorage();
    _phoneCtrl.text = box.read('Phone')?.toString() ?? '';
    _nameCtrl.text = box.read('Name')?.toString() ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim().replaceAll(RegExp(r'\s+'), '');
    final address = _addressCtrl.text.trim();

    if (name.isEmpty || phone.length != 11 || address.isEmpty) {
      ErrorMessage.SnackMessage(
        'أدخل الاسم ورقم الهاتف (11 رقم) والعنوان',
        Colors.red[400]!,
      );
      return;
    }
    if (_loading) return;
    setState(() => _loading = true);
    try {
      await submitCoverageRequest(
        name: name,
        phone: phone,
        address: address,
        lat: widget.lat,
        lng: widget.lng,
      );
      await LocationStorage.saveCoordinatesOnly(widget.lat, widget.lng);
      await LocationStorage.markRequestSubmitted();
      if (!mounted) return;
      Get.offAll(
        () => const MainApp(),
        duration: const Duration(milliseconds: 400),
        transition: Transition.fadeIn,
      );
      Future.delayed(const Duration(milliseconds: 350), () {
        ErrorMessage.SnackMessage(
          'تم تسجيل طلب توفير الخدمة — سنبلغك عند التفعيل',
          Colors.green[400]!,
        );
      });
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      ErrorMessage.SnackMessage(
        msg.isEmpty ? 'تعذر إرسال الطلب، حاول مجدداً' : msg,
        Colors.red[400]!,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'طلب توفير الخدمة',
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: myTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.orange[700]),
            const SizedBox(height: 16),
            const Text(
              'أنت خارج مناطق التغطية الحالية',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'سجّل بياناتك وسنتواصل معك عند توفير الخدمة في منطقتك',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'الموقع: ${widget.lat.toStringAsFixed(5)}, ${widget.lng.toStringAsFixed(5)}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _nameCtrl,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'الاسم',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              textAlign: TextAlign.right,
              decoration: const InputDecoration(
                labelText: 'رقم الهاتف (11 رقم)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressCtrl,
              textAlign: TextAlign.right,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'العنوان',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: myTheme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('إرسال الطلب',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
