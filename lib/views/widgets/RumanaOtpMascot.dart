import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';

enum RumanaOtpPhase { idle, eating, success, error }

/// شخصية رمّانة لطيفة لأنيميشن التحقق من OTP.
class RumanaOtpMascot extends StatelessWidget {
  const RumanaOtpMascot({
    Key? key,
    required this.phase,
    this.size = 96,
  }) : super(key: key);

  final RumanaOtpPhase phase;
  final double size;

  @override
  Widget build(BuildContext context) {
    Widget body = CustomPaint(
      size: Size(size, size),
      painter: _RumanaPainter(
        mouthOpen: phase == RumanaOtpPhase.eating,
        happy: phase == RumanaOtpPhase.success,
        sad: phase == RumanaOtpPhase.error,
      ),
    );

    switch (phase) {
      case RumanaOtpPhase.idle:
        return body
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: 0, end: -6, duration: 900.ms, curve: Curves.easeInOut);
      case RumanaOtpPhase.eating:
        return body
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.08, 0.92),
              duration: 180.ms,
            )
            .then()
            .scale(
              begin: const Offset(1.08, 0.92),
              end: const Offset(1, 1),
              duration: 180.ms,
            );
      case RumanaOtpPhase.success:
        return body
            .animate()
            .scale(
              begin: const Offset(0.6, 0.6),
              end: const Offset(1.15, 1.15),
              duration: 350.ms,
              curve: Curves.elasticOut,
            )
            .then()
            .scale(end: const Offset(1, 1), duration: 180.ms);
      case RumanaOtpPhase.error:
        return body
            .animate()
            .shake(hz: 5, duration: 500.ms, curve: Curves.easeInOut)
            .tint(color: Colors.red.withOpacity(0.15));
    }
  }
}

class _RumanaPainter extends CustomPainter {
  _RumanaPainter({
    required this.mouthOpen,
    required this.happy,
    required this.sad,
  });

  final bool mouthOpen;
  final bool happy;
  final bool sad;

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 4;
    final r = size.width * 0.38;

    // Body
    final bodyPaint = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFE85A55), Color(0xFFDB2820), Color(0xFFB01E18)],
        stops: [0.15, 0.55, 1],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawCircle(Offset(cx, cy), r, bodyPaint);

    // Crown leaves
    final leaf = Paint()..color = const Color(0xFF2E8B57);
    final path = Path()
      ..moveTo(cx - 8, cy - r + 4)
      ..quadraticBezierTo(cx - 18, cy - r - 18, cx - 2, cy - r - 10)
      ..quadraticBezierTo(cx + 4, cy - r - 4, cx - 8, cy - r + 4);
    canvas.drawPath(path, leaf);
    final path2 = Path()
      ..moveTo(cx + 6, cy - r + 2)
      ..quadraticBezierTo(cx + 20, cy - r - 16, cx + 4, cy - r - 8)
      ..quadraticBezierTo(cx - 2, cy - r - 2, cx + 6, cy - r + 2);
    canvas.drawPath(path2, leaf);

    // Eyes
    final eyePaint = Paint()..color = Colors.white;
    final pupil = Paint()..color = const Color(0xFF2C2C2C);
    final eyeY = cy - r * 0.15;
    final eyeDX = r * 0.32;
    if (sad) {
      // X eyes
      final xPaint = Paint()
        ..color = const Color(0xFF2C2C2C)
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      for (final dx in [-eyeDX, eyeDX]) {
        canvas.drawLine(
            Offset(cx + dx - 5, eyeY - 5), Offset(cx + dx + 5, eyeY + 5), xPaint);
        canvas.drawLine(
            Offset(cx + dx + 5, eyeY - 5), Offset(cx + dx - 5, eyeY + 5), xPaint);
      }
    } else {
      canvas.drawCircle(Offset(cx - eyeDX, eyeY), 7, eyePaint);
      canvas.drawCircle(Offset(cx + eyeDX, eyeY), 7, eyePaint);
      canvas.drawCircle(Offset(cx - eyeDX + 1.5, eyeY + 0.5), 3.2, pupil);
      canvas.drawCircle(Offset(cx + eyeDX + 1.5, eyeY + 0.5), 3.2, pupil);
      if (happy) {
        // Happy closed curve under eye as blush
        final blush = Paint()..color = const Color(0xFFFF8A80).withOpacity(0.55);
        canvas.drawOval(
            Rect.fromCenter(
                center: Offset(cx - eyeDX - 10, eyeY + 10),
                width: 10,
                height: 6),
            blush);
        canvas.drawOval(
            Rect.fromCenter(
                center: Offset(cx + eyeDX + 10, eyeY + 10),
                width: 10,
                height: 6),
            blush);
      }
    }

    // Mouth
    final mouthY = cy + r * 0.28;
    final mouthPaint = Paint()
      ..color = const Color(0xFF5A0A0A)
      ..style = PaintingStyle.fill;
    if (mouthOpen) {
      canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, mouthY), width: r * 0.7, height: r * 0.55),
        mouthPaint,
      );
      // Teeth
      final teeth = Paint()..color = Colors.white;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset(cx, mouthY - 4), width: r * 0.45, height: 6),
          const Radius.circular(2),
        ),
        teeth,
      );
    } else if (sad) {
      final smile = Path()
        ..moveTo(cx - 12, mouthY + 6)
        ..quadraticBezierTo(cx, mouthY - 4, cx + 12, mouthY + 6);
      canvas.drawPath(
        smile,
        Paint()
          ..color = const Color(0xFF5A0A0A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    } else {
      final smile = Path()
        ..moveTo(cx - 12, mouthY - 2)
        ..quadraticBezierTo(cx, mouthY + (happy ? 12 : 8), cx + 12, mouthY - 2);
      canvas.drawPath(
        smile,
        Paint()
          ..color = const Color(0xFF5A0A0A)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Highlight
    canvas.drawCircle(
      Offset(cx - r * 0.35, cy - r * 0.35),
      r * 0.14,
      Paint()..color = Colors.white.withOpacity(0.28),
    );
  }

  @override
  bool shouldRepaint(covariant _RumanaPainter oldDelegate) =>
      oldDelegate.mouthOpen != mouthOpen ||
      oldDelegate.happy != happy ||
      oldDelegate.sad != sad;
}

/// نتيجة أنيميشن التحقق: صح أو خطأ فوق الخانات.
class OtpResultBurst extends StatelessWidget {
  const OtpResultBurst({Key? key, required this.success}) : super(key: key);
  final bool success;

  @override
  Widget build(BuildContext context) {
    final color = success ? const Color(0xFF2E8B57) : Colors.red;
    final icon = success ? Icons.check_rounded : Icons.close_rounded;
    return Container(
      width: 88,
      height: 88,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.12),
        border: Border.all(color: color, width: 3),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 48),
    )
        .animate()
        .scale(
          begin: const Offset(0.2, 0.2),
          end: const Offset(1.15, 1.15),
          duration: 420.ms,
          curve: Curves.elasticOut,
        )
        .then()
        .scale(end: const Offset(1, 1), duration: 160.ms)
        .fadeIn(duration: 200.ms);
  }
}

/// أرقام تطير نحو الرمّانة أثناء «الأكل».
class FlyingOtpDigits extends StatelessWidget {
  const FlyingOtpDigits({
    Key? key,
    required this.code,
    required this.progress,
  }) : super(key: key);

  final String code;
  final double progress; // 0..1

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final chars = code
        .padRight(OtpPolicy.codeLength)
        .substring(0, OtpPolicy.codeLength)
        .split('');
    return SizedBox(
      height: 70,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(OtpPolicy.codeLength, (i) {
          final start = i * 0.18;
          localProgress(double p) =>
              ((p - start) / 0.22).clamp(0.0, 1.0);
          final t = Curves.easeInCubic.transform(localProgress(progress));
          final dy = -t * 70;
          final opacity = (1 - t).clamp(0.0, 1.0);
          final scale = 1 - t * 0.55;
          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(math.sin(t * math.pi) * (i.isEven ? -8 : 8), dy),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 36,
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: primary.withOpacity(0.4)),
                  ),
                  child: Text(
                    chars[i].trim().isEmpty ? '' : chars[i],
                    style: GoogleFonts.cairo(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
      ),
    );
  }
}
