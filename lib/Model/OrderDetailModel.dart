
// -- order_detail.dart --
class OrderDetailModel {
	int orderDetailId;
	int orderId;
	int productsId;
	double price;
	int count;
	String productsName;
	String productsDetails;
	String productsImage;
	String subCategoriesName;
	int orderNo;
	DateTime orderDate;
	int restaurantId;
	int userId;
	double total;
	double totalDiscount;
	double netAmount;
	bool isCancel;
	bool isApporve;
	bool isDone;

	OrderDetailModel({required this.orderDetailId,required this.orderId,required this.productsId,required this.price,required this.count,required this.productsName,required this.productsDetails,required this.productsImage,required this.subCategoriesName,required this.orderNo,required this.orderDate,required this.restaurantId,required this.userId,required this.total,required this.totalDiscount,required this.netAmount,required this.isCancel,required this.isApporve,required this.isDone,});

	factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(orderDetailId: json['orderDetailId'], 
    orderId: json['orderId'], productsId: json['productsId'], price: json['price'], 
    count: json['count'], productsName: json['productsName'], 
    productsDetails: json['productsDetails'], 
    productsImage: json['productsImage'], 
    subCategoriesName: json['subCategoriesName'], 
    orderNo: json['orderNo'], orderDate: json['orderDate'],
     restaurantId: json['restaurantId'], 
     userId: json['userId'], total: json['total'],
      totalDiscount: json['totalDiscount'],
       netAmount: json['netAmount'], 
       isCancel: json['isCancel'], 
       isApporve: json['isApporve'],
        isDone: json['isDone']);
  }

//	Map<String, dynamic> toJson() => _$OrderDetailToJson(this);
}
