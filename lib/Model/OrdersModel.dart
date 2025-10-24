
// -- orders.dart --
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';

class OrdersModel {
	int? orderId;
	int? orderNo;
	DateTime orderDate;
	int restaurantId;
	int? userId;
	double? total;
	double? totalDiscount;
	double? netAmount;
  double?costDelivery;
	bool? isCancel;
	bool? isApporve;
	bool? isDone;
	String? userName;
	String? phone;
	String? address;
	String? functionPoint;
	String? lat;
	String? long;
	String? logo;
	String? restaurantName;
	String? categoriesName;
	String? notes;
	String? promoCode;
  int? SaleManId;
  bool? IsSaleManApprove;
  bool? IsSaleManCancel;
  String? SaleManName;
	List<OrderDetailModel>? orderDetails;
  UsersModel? usersModel;

	OrdersModel({ this.orderId, this.orderNo,required this.orderDate,
  required this.restaurantId, this.userId,required this.total,
  required this.totalDiscount,required this.netAmount, this.isCancel,
   this.isApporve, this.isDone, this.notes,this.promoCode,this.userName, this.phone, this.address, this.functionPoint, 
    this.lat, this.long, this.logo, this.restaurantName,
    this.categoriesName, this.orderDetails,this.usersModel,this.SaleManId,this.IsSaleManApprove,
    this.IsSaleManCancel,this.SaleManName,this.costDelivery});

	factory OrdersModel.fromJson(Map<String, dynamic> json){
    return OrdersModel(orderId: json['orderId'], orderNo: json['orderNo'], 
    orderDate: DateTime.tryParse(json['orderDate'].toString())!, restaurantId: json['restaurantId'], userId: json['userId'],
     total:double.tryParse(json['total'].toString()), totalDiscount:double.tryParse( json['totalDiscount'].toString()), netAmount: double.tryParse(json['netAmount'].toString()),
      isCancel: json['isCancel'], isApporve: json['isApporve'], isDone: json['isDone'],notes:json['notes'],promoCode:json['promoCode'],
       userName: json['userName'], phone: json['phone'],
        address: json['address'], functionPoint: json['functionPoint'],
        lat: json['lat'], long: json['long'],
         logo: json['logo'], restaurantName: json['restaurantName'],
          categoriesName: json['categoriesName'], orderDetails: json['orderDetails'],usersModel: json['users'],
          SaleManId: json['saleManId'],
          IsSaleManApprove: json['isSaleManApprove'],IsSaleManCancel: json['isSaleManCancel'],
          SaleManName: json['saleManName'],costDelivery:double.tryParse(json['costDelivery'].toString()));
  }

	Map<String, dynamic> toJson(){
      List<Map<String,dynamic>> details=orderDetails!.map((e) => e.toJson()).toList();
   return { 'restaurantId':restaurantId,'userId':userId,'total':total,'notes':notes,'functionPoint':functionPoint,
    'totalDiscount':totalDiscount,'netAmount':netAmount,'costDelivery':costDelivery,'users':usersModel?.toJson(),'orderDetails':details
  };}
}