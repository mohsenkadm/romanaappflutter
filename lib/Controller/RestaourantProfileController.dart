import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/Model/SubCategoriesModel.dart';
import 'package:romanaappflutter/linkapi.dart';

class ProductSection {
  const ProductSection({
    required this.subId,
    required this.title,
    required this.products,
  });

  final int subId;
  final String title;
  final List<ProductsModel> products;
}

class RestaourantProfileController extends GetxController {
  RestaourantProfileController({required this.resId});

  final String resId;

  /// من الـ API: الأكثر طلباً/مبيعاً — `subCategoriesId` يكون 0 أو -1.
  static const int mostOrderedSubId = 0;
  static const int mostOrderedSubIdAlt = -1;
  static const int topSellingTake = 4;

  static bool isMostOrderedSubId(int subId) =>
      subId == mostOrderedSubId || subId == mostOrderedSubIdAlt;

  RxBool isloded = true.obs;
  RxBool islodedprod = false.obs;
  RxBool islodedsub = true.obs;

  final item = RestaurantModel().obs;
  final itemprod = <ProductsModel>[].obs;
  final itemSubCategory = <SubCategoriesModel>[].obs;

  final SubIdActive = 0.obs;
  final searchQuery = ''.obs;
  final sectionsLoading = false.obs;
  final catalogRevision = 0.obs;

  /// Called from the view to scroll to a category section.
  void Function(int subId)? onSectionScrollRequest;

  final _productCache = <String, List<ProductsModel>>{};
  Timer? _searchDebounce;
  int _fetchGeneration = 0;

  String get _restaurantId => resId;

  bool _isMenuSubId(int subId) =>
      isMostOrderedSubId(subId) || subId > 0;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }

  String _cacheKey(int subId, String search) =>
      '$_restaurantId|$subId|${search.trim()}';

  List<ProductsModel> get displayedProducts => itemprod;

  bool get isSearchActive => searchQuery.value.trim().isNotEmpty;

  List<ProductSection> get productSections {
    if (isSearchActive) {
      if (itemprod.isEmpty) return const [];
      return [
        ProductSection(
          subId: -100,
          title: 'نتائج البحث',
          products: itemprod.toList(growable: false),
        ),
      ];
    }

    final sections = <ProductSection>[];
    for (final sub in itemSubCategory) {
      final subId = sub.SubCategoriesId;
      if (!_isMenuSubId(subId)) continue;
      final cached = _productCache[_cacheKey(subId, '')];
      if (cached == null || cached.isEmpty) continue;
      sections.add(ProductSection(
        subId: subId,
        title: sub.SubCategoriesName,
        products: List<ProductsModel>.from(cached, growable: false),
      ));
    }
    return sections;
  }

  void OnClose() {
    if (ListItemCard.itemscard.isNotEmpty) {
      AwesomeDialog(
        buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
        context: Get.context!,
        dialogType: DialogType.warning,
        headerAnimationLoop: true,
        animType: AnimType.bottomSlide,
        title: 'حذف السلة',
        reverseBtnOrder: true,
        showCloseIcon: true,
        btnOkText: 'نعم',
        btnCancelText: 'الغاء',
        btnOkIcon: Icons.check_circle,
        btnCancelIcon: Icons.cancel,
        btnOkOnPress: () {
          ListItemCard.itemscard.clear();
          if (Get.isRegistered<AppBadgeController>()) {
            Get.find<AppBadgeController>().refreshCart();
          }
          navigator?.pop();
        },
        btnCancelOnPress: () {},
        desc: 'اذا قمت الخروج من المطعم سيتم حذف السلة هل تريد حذفها؟',
      ).show();
    } else {
      navigator?.pop();
    }
  }

  Future<void> fetchData({bool forceRefresh = false}) async {
    if (forceRefresh) _productCache.clear();
    isloded.value = true;
    try {
      final response = await http.get(
        Uri.https(
          AppLink.apiUrl,
          AppLink.getRestaurantById,
          {'Id': _restaurantId},
        ),
      );
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        item.value = RestaurantModel.fromJson(result['data']);
        await fetchDataSubCategory(forceRefresh: forceRefresh);
      } else {
        ErrorMessage.error();
      }
    } catch (_) {
      ErrorMessage.error();
    } finally {
      isloded.value = false;
    }
  }

  void ChooseSubCategory(int value) {
    _searchDebounce?.cancel();
    SubIdActive.value = value;

    if (isSearchActive) {
      if (_isMenuSubId(value)) {
        clearSearch();
        SubIdActive.value = value;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          onSectionScrollRequest?.call(value);
        });
        return;
      }
      fetchDataProductByRestaurantId(
        SubId: value,
        searchprod: searchQuery.value,
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      onSectionScrollRequest?.call(value);
    });
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      SubIdActive.value = -100;
      fetchDataProductByRestaurantId(SubId: 0, searchprod: query);
    });
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    searchQuery.value = '';
    _selectFirstCategory();
  }

  void _selectFirstCategory() {
    for (final sub in itemSubCategory) {
      if (_isMenuSubId(sub.SubCategoriesId)) {
        SubIdActive.value = sub.SubCategoriesId;
        return;
      }
    }
    SubIdActive.value = 0;
  }

  void updateActiveSectionFromScroll(int subId) {
    if (isSearchActive || SubIdActive.value == subId) return;
    SubIdActive.value = subId;
  }

  Future<void> fetchDataSubCategory({bool forceRefresh = false}) async {
    islodedsub.value = true;
    try {
      final response = await http.get(
        Uri.https(
          AppLink.apiUrl,
          AppLink.getRestaurantSubCategories + _restaurantId,
        ),
      );
      if (response.statusCode != 200) {
        ErrorMessage.error();
        return;
      }
      final result = json.decode(response.body);
      if (result['success'] == false) {
        ErrorMessage.SnackMessage(
          'حدث خطا اثناء عملية جلب البيانات',
          Colors.red[400]!,
        );
        return;
      }
      itemSubCategory
        ..clear()
        ..addAll(
          (result['data'] as List)
              .map((json) => SubCategoriesModel.fromJson(
                    json as Map<String, dynamic>,
                  )),
        );
      _selectFirstCategory();

      unawaited(prefetchAllSections(forceRefresh: forceRefresh));
    } finally {
      islodedsub.value = false;
    }
  }

  Future<void> prefetchAllSections({bool forceRefresh = false}) async {
    if (itemSubCategory.isEmpty) return;
    sectionsLoading.value = true;
    try {
      for (final sub in itemSubCategory) {
        final subId = sub.SubCategoriesId;
        if (!_isMenuSubId(subId)) continue;
        if (isMostOrderedSubId(subId)) {
          await fetchTopSelling(
            sectionSubId: subId,
            forceRefresh: forceRefresh,
          );
        } else {
          await fetchDataProductByRestaurantId(
            SubId: subId,
            silent: true,
            forceRefresh: forceRefresh,
          );
        }
      }
      catalogRevision.value++;
    } finally {
      sectionsLoading.value = false;
      catalogRevision.value++;
    }
  }

  /// الأكثر مبيعاً عبر `Products/GetTopSellingByRestaurant/{ResId}`.
  Future<void> fetchTopSelling({
    required int sectionSubId,
    int take = topSellingTake,
    bool forceRefresh = false,
  }) async {
    final key = _cacheKey(sectionSubId, '');
    if (!forceRefresh && _productCache.containsKey(key)) {
      itemprod.assignAll(_productCache[key]!);
      return;
    }
    try {
      final rid = int.tryParse(_restaurantId) ?? 0;
      if (rid == 0) return;
      final response = await http.get(
        Uri.https(
          AppLink.apiUrl,
          AppLink.topSellingByRestaurant(rid),
          {'take': take.toString()},
        ),
      );
      
      if (response.statusCode != 200) return;
      final result = json.decode(response.body);
      if (result['success'] != true) return;
      final data = result['data'] as List? ?? [];
      final parsed = data
          .map((j) => ProductsModel.fromJson(
                j as Map<String, dynamic>,
                fallbackRestaurantId: rid,
              ))
          .take(take)
          .toList(growable: false);
      _productCache[key] = parsed;
      itemprod.assignAll(parsed);
      catalogRevision.value++;
    } catch (_) {}
  }

  Future<void> fetchDataProductByRestaurantId({
    required int SubId,
    String searchprod = '',
    bool forceRefresh = false,
    bool silent = false,
  }) async {
    final search = searchprod.trim();
    final key = _cacheKey(SubId, search);

    if (!forceRefresh && _productCache.containsKey(key)) {
      itemprod.assignAll(_productCache[key]!);
      islodedprod.value = false;
      return;
    }

    final generation = ++_fetchGeneration;
    if (!silent && itemprod.isEmpty) {
      islodedprod.value = true;
    }

    try {
      final query = search.isEmpty ? ' ' : search;
      final apiSubId = search.isNotEmpty ? 0 : SubId;
      final response = await http.get(
        Uri.https(
          AppLink.apiUrl,
          '${AppLink.getProductsByRestaurantId}$_restaurantId,$apiSubId,$query',
        ),
      );
      if (generation != _fetchGeneration) return;
      if (response.statusCode != 200) {
        if (!silent) ErrorMessage.error();
        return;
      }

      final result = json.decode(response.body);
      if (result['success'] == false) {
        if (!silent) {
          ErrorMessage.SnackMessage(
            'حدث خطا اثناء عملية جلب البيانات',
            Colors.red[400]!,
          );
        }
        return;
      }

      final data = result['data'] as List? ?? [];
      final rid = int.tryParse(_restaurantId) ?? 0;
      final parsed = data
          .map((json) => ProductsModel.fromJson(
                json as Map<String, dynamic>,
                fallbackRestaurantId: rid,
              ))
          .toList(growable: false);

      _productCache[key] = parsed;
      if (generation == _fetchGeneration) {
        itemprod.assignAll(parsed);
        if (silent) catalogRevision.value++;
      }
    } catch (_) {
      if (!silent) ErrorMessage.error();
    } finally {
      if (generation == _fetchGeneration) {
        islodedprod.value = false;
      }
    }
  }
}
