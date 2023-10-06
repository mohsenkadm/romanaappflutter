
// -- orders.dart --
import 'package:romanaappflutter/Model/OrderDetailModel.dart';

class OrdersModel {
	int orderId;
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
	String userName;
	String phone;
	String address;
	String functionPoint;
	String logo;
	String restaurantName;
	String categoriesName;
	List<OrderDetailModel>? orderDetails;

	OrdersModel({required this.orderId,required this.orderNo,required this.orderDate,required this.restaurantId,required this.userId,required this.total,required this.totalDiscount,required this.netAmount,required this.isCancel,required this.isApporve,required this.isDone,required this.userName,required this.phone,required this.address,required this.functionPoint,required this.logo,required this.restaurantName,required this.categoriesName, this.orderDetails,});

	factory OrdersModel.fromJson(Map<String, dynamic> json){
    return OrdersModel(orderId: json['orderId'], orderNo: json['orderNo'], 
    orderDate: json['orderDate'], restaurantId: json['restaurantId'], userId: json['userId'],
     total: json['total'], totalDiscount: json['totalDiscount'], netAmount: json['netAmount'],
      isCancel: json['isCancel'], isApporve: json['isApporve'], isDone: json['isDone'],
       userName: json['userName'], phone: json['phone'],
        address: json['address'], functionPoint: json['functionPoint'],
         logo: json['logo'], restaurantName: json['restaurantName'],
          categoriesName: json['categoriesName'], orderDetails: json['orderDetails']);
  }

	//Map<String, dynamic> toJson() => _$OrdersToJson(this);
}