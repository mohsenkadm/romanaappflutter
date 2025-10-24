import 'package:romanaappflutter/Model/ImagesModel.dart';

class ProductsModel {
  final int? ProductsId;
  final String? ProductsName;
  final String? ProductsDetails;
  final int? ProductsPrice;
  final int? RestaurantId;
  final int? SubCategoriesId;
 final  String? SubCategoriesName;
 final String? RestaurantName;
 final String? Logo;
  final String? productsImageFirst;
  final String? background;
  final bool? IsFree;
   final List<ImagesModel>? Images;

  ProductsModel({
     this.ProductsId, this.ProductsName,
     this.ProductsDetails, this.ProductsPrice,
      this.RestaurantId, this.SubCategoriesId,
       this.SubCategoriesName, this.RestaurantName,this.Logo,
      this.productsImageFirst,  this.background ,this.IsFree,
      this.Images
  });
  factory ProductsModel.fromJson(Map<String,dynamic> json)
  {
     final List<dynamic>? imageList = json['images'];
    final List<ImagesModel>? images =imageList==null?null: imageList.map((imageJson) {
      return ImagesModel.fromJson(imageJson);
    }).toList();
    return ProductsModel(ProductsId: json['productsId'],
     ProductsName:json['productsName'],
      ProductsDetails:json['productsDetails'], 
      ProductsPrice: json['productsPrice'],
       RestaurantId: json['restaurantId'],
        SubCategoriesId: json['subCategoriesId'], 
        SubCategoriesName: json['subCategoriesName'],
         RestaurantName: json['restaurantName'],Logo:json['logo'],
          productsImageFirst: json['productsImageFirst'],
          background:json['background'],
           IsFree:json['isFree'],Images:images);
  }
}