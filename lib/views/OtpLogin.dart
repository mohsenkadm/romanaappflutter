import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';
import 'package:romanaappflutter/Controller/OtpLoginController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/widgets/OtpBoxes.dart';

class OtpLogin extends StatelessWidget {
  const OtpLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(OtpLoginController());
    final primary = myTheme.primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('تسجيل الدخول', style: GoogleFonts.cairo()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'سجّل دخولك برقم واتساب',
                    style: GoogleFonts.cairo(
                        fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '11 رقم — مثال: 07701234567',
                    style: GoogleFonts.cairo(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: c.phoneController,
                    keyboardType: TextInputType.phone,
                    textAlign: TextAlign.right,
                    enabled: !c.codeSent.value,
                    decoration: const InputDecoration(
                      labelText: 'رقم الهاتف',
                      prefixIcon: Icon(Icons.phone_android),
                    ),
                  ),
                  if (c.codeSent.value) ...[
                    const SizedBox(height: 24),
                    Text(
                      'أدخل كود التحقق (${OtpPolicy.codeLength} أرقام)',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cairo(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 12),
                    OtpBoxes(
                      length: OtpPolicy.codeLength,
                      onChanged: (v) => c.codeController.text = v,
                      onCompleted: (v) => c.codeController.text = v,
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: c.isLoading.value
                        ? null
                        : () async {
                            if (!c.codeSent.value) {
                              await c.sendOtp();
                              return;
                            }
                            final ok = await c.verifyOtp();
                            if (ok) c.goAfterSuccess();
                          },
                    child: c.isLoading.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text(
                            c.codeSent.value ? 'تأكيد الدخول' : 'إرسال الكود',
                            style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                  if (c.codeSent.value)
                    TextButton(
                      onPressed: c.canResend ? c.sendOtp : null,
                      child: Text(
                        c.resendSeconds.value > 0
                            ? 'إعادة الإرسال (${c.resendSeconds.value})'
                            : 'إعادة إرسال الكود',
                        style: GoogleFonts.cairo(
                            color: c.canResend ? primary : Colors.grey),
                      ),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
