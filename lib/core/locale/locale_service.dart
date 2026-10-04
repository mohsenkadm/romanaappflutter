import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_time_ago/get_time_ago.dart';

/// إدارة لغة التطبيق (عربي افتراضي) مع حفظ دائم على الجهاز.
class LocaleService extends GetxService {
  static const storageKey = 'app_locale';
  static const selectedFlagKey = 'locale_selected';

  final _box = GetStorage();
  final RxString code = 'ar'.obs;

  static LocaleService get to {
    if (Get.isRegistered<LocaleService>()) return Get.find<LocaleService>();
    return Get.put(LocaleService(), permanent: true);
  }

  bool get hasSelectedLocale => _box.read(selectedFlagKey) == true;

  Locale get locale => Locale(code.value);

  bool get isRtl => code.value == 'ar';

  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;

  @override
  void onInit() {
    super.onInit();
    final saved = _box.read(storageKey)?.toString();
    if (saved == 'en' || saved == 'ar') {
      code.value = saved!;
    } else {
      code.value = 'ar';
    }
    _applySideEffects(code.value);
  }

  Future<void> setLocale(String lang, {bool markSelected = true}) async {
    if (lang != 'ar' && lang != 'en') lang = 'ar';
    code.value = lang;
    await _box.write(storageKey, lang);
    if (markSelected) await _box.write(selectedFlagKey, true);
    Get.updateLocale(Locale(lang));
    _applySideEffects(lang);
  }

  void _applySideEffects(String lang) {
    GetTimeAgo.setDefaultLocale(lang == 'en' ? 'en' : 'ar');
  }

  String labelForCurrent() =>
      code.value == 'en' ? 'English' : 'العربية';
}
