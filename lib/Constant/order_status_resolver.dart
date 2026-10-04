import 'package:romanaappflutter/Model/OrdersModel.dart';

/// يستنتج حالة الطلب — statusCode من API هو مصدر الحقيقة (مثل تطبيق السائق).
class OrderStatusResolver {
  OrderStatusResolver._();

  static int _driverId(OrdersModel ord) => ord.SaleManId ?? 0;

  /// يُستخدم فقط عند غياب statusCode من الـ API.
  static int codeFromFlags(OrdersModel ord) {
    if (ord.isCancel == true) return 9;
    if (ord.isDeliveryConfirmed == true) return 8;
    if (ord.isDelivered == true) return 7;
    // لا نرفع isDone وحده إلى 7 إذا وُجد statusCode — هنا fallback فقط.
    if (ord.isDone == true) return 7;
    if (ord.isOutForDelivery == true) return 6;
    if (ord.isPickedUpFromRestaurant == true) return 5;
    if (ord.isDriverEnRouteToPickup == true) return 4;
    final driverId = _driverId(ord);
    if (driverId > 0 || ord.IsSaleManApprove == true) return 3;
    if (ord.isPreparing == true) return 2;
    if (ord.isApporve == true) return 1;
    return 0;
  }

  /// رمز الحالة — يطابق سياسة السائق: API statusCode أولاً.
  static int effectiveCode(OrdersModel? ord, [int? apiStatusCode]) {
    if (ord != null && ord.isCancel == true) return 9;
    // أعلى مستوى من الـ API، ثم statusCode داخل كائن الطلب، ثم الأعلام.
    final code = apiStatusCode ?? ord?.statusCode;
    if (code != null && code >= 0) return code;
    if (ord != null) return codeFromFlags(ord);
    return -1;
  }

  /// مؤشر خطوات واجهة تفاصيل الطلب للزبون (0–4، -1 ملغي).
  /// الترتيب: انتظار → موافقة → تجهيز → السائق في الطريق → تم التسليم
  /// (لا تستخدم activeStepFromCode هنا؛ فهي لشاشة تتبع السائق فقط).
  static int stepIndex(OrdersModel? ord, [int? apiStatusCode]) {
    if (ord != null && (ord.isCancel == true || ord.IsSaleManCancel == true)) {
      return -1;
    }
    final code = effectiveCode(ord, apiStatusCode);
    if (code == 9 || code < 0) return -1;
    if (code >= 7) return 4; // تم التوصيل / تأكيد الاستلام
    if (code >= 3) return 3; // تعيين سائق → استلام → توصيل
    if (code >= 2) return 2; // جارٍ التجهيز
    if (code >= 1) return 1; // تمت الموافقة
    return 0; // في الانتظار
  }
}
