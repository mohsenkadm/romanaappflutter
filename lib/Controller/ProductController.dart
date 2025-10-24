import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Model/ImagesModel.dart';
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/views/RestaourantProfile.dart';
import 'package:romanaappflutter/views/login.dart';

class ProductController extends GetxController {
  final item = ProductsModel().obs;
  RxInt count = 0.obs;
  RxBool isloded = true.obs;
  var itemprod = [].obs;

  var itemsCarousel = [].obs;
  var currentIndex = 0.obs;
  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  final noteController = TextEditingController();

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
      Get.back();
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
  Future<void> AddToListCard(ProductsModel data) async {
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
    } else {
      if (count.value == 0) return;
      var para = Get.arguments;
      if (para != null) {
        var id = int.parse(para[0]);
        if (containsBothRestaurantIds(
            ListItemCard.itemscard, data.RestaurantId!)) {
          AwesomeDialog(
                  buttonsBorderRadius:
                      const BorderRadius.all(Radius.circular(5)),
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
                  },
                  btnCancelOnPress: () {},
                  desc: 'لا يمكن الطلب اكثر من مطعم  هل تريد حذف السلة  ؟')
              .show();
          return;
        }
        bool checkprod =
            ListItemCard.itemscard.any((element) => element.productsId == id);
        if (!checkprod) {
          ListItemCard.itemscard.add(OrderDetailModel(
              orderDetailId: 0,
              orderId: 0,
              productsId: data.ProductsId!,
              price: double.parse(data.ProductsPrice!.toString()),
              count: count.value,
              total: 0,
              notes2: noteController.text,
              productsName: data.ProductsName!,
              productsDetails: data.ProductsDetails.toString(),
              productsImage: data.productsImageFirst!,
              subCategoriesName: data.SubCategoriesName!,
              restaurantId: data.RestaurantId!));
          ErrorMessage.SnackMessage(
              'تمت الاضافة الى السلة', Colors.green[400]!);
        } else {
          var indexitem = ListItemCard.itemscard
              .indexWhere((element) => element.productsId == id);
          if (indexitem != -1) {
            ListItemCard.itemscard[indexitem].count = count.value;
            ListItemCard.itemscard[indexitem].notes2 = noteController.text;
          }
          ErrorMessage.SnackMessage(
              'تمت الاضافة الى السلة سابقا', Colors.red[400]!);
        }
      }
    }
  }

  Future<void> fetchData() async {
    count.value = 0;
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

          item.value = ProductsModel.fromJson(data);
          if (ListItemCard.itemscard.isNotEmpty) {
            var first = ListItemCard.itemscard.firstWhereOrNull(
                (element) => element.productsId == int.tryParse(id));
            if (first != null) {
              count.value = first.count; 
              noteController.text = first.notes2.toString();
            }
          }
          if (item.value.Images != null)
            itemsCarousel.value = item.value.Images!.toList();
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
