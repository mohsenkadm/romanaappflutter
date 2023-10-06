
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart'; 
import 'package:romanaappflutter/Model/OrderDetailModel.dart'; 

// ignore: camel_case_types
class ShoppingCardController extends GetxController{
 
  RxBool isloded=true.obs;
  RxDouble netAmount=0.0.obs;
  RxDouble totalprice=0.0.obs;
  RxDouble discount=0.0.obs;
  @override
  void onInit() {
    super.onInit();
   fetchData(); // Fetch data when the controller is initialized
  }
  Future<void> SumPrice() async{
    try{
    netAmount.value=0;
    } 
    finally{
      
    }
  }
   Future<void> ClearCard() async{
    netAmount.value=0; 
     ListItemCard.itemscard.clear();
  }
  Future<void> UpdateCount(int prodid,int count) async{
    
  }
  
  Future<void> fetchData() async {
    try{ 
     await  Future.delayed(Duration(seconds: 5));
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
    }
    finally{
    isloded.value=false; 
    }
  }
}