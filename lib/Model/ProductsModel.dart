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
  final bool? isAvailable;
  final int? preparationTimeMinutes;
  final int? totalOrdered;
   final List<ImagesModel>? Images;

  ProductsModel({
     this.ProductsId, this.ProductsName,
     this.ProductsDetails, this.ProductsPrice,
      this.RestaurantId, this.SubCategoriesId,
       this.SubCategoriesName, this.RestaurantName,this.Logo,
      this.productsImageFirst,  this.background ,this.IsFree,
      this.isAvailable, this.preparationTimeMinutes, this.totalOrdered,
      this.Images
  });

  bool get availableForOrder => isAvailable ?? IsFree ?? true;
  factory ProductsModel.fromJson(
    Map<String, dynamic> json, {
    int fallbackRestaurantId = 0,
  }) {
     final List<dynamic>? imageList = json['images'];
    final List<ImagesModel>? images =imageList==null?null: imageList.map((imageJson) {
      return ImagesModel.fromJson(imageJson);
    }).toList();
    return ProductsModel(ProductsId: json['productsId'],
     ProductsName:json['productsName'],
      ProductsDetails:json['productsDetails'], 
      ProductsPrice: json['productsPrice'],
       RestaurantId: _parseRestaurantId(json, fallbackRestaurantId),
        SubCategoriesId: json['subCategoriesId'], 
        SubCategoriesName: json['subCategoriesName'],
         RestaurantName: json['restaurantName'],Logo:json['logo'],
          productsImageFirst: json['productsImageFirst'],
          background:json['background'],
           IsFree:json['isFree'],
           isAvailable: json['isAvailable'] as bool?,
           preparationTimeMinutes: json['preparationTimeMinutes'] as int?,
           totalOrdered: json['totalOrdered'] as int?,
           Images:images);
  }

  static int? _parseRestaurantId(
      Map<String, dynamic> json, int fallbackRestaurantId) {
    final v = json['restaurantId'] ?? json['RestaurantId'];
    if (v == null || v == '') {
      return fallbackRestaurantId > 0 ? fallbackRestaurantId : null;
    }
    if (v is int) return v > 0 ? v : (fallbackRestaurantId > 0 ? fallbackRestaurantId : null);
    if (v is num) {
      final n = v.round();
      return n > 0 ? n : (fallbackRestaurantId > 0 ? fallbackRestaurantId : null);
    }
    final n = int.tryParse(v.toString());
    if (n != null && n > 0) return n;
    return fallbackRestaurantId > 0 ? fallbackRestaurantId : null;
  }
}