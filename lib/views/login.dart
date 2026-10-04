import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Controller/OtpLoginController.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/widgets/OtpBoxes.dart';
import 'package:romanaappflutter/views/widgets/RumanaOtpMascot.dart';

/// تسجيل الدخول والتسجيل عبر OTP واتساب فقط — بدون كلمة مرور.
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final OtpLoginController c = Get.put(OtpLoginController());
  final GlobalKey<OtpBoxesState> _otpKey = GlobalKey<OtpBoxesState>();

  RumanaOtpPhase _phase = RumanaOtpPhase.idle;
  bool _animating = false;
  bool? _verifySuccess;
  double _eatProgress = 0;
  late AnimationController _eatCtrl;

  @override
  void initState() {
    super.initState();
    _eatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..addListener(() {
        setState(() => _eatProgress = _eatCtrl.value);
      });
  }

  @override
  void dispose() {
    _eatCtrl.dispose();
    super.dispose();
  }

  Future<void> _onConfirm() async {
    if (_animating || c.isLoading.value) return;
    final code = c.codeController.text.trim();
    if (code.length < OtpPolicy.codeLength) {
      setState(() => _phase = RumanaOtpPhase.error);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) setState(() => _phase = RumanaOtpPhase.idle);
      return;
    }

    setState(() {
      _animating = true;
      _phase = RumanaOtpPhase.eating;
      _verifySuccess = null;
      _eatProgress = 0;
    });

    final verifyFuture = c.verifyOtp();
    await Future.wait<void>([
      _eatCtrl.forward(from: 0),
      verifyFuture.then((_) {}),
    ]);
    final ok = await verifyFuture;

    if (!mounted) return;
    setState(() {
      _verifySuccess = ok;
      _phase = ok ? RumanaOtpPhase.success : RumanaOtpPhase.error;
    });

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    if (ok) {
      c.goAfterSuccess();
    } else {
      _otpKey.currentState?.clear();
      c.codeController.clear();
      _eatCtrl.reset();
      setState(() {
        _animating = false;
        _phase = RumanaOtpPhase.idle;
        _verifySuccess = null;
        _eatProgress = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = myTheme.primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 36),
                  Center(
                    child: c.codeSent.value
                        ? RumanaOtpMascot(phase: _phase, size: 110)
                        : Container(
                            width: 110,
                            height: 110,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primary.withOpacity(0.08),
                              border: Border.all(
                                  color: primary.withOpacity(0.15), width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset('assets/images/icon.png',
                                  width: 72, height: 72, fit: BoxFit.contain),
                            ),
                          )
                            .animate()
                            .fadeIn()
                            .scale(begin: const Offset(0.85, 0.85)),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'login.welcome'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.codeSent.value
                        ? 'login.hint_otp'.tr
                        : 'login.hint_phone'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                        fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: c.phoneController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    enabled: !c.codeSent.value && !_animating,
                    decoration: InputDecoration(
                      labelText: 'login.phone_label'.tr,
                      hintText: 'login.phone_hint'.tr,
                      prefixIcon: Icon(Icons.phone_android, color: primary),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                  if (c.codeSent.value) ...[
                    const SizedBox(height: 28),
                    if (_phase == RumanaOtpPhase.eating)
                      FlyingOtpDigits(
                        code: c.codeController.text,
                        progress: _eatProgress,
                      )
                    else if (_verifySuccess != null)
                      Center(child: OtpResultBurst(success: _verifySuccess!))
                    else
                      OtpBoxes(
                        key: _otpKey,
                        length: OtpPolicy.codeLength,
                        enabled: !_animating,
                        onChanged: (v) => c.codeController.text = v,
                        onCompleted: (v) => c.codeController.text = v,
                      ),
                  ],
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: (c.isLoading.value || _animating)
                          ? null
                          : () => c.codeSent.value
                              ? _onConfirm()
                              : c.sendOtp(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: c.isLoading.value && !_animating
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : Text(
                              c.codeSent.value
                                  ? (_animating
                                      ? 'login.verifying'.tr
                                      : 'login.confirm'.tr)
                                  : 'login.send_otp'.tr,
                              style: GoogleFonts.cairo(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                  if (c.codeSent.value && !_animating) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: c.canResend ? () => c.sendOtp() : null,
                      child: Text(
                          c.resendSeconds.value > 0
                              ? '${'login.resend'.tr} (${c.resendSeconds.value})'
                              : 'login.resend'.tr,
                          style: GoogleFonts.cairo(
                              color: c.canResend
                                  ? primary
                                  : Colors.grey[500])),
                    ),
                    TextButton(
                      onPressed: c.isLoading.value
                          ? null
                          : () {
                              c.resetToPhoneStep();
                              _otpKey.currentState?.clear();
                              setState(() {
                                _phase = RumanaOtpPhase.idle;
                                _verifySuccess = null;
                              });
                            },
                      child: Text('login.change_phone'.tr,
                          style: GoogleFonts.cairo(color: Colors.grey[600])),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'login.auto_register'.tr,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                        fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
