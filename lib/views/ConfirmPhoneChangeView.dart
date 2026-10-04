import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';
import 'package:romanaappflutter/Controller/ConfirmPhoneChangeController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/widgets/OtpBoxes.dart';

class ConfirmPhoneChangeView extends StatefulWidget {
  const ConfirmPhoneChangeView({Key? key, required this.pendingPhone})
      : super(key: key);

  final String pendingPhone;

  @override
  State<ConfirmPhoneChangeView> createState() => _ConfirmPhoneChangeViewState();
}

class _ConfirmPhoneChangeViewState extends State<ConfirmPhoneChangeView> {
  final GlobalKey<OtpBoxesState> _otpKey = GlobalKey<OtpBoxesState>();
  late final ConfirmPhoneChangeController c;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ConfirmPhoneChangeController>()) {
      Get.delete<ConfirmPhoneChangeController>();
    }
    c = Get.put(
        ConfirmPhoneChangeController(pendingPhone: widget.pendingPhone));
  }

  Future<void> _submit(String code) async {
    await c.confirm(code);
    if (mounted && c.codeController.text.isEmpty) {
      _otpKey.currentState?.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = myTheme.primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'profile.otp_title'.tr,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: primary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'profile.otp_hint'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                        fontSize: 15, color: Colors.grey[700], height: 1.5),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.pendingPhone,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  OtpBoxes(
                    key: _otpKey,
                    length: OtpPolicy.codeLength,
                    enabled: !c.isLoading.value,
                    onChanged: (v) => c.codeController.text = v,
                    onCompleted: (v) {
                      c.codeController.text = v;
                      _submit(v);
                    },
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          c.isLoading.value ? null : () => _submit(c.codeController.text.trim()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: c.isLoading.value
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(
                              'profile.otp_confirm'.tr,
                              style: GoogleFonts.cairo(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: c.canResend
                        ? () async {
                            await c.resend();
                            _otpKey.currentState?.clear();
                          }
                        : null,
                    child: Text(
                      c.resendSeconds.value > 0
                          ? '${'login.resend'.tr} (${c.resendSeconds.value})'
                          : 'login.resend'.tr,
                      style: GoogleFonts.cairo(
                        color:
                            c.canResend ? primary : Colors.grey[500],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
