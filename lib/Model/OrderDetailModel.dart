
// -- order_detail.dart --
class OrderDetailModel {
	int? orderDetailId;
	int? orderId;
	int productsId;
	double? price;
	int count;
	String productsName;
	String productsDetails;
	String productsImage;
	String subCategoriesName;
	int? orderNo;
	DateTime? orderDate;
	int restaurantId;
	int? userId;
	double? total;
	double? totalDiscount;
	double? netAmount;
	bool? isCancel;
	bool? isApporve;
	bool? isDone;
	String? notes2;
  // Size & ingredient selections
  int? selectedSizeId;
  String? selectedSizeName;
  double? selectedSizePrice;
  String? selectedIngredients;

  double get unitPrice => price ?? 0;

	OrderDetailModel({ this.orderDetailId, this.orderId,required this.productsId,required this.price,required this.count,required this.productsName
  ,this.notes2,required this.productsDetails,required this.productsImage,required this.subCategoriesName, this.orderNo, this.orderDate,required this.restaurantId, this.userId, this.total, this.totalDiscount, this.netAmount, this.isCancel, this.isApporve, this.isDone,
  this.selectedSizeId, this.selectedSizeName, this.selectedSizePrice, this.selectedIngredients});

	factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(orderDetailId: json['orderDetailId'], 
    orderId: json['orderId'], productsId: json['productsId'], price: double.tryParse(json['price'].toString()), 
    count: json['count'],     productsName: json['productsName']?.toString() ?? '', 
    productsDetails: json['productsDetails']?.toString() ?? '', 
    productsImage: json['productsImage']?.toString() ?? '', 
    subCategoriesName: json['subCategoriesName']?.toString() ?? '',
    orderNo: json['orderNo'], orderDate: DateTime.tryParse(json['orderDate']?.toString() ?? ''),
     restaurantId: _parseRestaurantId(json['restaurantId'] ?? json['RestaurantId']), 
     userId: json['userId'], total: double.tryParse(json['total'].toString()),
      totalDiscount:double.tryParse( json['totalDiscount'].toString()),
       netAmount:double.tryParse( json['netAmount'].toString()), 
       isCancel: json['isCancel'], 
       isApporve: json['isApporve'],
        isDone: json['isDone'],notes2: json['notes2'],
        selectedSizeId: json['selectedSizeId'],
        selectedSizeName: json['selectedSizeName'],
        selectedSizePrice: double.tryParse(json['selectedSizePrice']?.toString() ?? ''),
        selectedIngredients: json['selectedIngredients']);
  }
  static int _parseRestaurantId(dynamic value) {
    if (value == null || value == '') return 0;
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value.toString()) ?? 0;
  }

Map<String, dynamic> toJson()=>{
    'productsId':productsId,'price':price,'count':count,'notes2':notes2,
    'selectedSizeId':selectedSizeId,'selectedSizeName':selectedSizeName,
    'selectedSizePrice':selectedSizePrice,'selectedIngredients':selectedIngredients,
  };
}
