import 'package:get/get.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/Model/SubCategoriesModel.dart';

class RestaourantProfileController extends GetxController{

   RxBool isloded=true.obs; 
   
  final item=Rxn(RestaurantModel);
 // var itemSubCategory=[].obs;
  @override
  void onInit(){
     fetchData() ;
     fetchDataSubCategory();
     super.onInit();
  }


  Future<void> fetchData() async { 
   await  Future.delayed(const Duration(seconds: 3)); 
      try{  
       item.value!=RestaurantModel(restaurantId: 0, name: 'name', details: 'details',
        address: 'address', logo: 'https://source.unsplash.com/user/c_v_r/100x100', 
        background: 'https://source.unsplash.com/user/c_v_r/500x200', phone: '0750',
         lat: 'lat', long: 'long', code: 'code', whatsapp: 'whatsapp', starCount:50, isClosed: false,
          isStars: true, minimumPrice: 0, areaname: 'areaname', categoriesId: 1, categoriesName: '')  ;
          //      final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getRestaurantTopAllForApp));
    // if(response.statusCode==200){
    //   final result=json.decode(response.body);
    //    var data = result['data'];
    //   itemsres.value= data.map((json) => RestaurantModel.fromJson(json)).toList();
    // }
    // else{
    //   throw Exception('');
    // }
    }
    finally{
    isloded.value=false; 
    }
  }

  Future<List<SubCategoriesModel>> fetchDataSubCategory() async {   
    List<SubCategoriesModel> itemSubCategory=[];
   await  Future.delayed(const Duration(seconds: 2)); 
      try{  
        itemSubCategory.add(SubCategoriesModel(SubCategoriesId: 1, SubCategoriesName: "اكلة ١"));
        itemSubCategory.add(SubCategoriesModel(SubCategoriesId: 1, SubCategoriesName: "اكلة ١"));
        itemSubCategory.add(SubCategoriesModel(SubCategoriesId: 1, SubCategoriesName: "اكلة ١"));
        itemSubCategory.add(SubCategoriesModel(SubCategoriesId: 1, SubCategoriesName: "اكلة ١"));
        itemSubCategory.add(SubCategoriesModel(SubCategoriesId: 1, SubCategoriesName: "اكلة ١"));
        itemSubCategory.add(SubCategoriesModel(SubCategoriesId: 1, SubCategoriesName: "اكلة ١"));
        itemSubCategory.add(SubCategoriesModel(SubCategoriesId: 1, SubCategoriesName: "اكلة ١"));
        itemSubCategory.add(SubCategoriesModel(SubCategoriesId: 1, SubCategoriesName: "اكلة ١"));
        //      final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getRestaurantTopAllForApp));
    // if(response.statusCode==200){
    //   final result=json.decode(response.body);
    //    var data = result['data'];
    //   itemsres.value= data.map((json) => RestaurantModel.fromJson(json)).toList();
    // }
    // else{
    //   throw Exception('');
    // }
    return itemSubCategory;
    }
    finally{ 
    }
  }
  
    Future<List<ProductsModel>> fetchDataProduct() async {   
    List<ProductsModel> itemprod=[];
   await  Future.delayed(const Duration(seconds: 2)); 
      try{  
        itemprod.add(ProductsModel(ProductsId: 1, ProductsName: 'ProductsName', ProductsDetails: 'ProductsDetails', 
        ProductsPrice: 10, RestaurantId: 1, SubCategoriesId: 1,
         SubCategoriesName: 'SubCategoriesName', RestaurantName: 'RestaurantName',
          ProductsImage: 'https://source.unsplash.com/user/c_v_r/100x100'));
        itemprod.add(ProductsModel(ProductsId: 1, ProductsName: 'ProductsName', ProductsDetails: 'ProductsDetails', 
        ProductsPrice: 10, RestaurantId: 1, SubCategoriesId: 1,
         SubCategoriesName: 'SubCategoriesName', RestaurantName: 'RestaurantName',
          ProductsImage: 'https://source.unsplash.com/user/c_v_r/100x100'));
        itemprod.add(ProductsModel(ProductsId: 1, ProductsName: 'ProductsName', ProductsDetails: 'ProductsDetails', 
        ProductsPrice: 10, RestaurantId: 1, SubCategoriesId: 1,
         SubCategoriesName: 'SubCategoriesName', RestaurantName: 'RestaurantName',
          ProductsImage: 'https://source.unsplash.com/user/c_v_r/100x100'));
        itemprod.add(ProductsModel(ProductsId: 1, ProductsName: 'ProductsName', ProductsDetails: 'ProductsDetails', 
        ProductsPrice: 10, RestaurantId: 1, SubCategoriesId: 1,
         SubCategoriesName: 'SubCategoriesName', RestaurantName: 'RestaurantName',
          ProductsImage: 'https://source.unsplash.com/user/c_v_r/100x100'));
        itemprod.add(ProductsModel(ProductsId: 1, ProductsName: 'ProductsName', ProductsDetails: 'ProductsDetails', 
        ProductsPrice: 10, RestaurantId: 1, SubCategoriesId: 1,
         SubCategoriesName: 'SubCategoriesName', RestaurantName: 'RestaurantName',
          ProductsImage: 'https://source.unsplash.com/user/c_v_r/100x100'));
        itemprod.add(ProductsModel(ProductsId: 1, ProductsName: 'ProductsName', ProductsDetails: 'ProductsDetails', 
        ProductsPrice: 10, RestaurantId: 1, SubCategoriesId: 1,
         SubCategoriesName: 'SubCategoriesName', RestaurantName: 'RestaurantName',
          ProductsImage: 'https://source.unsplash.com/user/c_v_r/100x100'));
          //      final response=await http.get(Uri.https(AppLink.apiUrl,AppLink.getRestaurantTopAllForApp));
    // if(response.statusCode==200){
    //   final result=json.decode(response.body);
    //    var data = result['data'];
    //   itemsres.value= data.map((json) => RestaurantModel.fromJson(json)).toList();
    // }
    // else{
    //   throw Exception('');
    // }
    return itemprod;
    }
    finally{ 
    }
  }
}