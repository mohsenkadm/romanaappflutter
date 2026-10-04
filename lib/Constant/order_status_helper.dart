import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// حالات الطلب حسب statusCode من الباكند (§6.1).
class OrderStatusHelper {
  static const labels = {
    0: 'انتظار موافقة المطعم',
    1: 'تمت الموافقة',
    2: 'جار تجهيز الطلب',
    3: 'تم تعيين السائق',
    4: 'السائق في الطريق لاستلام الطلب',
    5: 'تم استلام الطلب من المطعم',
    6: 'قيد التوصيل إليك',
    7: 'تم التوصيل',
    8: 'تم تأكيد الاستلام',
    9: 'ملغي',
  };

  static const statusKeyToCode = {
    'pending': 0,
    'new_order': 0,
    'approved': 1,
    'preparing': 2,
    'driver_assigned': 3,
    'driver_en_route': 4,
    'picked_up': 5,
    'out_for_delivery': 6,
    'delivered': 7,
    'confirmed': 8,
    'delivery_confirmed': 8,
    'done': 8,
    'cancel': 9,
    'cancelled': 9,
    'canceled': 9,
  };

  static String labelAr(int? code) => labelFor(code ?? -1);

  static String labelFor(int code) {
    final key = 'order.status_$code';
    final translated = key.tr;
    if (translated != key) return translated;
    return labels[code] ?? 'order.status_unknown'.tr;
  }

  /// خطوات شاشة تتبع السائق (5 خطوات) مرتبطة بـ statusCode:
  /// 3→0 تعيين | 4→1 للمطعم | 5→2 استلام | 6→3 إليك | 7+→4 تسليم
  static int trackingStepIndex(int code) {
    if (code <= 3) return 0;
    if (code == 4) return 1;
    if (code == 5) return 2;
    if (code == 6) return 3;
    if (code >= 7 && code != 9) return 4;
    return 0;
  }

  /// @deprecated استخدم [trackingStepIndex]
  static int activeStepFromCode(int code) => trackingStepIndex(code);

  static const trackingStepLabels = [
    'تم تعيين السائق',
    'في الطريق للمطعم',
    'تم الاستلام',
    'في الطريق إليك',
    'تم التسليم',
  ];

  /// لا تستخدم للـ mini-stepper — كانت تُرجع فهرساً أكبر من 4 فتلون كل الخطوات.
  @Deprecated('Use trackingStepIndex for the 5-step tracking UI')
  static int customerStepIndex(int code) => trackingStepIndex(code);

  static int? codeFromPayload(Map<String, dynamic>? data) {
    if (data == null) return null;
    final raw = data['statusCode'];
    if (raw != null) {
      final n = int.tryParse(raw.toString());
      if (n != null && n >= 0) return n;
    }
    final key = (data['statusKey'] ?? data['status'] ?? '').toString();
    if (key.isEmpty) return null;
    return statusKeyToCode[key];
  }

  static String formatIqd(num amount) {
    return '${NumberFormat('#,##0', 'ar_IQ').format(amount)} ${'common.currency'.tr}';
  }
}
