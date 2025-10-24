
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

	OrderDetailModel({ this.orderDetailId, this.orderId,required this.productsId,required this.price,required this.count,required this.productsName
  ,this.notes2,required this.productsDetails,required this.productsImage,required this.subCategoriesName, this.orderNo, this.orderDate,required this.restaurantId, this.userId, this.total, this.totalDiscount, this.netAmount, this.isCancel, this.isApporve, this.isDone,});

	factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(orderDetailId: json['orderDetailId'], 
    orderId: json['orderId'], productsId: json['productsId'], price: double.tryParse(json['price'].toString()), 
    count: json['count'], productsName: json['productsName'], 
    productsDetails: json['productsDetails'], 
    productsImage: json['productsImage'], 
    subCategoriesName: json['subCategoriesName'], 
    orderNo: json['orderNo'], orderDate:DateTime.tryParse(json['orderDate'].toString())!,
     restaurantId: json['restaurantId'], 
     userId: json['userId'], total: double.tryParse(json['total'].toString()),
      totalDiscount:double.tryParse( json['totalDiscount'].toString()),
       netAmount:double.tryParse( json['netAmount'].toString()), 
       isCancel: json['isCancel'], 
       isApporve: json['isApporve'],
        isDone: json['isDone'],notes2: json['notes2']);
  }
Map<String, dynamic> toJson()=>{
    'productsId':productsId,'price':price,'count':count,'notes2':notes2
  };
}
