class ProductsModel {
  final int ProductsId;
  final String ProductsName;
  final String? ProductsDetails;
  final double? ProductsPrice;
  final int RestaurantId;
  final int SubCategoriesId;
 final  String? SubCategoriesName;
 final String? RestaurantName;
  final String? ProductsImage;
  ProductsModel({
    required this.ProductsId,required this.ProductsName,
    required this.ProductsDetails,required this.ProductsPrice,
     required this.RestaurantId,required this.SubCategoriesId,
     required  this.SubCategoriesName,required this.RestaurantName,
     required this.ProductsImage,  
  });
  factory ProductsModel.fromJson(Map<String,dynamic> json)
  {
    return ProductsModel(ProductsId: json['productsId'],
     ProductsName:json['productsName'],
      ProductsDetails:json['productsDetails'], 
      ProductsPrice: json['productsPrice'],
       RestaurantId: json['restaurantId'],
        SubCategoriesId: json['subCategoriesId'], 
        SubCategoriesName: json['subCategoriesName'],
         RestaurantName: json['restaurantName'],
          ProductsImage: json['productsImage']);
  }
}