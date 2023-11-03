
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart'; 
import 'package:romanaappflutter/Model/OrderDetailModel.dart'; 

// ignore: camel_case_types
class ShoppingCardController extends GetxController{
 
  RxBool isloded=true.obs; 
  RxDouble totalprice=0.0.obs;  
  @override
  void onInit() {
    super.onInit();
   fetchData(); // Fetch data when the controller is initialized
  }
  Future<void> SumPrice() async{
    try{ 
    totalprice.value= 0;
    
    totalprice.value= ListItemCard.itemscard.map((item) => item.price * item.count)
               .reduce((ele1, ele2) => ele1 + ele2);
    } 
    finally{
      
    }
  }

   Future<void> ClearCard() async{
     ListItemCard.itemscard.clear();
    SumPrice();

    update();
  }
  Future<void> DeIncrement(int index,BuildContext context) async{
    ListItemCard.itemscard[index].count -= 1;
    ListItemCard.itemscard[index].total = ListItemCard.itemscard[index].count * ListItemCard.itemscard[index].price;
     if (ListItemCard.itemscard[index].count == 0) {
          AwesomeDialog(
                  buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
                  context: context,
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
                   update();
                    Navigator.pop(context);
                  },
                  btnCancelOnPress: () {
                    ListItemCard.itemscard[index].count += 1;
                    update();
                  },
                  desc: 'هل تريد حذف المنتج حقا؟')
              .show();
        } else {  
          update(); 
        }
       SumPrice();
  }
  
   Future<void> Increment(int index,BuildContext context) async{
    ListItemCard.itemscard[index].count += 1;
    ListItemCard.itemscard[index].total = ListItemCard.itemscard[index].count * ListItemCard.itemscard[index].price;
   
   update();
       SumPrice();
  }
  
  Future<void> fetchData() async {
    try{  
     ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
   ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
   ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
   ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
     ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
     ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
     ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
     ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
    ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
    ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
    ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
    ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
    ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
    ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
    ListItemCard.itemscard.add(OrderDetailModel(orderDetailId: 0, orderId: 0, productsId: 1, 
     price: 100, count: 1, productsName: 'productsName', productsDetails: 'productsDetails', productsImage: 'https://source.unsplash.com/user/c_v_r/100x100',
      subCategoriesName: 'subCategoriesName', orderNo: 0, orderDate: DateTime.now(), restaurantId: 1, userId: 1, total: 10,
      totalDiscount: 10, netAmount: 10, isCancel: false, isApporve: false, isDone: false));
    //sum net amount
    SumPrice();
    update();
    }
    finally{
    isloded.value=false; 
    }
  }
}