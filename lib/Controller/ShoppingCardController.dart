
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/views/login.dart';  

// ignore: camel_case_types
class ShoppingCardController extends GetxController{
 
  RxBool isloded=true.obs; 
  RxDouble totalprice=0.0.obs;  
  @override
  void onInit() {
    super.onInit();
   fetchData(); // Fetch data when the controller is initialized 
  }
  /// يحدّث المبلغ الكلي من عناصر السلة ويُعيد رسم الواجهة.
  void SumPrice() {
    if (ListItemCard.itemscard.isEmpty) {
      totalprice.value = 0;
    } else {
      totalprice.value = ListItemCard.itemscard
          .map((item) => item.unitPrice * item.count)
          .fold<double>(0, (sum, line) => sum + line);
    }
    update();
  }

   Future<void> ClearCard() async{
     ListItemCard.itemscard.clear();
    SumPrice();
    _refreshBadge();
    update();
  }

  void _refreshBadge() {
    if (Get.isRegistered<AppBadgeController>()) {
      Get.find<AppBadgeController>().refreshCart();
    }
  }

  final box = GetStorage();
  Future<void> DeIncrement(int index) async{
    var userId= box.read('UserId') ?? 0;
    if(userId==0)
    {
       AwesomeDialog(
                    buttonsBorderRadius:
                        const BorderRadius.all(Radius.circular(5)),
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
                    desc: 'يجب تسجيل حساب جديد او تسجيل دخول للتطبيق لتتمكن من اضافة طلبك')
                .show();
    }
    else {
    
    ListItemCard.itemscard[index].count -= 1;
    ListItemCard.itemscard[index].total = ListItemCard.itemscard[index].count * ListItemCard.itemscard[index].unitPrice;
     if (ListItemCard.itemscard[index].count == 0) {
          AwesomeDialog(
                  buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
                  context: Get.context!,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: true,
                  animType: AnimType.bottomSlide,
                  title: 'حذف المنتج',
                  reverseBtnOrder: true,
                  showCloseIcon: true,
                  btnOkText: 'نعم',
                  btnCancelText: 'الغاء',
                  btnOkIcon: Icons.check_circle,
                  btnCancelIcon: Icons.cancel,
                  btnOkOnPress: () {
                    ListItemCard.itemscard.removeAt(index);
                    _refreshBadge();
                    SumPrice();
                    update();
                  },
                  btnCancelOnPress: () {
                    ListItemCard.itemscard[index].count += 1;
                    ListItemCard.itemscard[index].total =
                        ListItemCard.itemscard[index].count *
                            ListItemCard.itemscard[index].unitPrice;
                    _refreshBadge();
                    SumPrice();
                    update();
                  },
                  desc: 'هل تريد حذف المنتج حقا؟')
              .show();
        } else {
          _refreshBadge();
          update();
        }
       SumPrice();
    }
  }
  
   Future<void> Increment(int index) async{
     var userId= box.read('UserId') ?? 0;
     if(userId==0)
    {
       AwesomeDialog(
                    buttonsBorderRadius:
                        const BorderRadius.all(Radius.circular(5)),
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
                    desc: 'يجب تسجيل حساب جديد او تسجيل دخول للتطبيق لتتمكن من اضافة طلبك')
                .show();
    }
    else {
      
    ListItemCard.itemscard[index].count += 1;
    ListItemCard.itemscard[index].total = ListItemCard.itemscard[index].count * ListItemCard.itemscard[index].unitPrice;
    _refreshBadge();
   update();
       SumPrice();
    }
  }
  
  Future<void> fetchData() async {
    isloded.value = true;
    try {
      SumPrice();
    } finally {
      isloded.value = false;
    }
  }
}