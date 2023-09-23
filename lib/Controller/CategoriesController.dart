import 'package:get/get.dart';
import 'package:romanaappflutter/Model/CategoriesModel.dart';
import 'package:romanaappflutter/views/Category.dart'; 

class CategoriesController extends GetxController {
   
   var itemscategories=[].obs;
   
   RxBool isloded=true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }


  Future<void> fetchData() async {
    
    isloded.value=true;
    await Future.delayed(Duration(seconds: 4));
    itemscategories.add(CategoriesModel( 1, 'assets/images/img1.png','مطاعم'));
    itemscategories.add(CategoriesModel( 2, 'assets/images/img2.png', 'اسواق'));
    itemscategories.add(CategoriesModel( 3, 'assets/images/img3.png', 'محلات'));
    
    isloded.value=false;
  }
}