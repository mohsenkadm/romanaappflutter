import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Constant/location_guard.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/RestaourantProfileController.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';
import 'package:romanaappflutter/Constant/api_auth.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Constant/restaurant_id_resolver.dart';
import 'package:romanaappflutter/Service/order_api_http.dart';
import 'package:romanaappflutter/core/api/api_client.dart';
import 'package:romanaappflutter/core/pricing/pricing_service.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/views/CoverageGate.dart';
import 'package:romanaappflutter/views/MainApp.dart';
import 'package:romanaappflutter/views/login.dart';

import 'package:romanaappflutter/Model/PromoCodeModel.dart';
import 'package:romanaappflutter/Model/RestaurantCityModel.dart';

class SendOrderController extends GetxController {
  RxBool isloded = true.obs;
  RxBool islodedbtn = false.obs;
  RxBool islodedbtnsend = false.obs;
  RxBool islodedQuote = false.obs;
  RxBool isPricingReady = false.obs;
  RxBool quoteFailed = false.obs;
  RxDouble netAmount = 0.0.obs;
  RxDouble totalprice = 0.0.obs;
  RxDouble discountprice = 0.0.obs;
  RxInt discount = 0.obs;
  RxInt costDelivery = 0.obs;
  final Rxn<QuoteResult> lastQuote = Rxn<QuoteResult>();
  // Backend-validated promo code state
  RxBool promoApplied = false.obs;
  RxString promoError = ''.obs;
  RxDouble promoDiscountAmount = 0.0.obs; // absolute amount from backend
  var cityvalue=0.obs;
  // final nameController = TextEditingController();
  // final phoneController = TextEditingController();
  // final addressController = TextEditingController();
  // final pointController = TextEditingController();
  final noteController = TextEditingController();
  final promocodeController = TextEditingController();
  var userId = 0.obs;
  final box = GetStorage();
  MyOrderController get _myOrderController => MyOrderController.instance;

  final determinePositionLocation locationService =
      Get.isRegistered<determinePositionLocation>()
          ? Get.find<determinePositionLocation>()
          : Get.put(determinePositionLocation(), permanent: true);
      
  @override
  Future<void> onInit() async {
    super.onInit();
    userId.value = box.read('UserId') ?? 0;
    // Show cart subtotal immediately while location + delivery quote load.
    SumPrice();
    locationService.hydrateFromStorage();
    await locationService.getCurrentLocation();
    await fetchPricingQuote();
  }

  /// Report0002: restaurant minimum or default 3000 IQD.
  int get minOrderAmount {
    if (Get.isRegistered<RestaourantProfileController>()) {
      final mp =
          Get.find<RestaourantProfileController>().item.value.minimumPrice;
      if (mp != null && mp > 0) return mp;
    }
    return 3000;
  }

  bool get meetsMinOrder => totalprice.value >= minOrderAmount;

  bool get _hasDropoffPin {
    if (LocationGuard.isValid(
      locationService.latitude.value,
      locationService.longitude.value,
    )) {
      return true;
    }
    return LocationStorage.hasSavedCoordinates;
  }

  /// True when amounts are calculated and the order can be submitted safely.
  bool get canSubmitOrder =>
      !islodedbtnsend.value &&
      !islodedQuote.value &&
      !quoteFailed.value &&
      isPricingReady.value &&
      ListItemCard.itemscard.isNotEmpty &&
      totalprice.value > 0 &&
      meetsMinOrder &&
      LocationStorage.coverageVerified &&
      _hasDropoffPin;

  @override
  void onClose() {
    // nameController.dispose();
    // phoneController.dispose();
    // addressController.dispose();
    // pointController.dispose();
    noteController.dispose();
    promocodeController.dispose();
  }

  void _applyDeliveryFee(int fee) {
    costDelivery.value = fee < 0 ? 0 : fee;
    SumPrice();
    update();
  }

  void _promptChooseLocation() {
    if (Get.context == null) return;
    AwesomeDialog(
      buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
      context: Get.context!,
      dialogType: DialogType.warning,
      headerAnimationLoop: true,
      animType: AnimType.bottomSlide,
      title: 'تحديد الموقع',
      reverseBtnOrder: true,
      showCloseIcon: true,
      btnOkText: 'نعم',
      btnCancelText: 'الغاء',
      btnOkIcon: Icons.check_circle,
      btnCancelIcon: Icons.cancel,
      btnOkOnPress: () async {
        await Get.to(() => const CoverageGate());
        locationService.hydrateFromStorage();
        await locationService.getCurrentLocation();
        await fetchPricingQuote();
      },
      desc: 'يجب تحديد موقعك والتحقق من التغطية',
    ).show();
  }

  int _cityIdForApi() =>
      int.tryParse(box.read('CityId')?.toString() ?? '0') ?? 0;

  Future<({double lat, double lng})?> _resolvePickupCoordinates() async {
    final restaurantId = RestaurantIdResolver.fromCartOrProfile();
    if (restaurantId <= 0) return null;

    if (Get.isRegistered<RestaourantProfileController>()) {
      final profile = Get.find<RestaourantProfileController>().item.value;
      final lat = double.tryParse(profile.lat ?? '');
      final lng = double.tryParse(profile.long ?? '');
      if (lat != null && lng != null && (lat != 0 || lng != 0)) {
        return (lat: lat, lng: lng);
      }
    }

    final response = await http.get(
      Uri.https(
        AppLink.apiUrl,
        AppLink.getRestaurantById,
        {'Id': restaurantId.toString()},
      ),
    );
    if (response.statusCode != 200) return null;

    final result = json.decode(response.body);
    if (result is! Map || result['success'] != true) return null;

    final data = result['data'];
    if (data is! Map) return null;

    final lat = double.tryParse(data['lat']?.toString() ?? '');
    final lng = double.tryParse(
      data['long']?.toString() ?? data['lng']?.toString() ?? '',
    );
    if (lat == null || lng == null) return null;
    return (lat: lat, lng: lng);
  }

  Future<int?> _fetchCityDeliveryFee(int restaurantId, int cityId) async {
    try {
      final response = await http.get(
        Uri.https(
          AppLink.apiUrl,
          AppLink.getDeliveryFee(restaurantId, cityId),
        ),
      );
      if (response.statusCode != 200) return null;
      final result = json.decode(response.body);
      if (result is! Map || result['success'] != true) return null;
      final data = result['data'];
      if (data is Map) {
        final fee = data['costDelivery'] ?? data['CostDelivery'] ?? data['total'];
        if (fee is num) return fee.round();
        return int.tryParse(fee?.toString() ?? '');
      }
    } catch (_) {}
    return null;
  }

  Future<int?> _fetchDeliveryFeeFromRestaurantCities(
    int restaurantId,
    int cityId,
  ) async {
    try {
      final response = await http.get(
        Uri.https(
          AppLink.apiUrl,
          AppLink.RestaurantCityGetByResId,
          {'Id': restaurantId.toString()},
        ),
      );
      if (response.statusCode != 200) return null;
      final result = json.decode(response.body);
      if (result is! Map || result['success'] != true) return null;
      final data = result['data'];
      if (data is! List) return null;
      for (final item in data) {
        if (item is! Map) continue;
        final row = RestaurantCityModel.fromJson(
          Map<String, dynamic>.from(item),
        );
        if (row.CityId == cityId && row.costDelivery != null) {
          return row.costDelivery;
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> _applyDeliveryFeeFallback(int restaurantId, int cityId) async {
    final direct = await _fetchCityDeliveryFee(restaurantId, cityId);
    if (direct != null && direct > 0) {
      _applyDeliveryFee(direct);
      return;
    }
    final fromList = await _fetchDeliveryFeeFromRestaurantCities(
      restaurantId,
      cityId,
    );
    if (fromList != null && fromList > 0) {
      _applyDeliveryFee(fromList);
      return;
    }
    quoteFailed.value = true;
    _applyDeliveryFee(0);
  }

  // void getinfo() {
  //   userId.value = box.read('UserId') ?? 0;
     
  //   // nameController.text = box.read('Name') ?? '';
  //   // phoneController.text = box.read('Phone') ?? '';
  //   // addressController.text = box.read('Address') ?? '';
  //   // pointController.text = box.read('FunctionPoint') ?? '';
  // }

  Future<void> getpromocode() async {
    if (islodedbtn.value) return;
    islodedbtn.value = true;
    promoError.value = '';
    try {
      if (promocodeController.text.trim().isEmpty) {
        promoError.value = 'الرجاء ادخال كود الخصم';
        return;
      }

      final resId = RestaurantIdResolver.fromCartOrProfile();
      final query = <String, String>{
        'promoName': promocodeController.text.trim(),
        'restaurantId': resId.toString(),
        'userId': userId.value.toString(),
      };
      var response = await http.get(
        Uri.https(AppLink.apiUrl, AppLink.validatePromoCodeGet, query),
        headers: ApiAuth.headers(),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == true) {
          final applyQuery = <String, String>{
            ...query,
            'orderTotal': totalprice.value.toString(),
          };
          final applyRes = await http.post(
            Uri.https(AppLink.apiUrl, AppLink.applyPromoCode, applyQuery),
            headers: ApiAuth.headers(),
          );
          if (applyRes.statusCode == 200) {
            final applyBody = json.decode(applyRes.body);
            if (applyBody['success'] == true) {
              final raw = applyBody['data'];
              final map = raw is Map
                  ? Map<String, dynamic>.from(raw)
                  : <String, dynamic>{};
              final amount = _readDiscountAmount(map, applyBody);
              final percent = _readDiscountPercent(map, result);
              if (amount > 0) {
                promoDiscountAmount.value = amount;
                discount.value = 0;
                promoApplied.value = true;
                await SumPrice();
                ErrorMessage.SnackMessage(
                    'تم تطبيق كود الخصم', Colors.green[400]!);
                return;
              }
              if (percent > 0) {
                promoDiscountAmount.value = 0;
                discount.value = percent.round();
                promoApplied.value = true;
                await SumPrice();
                ErrorMessage.SnackMessage(
                    'تم تطبيق كود الخصم', Colors.green[400]!);
                return;
              }
            }
          }
          final validateData = result['data'];
          final vMap = validateData is Map
              ? Map<String, dynamic>.from(validateData)
              : <String, dynamic>{};
          final percentOnly = _readDiscountPercent(vMap, result);
          if (percentOnly > 0) {
            promoDiscountAmount.value = 0;
            discount.value = percentOnly.round();
            promoApplied.value = true;
            await SumPrice();
            ErrorMessage.SnackMessage(
                'تم تطبيق كود الخصم', Colors.green[400]!);
            return;
          }
          promoApplied.value = false;
          promoDiscountAmount.value = 0;
          discount.value = 0;
          promoError.value = 'تعذر احتساب قيمة الخصم لهذا الكود';
          ErrorMessage.SnackMessage(promoError.value, Colors.red[400]!);
          await SumPrice();
          return;
        } else {
          promoApplied.value = false;
          promoDiscountAmount.value = 0;
          discount.value = 0;
          final msg = result['msg']?.toString() ?? 'كود غير صالح';
          promoError.value = msg;
          ErrorMessage.SnackMessage(msg, Colors.red[400]!);
          SumPrice();
          return;
        }
      }

      await _legacyGetPromoCode();
    } catch (ex) {
      // Network error → try legacy fallback once.
      try {
        await _legacyGetPromoCode();
      } catch (_) {
        promoError.value = 'تعذر التحقق من كود الخصم';
        promoApplied.value = false;
        promoDiscountAmount.value = 0;
        discount.value = 0;
        await SumPrice();
        ErrorMessage.SnackMessage(
            promoError.value, Colors.red[400]!);
      }
    } finally {
      islodedbtn.value = false;
    }
  }

  double _readDiscountAmount(Map<String, dynamic> data, [dynamic root]) {
    num? n = data['discountValue'] ??
        data['DiscountValue'] ??
        data['discountAmount'] ??
        data['DiscountAmount'] ??
        data['amount'];
    if (n == null && root is Map) {
      n = root['discountValue'] ?? root['DiscountValue'];
    }
    return (n ?? 0).toDouble();
  }

  double _readDiscountPercent(Map<String, dynamic> data, [dynamic root]) {
    num? n = data['percentage'] ??
        data['Percentage'] ??
        data['discountPercent'] ??
        data['DiscountPercent'] ??
        data['percent'];
    if (n == null && root is Map) {
      final d = root['data'];
      if (d is Map) {
        n = d['percentage'] ?? d['Percentage'];
      }
    }
    return (n ?? 0).toDouble();
  }

  String _promoErrorMessage(String code, String fallback) {
    switch (code.toUpperCase()) {
      case 'EXPIRED':
        return 'كود الخصم منتهي الصلاحية';
      case 'USAGE_LIMIT':
      case 'EXCEEDED':
        return 'تم استنفاد عدد مرات استخدام الكود';
      case 'WRONG_STORE':
      case 'STORE_SCOPE':
        return 'كود الخصم غير صالح لهذا المتجر';
      case 'NOT_FOUND':
      case 'INVALID':
        return 'كود الخصم غير صحيح';
      default:
        return fallback.isNotEmpty
            ? fallback
            : 'كود الخصم غير صالح';
    }
  }

  Future<void> _legacyGetPromoCode() async {
    final response =
        await http.get(Uri.https(AppLink.apiUrl, AppLink.getPromoCode));
    if (response.statusCode != 200) {
      promoError.value = 'تعذر التحقق من كود الخصم';
      ErrorMessage.SnackMessage(promoError.value, Colors.red[400]!);
      return;
    }
    final result = json.decode(response.body);
    if (result['success'] == false) {
      promoError.value = 'تعذر التحقق من كود الخصم';
      ErrorMessage.SnackMessage(promoError.value, Colors.red[400]!);
      return;
    }
    final data = result['data'] as List;
    final list = data.map((j) => PromoCodeModel.fromJson(j)).toList();
    final code = list.firstWhere(
      (p) => p.PromoName == promocodeController.text.trim(),
      orElse: () =>
          PromoCodeModel(Percentage: 0, PromoName: '', PromoCodeId: 0),
    );
    if (code.PromoCodeId > 0) {
      final pct = (code.Percentage).toDouble();
      if (pct <= 0) {
        promoApplied.value = false;
        discount.value = 0;
        promoDiscountAmount.value = 0;
        promoError.value = 'كود الخصم بدون قيمة صالحة';
        ErrorMessage.SnackMessage(promoError.value, Colors.red[400]!);
        SumPrice();
        return;
      }
      discount.value = pct.round();
      promoDiscountAmount.value = 0;
      promoApplied.value = true;
      SumPrice();
      ErrorMessage.SnackMessage(
          'تم تطبيق كود الخصم', Colors.green[400]!);
    } else {
      promoApplied.value = false;
      discount.value = 0;
      promoError.value = 'كود الخصم غير صحيح';
      ErrorMessage.SnackMessage(promoError.value, Colors.red[400]!);
      SumPrice();
    }
  }

  /// Delivery fee from POST pricing/quote (pickup → dropoff, distance-based).
  Future<void> fetchPricingQuote() async {
    if (ListItemCard.itemscard.isEmpty) {
      isPricingReady.value = true;
      _applyDeliveryFee(0);
      return;
    }
    if (islodedQuote.value) return;
    islodedQuote.value = true;
    isPricingReady.value = false;
    quoteFailed.value = false;
    try {
      if (!LocationStorage.coverageVerified) {
        _promptChooseLocation();
        _applyDeliveryFee(0);
        return;
      }

      locationService.hydrateFromStorage();
      if (!LocationGuard.isValid(
        locationService.latitude.value,
        locationService.longitude.value,
      )) {
        final coords = await LocationGuard.ensureCoordinates(
          showSnackbar: false,
          allowSavedFallback: true,
          preferSaved: true,
        );
        if (coords != null) {
          locationService.apply(coords.lat, coords.lng);
        }
      }

      final cityId = _cityIdForApi();

      if (!LocationGuard.isValid(
        locationService.latitude.value,
        locationService.longitude.value,
      )) {
        quoteFailed.value = true;
        _promptChooseLocation();
        _applyDeliveryFee(0);
        return;
      }

      final pickup = await _resolvePickupCoordinates();
      if (pickup == null) {
        quoteFailed.value = true;
        ErrorMessage.SnackMessage(
          'تعذر تحديد موقع المطعم',
          Colors.red[400]!,
        );
        _applyDeliveryFee(0);
        return;
      }

      final restaurantId = RestaurantIdResolver.fromCartOrProfile();
      if (restaurantId <= 0) {
        quoteFailed.value = true;
        _applyDeliveryFee(0);
        return;
      }

      final api = ApiClient(token: box.read('token')?.toString());
      try {
        final quote = await fetchDeliveryQuote(
          api,
          restaurantId: restaurantId,
          cityId: cityId,
          pickupLat: pickup.lat,
          pickupLng: pickup.lng,
          dropoffLat: locationService.latitude.value,
          dropoffLng: locationService.longitude.value,
        );
        lastQuote.value = quote;
        _applyDeliveryFee(quote.total.round());
        return;
      } on Exception catch (e) {
        debugPrint('pricing/quote failed: $e');
      }

      await _applyDeliveryFeeFallback(restaurantId, cityId);
      if (!quoteFailed.value) return;

      quoteFailed.value = true;
      ErrorMessage.SnackMessage(
        'تعذر حساب كلفة التوصيل',
        Colors.red[400]!,
      );
      _applyDeliveryFee(0);
    } catch (_) {
      quoteFailed.value = true;
      ErrorMessage.SnackMessage(
        'تعذر حساب كلفة التوصيل',
        Colors.red[400]!,
      );
      _applyDeliveryFee(0);
    } finally {
      islodedQuote.value = false;
      isPricingReady.value = true;
      update();
    }
  }

  Future<void> sendorder() async {
    if (islodedbtnsend.value) return;
    if (!meetsMinOrder) {
      ErrorMessage.SnackMessage(
        'الحد الأدنى للطلب ${OrderStatusHelper.formatIqd(minOrderAmount)}',
        Colors.orange[400]!,
      );
      return;
    }
    if (!canSubmitOrder) {
      if (islodedQuote.value) {
        ErrorMessage.SnackMessage(
          'جاري حساب المبالغ، انتظر قليلاً...',
          Colors.orange[400]!,
        );
      } else if (!LocationStorage.coverageVerified || !_hasDropoffPin) {
        _promptChooseLocation();
      } else if (totalprice.value <= 0) {
        ErrorMessage.SnackMessage(
          'تعذر حساب مبلغ الطلب',
          Colors.red[400]!,
        );
      } else {
        ErrorMessage.SnackMessage(
          'يرجى تحديد الموقع وحساب التكلفة قبل الإرسال',
          Colors.orange[400]!,
        );
      }
      return;
    }
    if (ListItemCard.itemscard.isEmpty) {
      ErrorMessage.SnackMessage('السلة فارغة', Colors.red[400]!);
      return;
    }
    islodedbtnsend.value = true;
    try {
      final restaurantId = RestaurantIdResolver.fromCartOrProfile();
      if (restaurantId <= 0) {
        ErrorMessage.SnackMessage(
            'تعذر تحديد المطعم، ارجع للمطعم وأضف المنتجات من جديد',
            Colors.red[400]!);
        islodedbtnsend.value = false;
        return;
      }
      RestaurantIdResolver.patchCartRestaurantIds(restaurantId);

      if (!LocationStorage.coverageVerified) {
        _promptChooseLocation();
        islodedbtnsend.value = false;
        return;
      }

      locationService.hydrateFromStorage();
      final coords = await LocationGuard.ensureCoordinates(
        showSnackbar: false,
        allowSavedFallback: true,
        preferSaved: true,
      );
      if (coords != null) {
        locationService.apply(coords.lat, coords.lng);
      }
      if (!LocationGuard.isValid(
        locationService.latitude.value,
        locationService.longitude.value,
      )) {
        ErrorMessage.SnackMessage(
          'يجب تفعيل الموقع قبل إرسال الطلب',
          Colors.orange[400]!,
        );
        _promptChooseLocation();
        islodedbtnsend.value = false;
        return;
      }
      await LocationStorage.save(
        locationService.latitude.value,
        locationService.longitude.value,
        zoneId: LocationStorage.zoneId,
        zoneName: LocationStorage.zoneName,
      );

      cityvalue.value = _cityIdForApi();

      var total = ListItemCard.itemscard
          .map((item) => item.unitPrice * item.count)
          .fold<double>(0, (sum, line) => sum + line);
      userId.value = box.read('UserId') ?? 0;

      var latitude = locationService.latitude.value;
      var longitude = locationService.longitude.value;
      UsersModel userinfo = UsersModel(
          userId: userId.value,
          Address:'', //addressController.text,
          Phone: '', //phoneController.text,
          Name: '', //nameController.text,
          FunctionPoint:'',// pointController.text,
          Lat: latitude.toString(),
          Long: longitude.toString(),
          CityId:cityvalue.value);
      var ordersend = OrdersModel(
          orderDate: DateTime.now(),
          functionPoint: userinfo.FunctionPoint,
          restaurantId: restaurantId,
          total: total,
          userId: userId.value,
          notes: noteController.text,
          promoCode: promocodeController.text,
          costDelivery: costDelivery.value.toDouble(),
          totalDiscount: discountprice.value,
          netAmount: netAmount.value,
          orderDetails: ListItemCard.itemscard,
          usersModel: userinfo);
      var body = jsonEncode(ordersend.toJson());
      var response = await OrderApiHttp.post(
          Uri.https(AppLink.apiUrl, AppLink.sendOrder),
          headers: {'Content-Type': 'application/json'},
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        if (data['success'] == false) {
          final msg = data['msg']?.toString() ??
              'حدث خطا اثناء عملية جلب البيانات';
          ErrorMessage.SnackMessage(msg, Colors.red[400]!);
          islodedbtnsend.value = false;
          return;
        } else {
          final result = data['data'];
          // created order id available in result if needed later
          if (result != null) {
            // ignore unused parse — we navigate to orders list instead of tracking
          }

          ListItemCard.itemscard.clear();
          if (Get.isRegistered<AppBadgeController>()) {
            Get.find<AppBadgeController>().refreshCart();
          }
          await _myOrderController.fetchData();

          Get.offAll(
            () => const MainApp(),
            arguments: {'tab': 2},
            duration: const Duration(milliseconds: 300),
            transition: Transition.fade,
          );
          ErrorMessage.SnackMessage(
              'تم الحفظ طلبك سيتم الموافقة على طلبك باسرع وقت ممكن',
              Colors.green[400]!);
          islodedbtnsend.value = false;
          return;
        }
      } else {
        ErrorMessage.SnackMessage(
            'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);

        islodedbtnsend.value = false;
        return;
      }
    } catch (ex) {
      ErrorMessage.SnackMessage(
          'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
      return;
    } finally {
      islodedbtnsend.value = false;
    }
  }

  Future<void> SumPrice() async {
    try {
      netAmount.value = 0;
      totalprice.value = 0;
      discountprice.value = 0;
      if (ListItemCard.itemscard.isEmpty) return;

      final subtotal = ListItemCard.itemscard
          .map((item) => item.unitPrice * item.count)
          .fold<double>(0, (sum, line) => sum + line);

      // Prefer the absolute discount returned by backend (which already
      // honors max-discount caps); else fall back to the percentage.
      if (promoApplied.value && promoDiscountAmount.value > 0) {
        discountprice.value = promoDiscountAmount.value;
      } else {
        discountprice.value = (subtotal * discount.value) / 100;
      }

      final delivery = costDelivery.value;
      netAmount.value =
          (subtotal - discountprice.value + delivery).clamp(0, double.infinity);
      totalprice.value = subtotal;
    } finally {
      update();
    }
  }
}
