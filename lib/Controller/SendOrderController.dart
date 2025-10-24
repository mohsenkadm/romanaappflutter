import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:romanaappflutter/Model/RestaurantCityModel.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';
import 'package:romanaappflutter/linkapi.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/views/ChooseLocation.dart';
import 'package:romanaappflutter/views/MainApp.dart';
import 'package:romanaappflutter/views/login.dart';

import '../Model/PromoCodeModel.dart';

class SendOrderController extends GetxController {
  RxBool isloded = true.obs;
  RxBool islodedbtn = false.obs;
  RxBool islodedbtnsend = false.obs;
  RxDouble netAmount = 0.0.obs;
  RxDouble totalprice = 0.0.obs;
  RxDouble discountprice = 0.0.obs;
  RxInt discount = 0.obs;
  RxInt costDelivery = 0.obs;
  var cityvalue=0.obs;
  // final nameController = TextEditingController();
  // final phoneController = TextEditingController();
  // final addressController = TextEditingController();
  // final pointController = TextEditingController();
  final noteController = TextEditingController();
  final promocodeController = TextEditingController();
  var userId = 0.obs;
  final box = GetStorage();
  final MyOrderController _myOrderController = Get.find<MyOrderController>();

  final determinePositionLocation locationService =
      Get.put(determinePositionLocation());
      
  @override
  Future<void> onInit() async {
    super.onInit();
    await locationService.getCurrentLocation();
     userId.value = box.read('UserId') ?? 0;
   // getinfo();
    getcostDeliveryRes();
    SumPrice();
  }

  @override
  void onClose() {
    // nameController.dispose();
    // phoneController.dispose();
    // addressController.dispose();
    // pointController.dispose();
    noteController.dispose();
    promocodeController.dispose();
  }

  Future<void> getcostDeliveryRes() async {
    try {
      final response = await http.get(Uri.https(
          AppLink.apiUrl,
          AppLink.RestaurantCityGetByResId +
              '/' +
              ListItemCard.itemscard.first.restaurantId.toString()));
      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['success'] == false) {
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
          return;
        }
        var data = result['data'];

        var restaurantCityModel =
            data.map((json) => RestaurantCityModel.fromJson(json)).toList();
        if (restaurantCityModel != null) {
          int cityid = int.parse(box.read("selectcity") ?? "0");
          if (cityid == 0) {
            AwesomeDialog(
                    buttonsBorderRadius:
                        const BorderRadius.all(Radius.circular(5)),
                    context: Get.context!,
                    dialogType: DialogType.warning,
                    headerAnimationLoop: true,
                    animType: AnimType.bottomSlide,
                    title: 'تحديد المنطقة',
                    reverseBtnOrder: true,
                    showCloseIcon: true,
                    btnOkText: 'نعم',
                    btnCancelText: 'الغاء',
                    btnOkIcon: Icons.check_circle,
                    btnCancelIcon: Icons.cancel,
                    btnOkOnPress: () {
                      Get.to(const ChooseLocation());
                    },
                    desc: 'يجب تحديد موقعك الحالي')
                .show();
            //return;
          }
          costDelivery.value = restaurantCityModel
              .firstWhere((element) => element.CityId == cityid)
              .costDelivery!;
          SumPrice();
          update();
        }
      } else {
        ErrorMessage.error();
      }
    } catch (ex) {
      ErrorMessage.error();
    }
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
    try {
      if (promocodeController.text.isNotEmpty) {
        final response =
            await http.get(Uri.https(AppLink.apiUrl, AppLink.getPromoCode));
        if (response.statusCode == 200) {
          final result = json.decode(response.body);
          if (result['success'] == false) {
            ErrorMessage.SnackMessage(
                'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
            return;
          }
          var data = result['data'];
          var promocode =
              data.map((json) => PromoCodeModel.fromJson(json)).toList();
          PromoCodeModel code = promocode.firstWhere(
              (person) =>
                  person.PromoName ==
                  promocodeController
                      .text, // Replace this condition with your specific condition
              orElse: () =>
                  PromoCodeModel(Percentage: 0, PromoName: '', PromoCodeId: 0));
          if (code.PromoCodeId > 0) {
            discount.value = code.Percentage;
            SumPrice();
            update();
            ErrorMessage.SnackMessage(
                code.Percentage.toString() + 'تم خصم من طلبك بنسبة',
                Colors.green[400]!);
          } else {
            ErrorMessage.SnackMessage('لا يوجد كود خصم', Colors.green[400]!);
          }
        } else {
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
        }
      }
    } catch (ex) {
      ErrorMessage.SnackMessage(
          'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
    } finally {
      islodedbtn.value = false;
    }
  }

  Future<void> sendorder() async {
    if (islodedbtnsend.value) return;
    islodedbtnsend.value = true;
    try {
      var firsrow = ListItemCard.itemscard.first;
      var total = ListItemCard.itemscard
          .map((item) => item.price! * item.count)
          .reduce((ele1, ele2) => ele1 + ele2);
      userId.value = box.read('UserId') ?? 0;

      var latitude = locationService.latitude.value;
      var longitude = locationService.longitude.value;
       cityvalue.value = int.parse(box.read("selectcity") ?? "0");
   if(cityvalue.value==0){
    AwesomeDialog(
                  buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
                  context: Get.context!,
                  dialogType: DialogType.warning,
                  headerAnimationLoop: true,
                  animType: AnimType.bottomSlide,
                  title: 'تحديد المنطقة',
                  reverseBtnOrder: true,
                  showCloseIcon: true,
                  btnOkText: 'نعم',
                  btnCancelText: 'الغاء',
                  btnOkIcon: Icons.check_circle,
                  btnCancelIcon: Icons.cancel,
                  btnOkOnPress: () {
                   Get.to(const ChooseLocation());
                  }, 
                  desc:'يجب تحديد موقعك الحالي')
              .show();
              //return;
   }
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
          restaurantId: firsrow.restaurantId,
          total: total,
          userId: userId.value,
          notes: noteController.text,
          promoCode: promocodeController.text,
          costDelivery:double.tryParse(costDelivery.value.toString()),
          totalDiscount: discountprice.value,
          netAmount: netAmount.value,
          orderDetails: ListItemCard.itemscard,
          usersModel: userinfo);
      var body = jsonEncode(ordersend.toJson());
      var response = await http.post(
          Uri.https(AppLink.apiUrl, AppLink.sendOrder),
          headers: {'Content-Type': 'application/json'},
          body: body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        if (data['success'] == false) {
          ErrorMessage.SnackMessage(
              'حدث خطا اثناء عملية جلب البيانات', Colors.red[400]!);
          islodedbtnsend.value = false;
          return;
        } else {
          var result = data['data'];

          // await box.write('UserId',result['userId']);
          // print(result['userId'].toString());
          // OneSignal.login(result['userId'].toString());
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
    // try{
    //   //  await box.write('Name',nameController.text.isEmpty?'':nameController.text);
    //   // await box.write('Phone',phoneController.text.isEmpty?'':phoneController.text);
    //   // await  box.write('Address',addressController.text.isEmpty?'':addressController.text);
    //   // await  box.write('FunctionPoint',pointController.text.isEmpty?'':pointController.text);
    //    }
    //    catch(ex)
    //    {
    //      ErrorMessage.SnackMessage(ex.toString(),Colors.black);
    //    }
    ListItemCard.itemscard.clear();
    await _myOrderController.fetchData();
    Get.offAll(const MainApp(),
        duration: const Duration(milliseconds: 500),
        transition: Transition.fade);
    ErrorMessage.SnackMessage(
        'تم الحفظ طلبك سيتم الموافقة على طلبك باسرع وقت ممكن',
        Colors.green[400]!);

    islodedbtnsend.value = false;
  }

  Future<void> SumPrice() async {
    try {
      netAmount.value = 0;
      totalprice.value = 0;
      discountprice.value = (ListItemCard.itemscard
                  .map((item) => item.price! * item.count)
                  .reduce((ele1, ele2) => ele1 + ele2) *
              discount.value) /
          100;

      netAmount.value = (ListItemCard.itemscard
              .map((item) => item.price! * item.count)
              .reduce((ele1, ele2) => ele1 + ele2) -
          discountprice.value +
          costDelivery.value);
      totalprice.value = ListItemCard.itemscard
          .map((item) => item.price! * item.count)
          .reduce((ele1, ele2) => ele1 + ele2);
    } finally {}
  }
}
