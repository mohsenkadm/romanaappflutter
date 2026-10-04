/// سياسة OTP الموحّدة مع API الأمان الجديد (RomanaWeb).
class OtpPolicy {
  OtpPolicy._();

  static const int codeLength = 6;
  static const int resendCooldownSeconds = 60;
  static const int minPasswordLength = 6;
  static const int codeTtlMinutes = 5;

  static bool isValidCode(String? code) {
    final c = (code ?? '').trim();
    return RegExp('^\\d{$codeLength}\$').hasMatch(c);
  }

  static bool isValidPassword(String? pass) {
    final p = (pass ?? '').trim();
    return p.length >= minPasswordLength;
  }

  /// يستخرج ثواني الانتظار من رسالة السيرفر إن وُجدت (مثل: انتظر 45 ثانية...).
  static int? parseWaitSeconds(String? msg) {
    if (msg == null || msg.isEmpty) return null;
    final m = RegExp(r'(\d+)\s*ثان').firstMatch(msg);
    if (m != null) return int.tryParse(m.group(1)!);
    final any = RegExp(r'انتظر\s*(\d+)').firstMatch(msg);
    if (any != null) return int.tryParse(any.group(1)!);
    return null;
  }

  static bool isExpiredOrExhausted(String? msg) {
    final m = (msg ?? '').toLowerCase();
    return m.contains('انتهت صلاحية') ||
        m.contains('تجاوز محاولات') ||
        m.contains('لا يوجد كود تحقق فعال') ||
        m.contains('اطلب كوداً جديداً') ||
        m.contains('اطلب كودا جديدا');
  }
}
