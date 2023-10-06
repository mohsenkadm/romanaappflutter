import 'package:get/get.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart'; 

class RestourentController extends GetxController {
   
   var itemsres=[].obs;
   
   RxBool isloded=true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData(); // Fetch data when the controller is initialized
  }


  Future<void> fetchData() async {
      try{ 
     await  Future.delayed(const Duration(seconds: 5));
itemsres.add(RestaurantModel(restaurantId: 1, name: 'name', details: 'details', address: 'address', 
logo: 'https://source.unsplash.com/user/c_v_r/500x200', background: 'https://images.unsplash.com/photo-1608231975456-2f2d9fb1b49b?crop=entropy&cs=tinysrgb&fit=crop&fm=jpg&h=200&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTY5NjM3MTQ2MQ&ixlib=rb-4.0.3&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=500',
 phone: 'phone', lat: 'lat', long: 'long',
 code: 'code', whatsapp: '0770', starCount: 5, isClosed: false, isStars: true,
 minimumPrice: 5000, areaname: 'areaname', categoriesId: 1, categoriesName: 'categoriesName'));
    }
    finally{
    isloded.value=false; 
    }
  }
}