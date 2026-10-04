import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Constant/restaurant_id_resolver.dart';
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/Model/ProductIngredientModel.dart';
import 'package:romanaappflutter/Model/ProductSizeModel.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/RestaourantProfile.dart';
import 'package:romanaappflutter/views/login.dart';

class ProductController extends GetxController {
  final item = ProductsModel().obs;
  /// Report0002: default qty=1 so «إضافة للسلة» works without pressing +.
  RxInt count = 1.obs;
  RxBool isloded = true.obs;
  RxBool isSizesLoading = false.obs;
  RxBool isIngredientsLoading = false.obs;
  var itemprod = [].obs;
  var itemsCarousel = [].obs;
  var currentIndex = 0.obs;

  // Sizes & ingredients
  RxList<ProductSizeModel> sizes = <ProductSizeModel>[].obs;
  RxList<ProductIngredientModel> ingredients = <ProductIngredientModel>[].obs;
  Rx<ProductSizeModel?> selectedSize = Rx<ProductSizeModel?>(null);
  RxList<ProductIngredientModel> selectedIngredients = <ProductIngredientModel>[].obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  final noteController = TextEditingController();

  void toggleIngredient(ProductIngredientModel ingredient) {
    if (selectedIngredients.any((i) => i.productIngredientId == ingredient.productIngredientId)) {
      selectedIngredients.removeWhere((i) => i.productIngredientId == ingredient.productIngredientId);
    } else {
      selectedIngredients.add(ingredient);
    }
  }

  Future<void> fetchSizes(int productId) async {
    isSizesLoading.value = true;
    try {
      final response = await http.get(
          Uri.https(AppLink.apiUrl, AppLink.getSizesByProductId + productId.toString()));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final data = result['data'];
        if (data != null && data is List) {
          sizes.value = data.map((j) => ProductSizeModel.fromJson(j)).toList();
        }
      }
    } catch (_) {
    } finally {
      isSizesLoading.value = false;
    }
  }

  Future<void> fetchIngredients(int productId) async {
    isIngredientsLoading.value = true;
    try {
      final response = await http.get(
          Uri.https(AppLink.apiUrl, AppLink.getIngredientsByProductId + productId.toString()));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        final data = result['data'];
        if (data != null && data is List) {
          ingredients.value = data.map((j) => ProductIngredientModel.fromJson(j)).toList();
        }
      }
    } catch (_) {
    } finally {
      isIngredientsLoading.value = false;
    }
  }

  Future<void> fetchDataProduct({String searchprod = ""}) async {
    isloded.value = true;
    try {
      var s = searchprod.isEmpty ? '%,1' : '$searchprod,1';
      final response = await http
          .get(Uri.https(AppLink.apiUrl, AppLink.getProductsallBySearch + s));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == false) {
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
          isloded.value = false;
          return;
        }
        var data = result['data'];
        itemprod.value =
            data.map((json) => ProductsModel.fromJson(json)).toList();
      } else {
        ErrorMessage.error;
      }
    } finally {
      isloded.value = false;
    }
  }

  void backToRestourantprofile() {
    if (ListItemCard.itemscard.isNotEmpty) {
      Get.to(const RestaourantProfile(),
          arguments: [item.value.RestaurantId.toString()],
          duration: const Duration(milliseconds: 500),
          transition: Transition.fade);
    } else {
      navigator?.pop();
    }
  }

  bool containsBothRestaurantIds(List<OrderDetailModel> cards, int newresid) {
    for (var card in cards) {
      if (card.restaurantId != newresid) {
        return true;
      }
    }
    return false;
  }

  final box = GetStorage();

  /// Returns true if validation passed and item was added/updated.
  bool AddToListCard(ProductsModel data) {
    var userId = box.read('UserId') ?? 0;
    if (userId == 0) {
      AwesomeDialog(
              buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
              context: Get.context!,
              dialogType: DialogType.warning,
              headerAnimationLoop: true,
              animType: AnimType.bottomSlide,
              title: 'تسجيل الدخول',
              reverseBtnOrder: true,
              showCloseIcon: true,
              btnOkText: 'نعم',
              btnCancelText: 'الغاء',
              btnOkIcon: Icons.check_circle,
              btnCancelIcon: Icons.cancel,
              btnOkOnPress: () {
                Get.to(const Login(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
              },
              desc:
                  'يجب تسجيل حساب جديد او تسجيل دخول للتطبيق لتتمكن من اضافة طلبك')
          .show();
      return false;
    }

    if (count.value <= 0) count.value = 1;

    // Validate size selection if sizes exist
    if (sizes.isNotEmpty && selectedSize.value == null) {
      ErrorMessage.SnackMessage('يرجى اختيار الحجم أولاً', Colors.orange[700]!);
      return false;
    }

    var para = Get.arguments;
    if (para != null) {
      var id = int.parse(para[0]);
      final resId = RestaurantIdResolver.fromProductId(data.RestaurantId);
      if (resId <= 0) {
        ErrorMessage.SnackMessage(
            'تعذر تحديد المطعم', Colors.red[400]!);
        return false;
      }
      if (containsBothRestaurantIds(ListItemCard.itemscard, resId)) {
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
                },
                btnCancelOnPress: () {},
                desc: 'لا يمكن الطلب اكثر من مطعم  هل تريد حذف السلة  ؟')
            .show();
        return false;
      }

      // Build ingredient string
      final String? ingredientsStr = selectedIngredients.isEmpty
          ? null
          : selectedIngredients.map((i) => i.ingredientName).join(',');

      // Effective price = base price + size price
      final double basePrice = double.parse(data.ProductsPrice!.toString());
      final double effectivePrice = basePrice + (selectedSize.value?.sizePrice ?? 0.0);

      bool checkprod = ListItemCard.itemscard.any((element) => element.productsId == id);
      if (!checkprod) {
        ListItemCard.itemscard.add(OrderDetailModel(
            orderDetailId: 0,
            orderId: 0,
            productsId: data.ProductsId!,
            price: effectivePrice,
            count: count.value,
            total: 0,
            notes2: noteController.text,
            productsName: data.ProductsName!,
            productsDetails: data.ProductsDetails.toString(),
            productsImage: data.productsImageFirst!,
            subCategoriesName: data.SubCategoriesName!,
            restaurantId: resId,
            selectedSizeId: selectedSize.value?.productSizeId,
            selectedSizeName: selectedSize.value?.sizeName,
            selectedSizePrice: selectedSize.value?.sizePrice,
            selectedIngredients: ingredientsStr));
        ErrorMessage.SnackMessage('تمت الاضافة الى السلة', Colors.green[400]!);
        if (Get.isRegistered<AppBadgeController>()) {
          Get.find<AppBadgeController>().refreshCart();
        }
      } else {
        var indexitem = ListItemCard.itemscard
            .indexWhere((element) => element.productsId == id);
        if (indexitem != -1) {
          ListItemCard.itemscard[indexitem].count = count.value;
          ListItemCard.itemscard[indexitem].notes2 = noteController.text;
          ListItemCard.itemscard[indexitem].price = effectivePrice;
          ListItemCard.itemscard[indexitem].selectedSizeId = selectedSize.value?.productSizeId;
          ListItemCard.itemscard[indexitem].selectedSizeName = selectedSize.value?.sizeName;
          ListItemCard.itemscard[indexitem].selectedSizePrice = selectedSize.value?.sizePrice;
          ListItemCard.itemscard[indexitem].selectedIngredients = ingredientsStr;
        }
        ErrorMessage.SnackMessage('تم تحديث المنتج في السلة', Colors.green[400]!);
        if (Get.isRegistered<AppBadgeController>()) {
          Get.find<AppBadgeController>().refreshCart();
        }
      }
      return true;
    }
    return false;
  }

  Future<void> fetchData() async {
    count.value = 1;
    sizes.clear();
    ingredients.clear();
    selectedSize.value = null;
    selectedIngredients.clear();
    isloded.value = true;
    try {
      var data = Get.arguments;
      if (data != null) {
        var id = data[0].toString();
        final response = await http
            .get(Uri.https(AppLink.apiUrl, AppLink.getProductsById + id));
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['success'] == false) {
            ErrorMessage.SnackMessage(
                'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
            isloded.value = false;
            return;
          }
          var data = result['data'];
          item.value = ProductsModel.fromJson(
            data as Map<String, dynamic>,
            fallbackRestaurantId: RestaurantIdResolver.fromProfileContext(),
          );
          if (ListItemCard.itemscard.isNotEmpty) {
            var first = ListItemCard.itemscard.firstWhereOrNull(
                (element) => element.productsId == int.tryParse(id));
            if (first != null) {
              count.value = first.count;
              noteController.text = first.notes2.toString();
            }
          }
          if (item.value.Images != null) {
            itemsCarousel.value = item.value.Images!.toList();
          }
          // Fetch sizes and ingredients in parallel
          final pid = item.value.ProductsId;
          if (pid != null) {
            await Future.wait([fetchSizes(pid), fetchIngredients(pid)]);
          }
        } else {
          ErrorMessage.error;
        }
      }
    } catch (ex) {
      ErrorMessage.error;
    } finally {
      isloded.value = false;
    }
  }
}
