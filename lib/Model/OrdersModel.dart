
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
  String? Reason;
  int? SaleManId;
  bool? IsSaleManApprove;
  bool? IsSaleManCancel;
  String? SaleManName;
  bool? isPreparing;
  bool? isDriverEnRouteToPickup;
  bool? isPickedUpFromRestaurant;
  bool? isOutForDelivery;
  bool? isDeliveryConfirmed;
  bool? isDelivered;
  int? statusCode;
  String? pricingSource;
  String? pricingFromZone;
  String? pricingToZone;
  double? pricingZoneFee;
  double? pricingEcaFee;
  double? routeDistanceKm;
	List<OrderDetailModel>? orderDetails;
  UsersModel? usersModel;

  OrdersModel({ this.orderId, this.orderNo,required this.orderDate,
  required this.restaurantId, this.userId,required this.total,
  required this.totalDiscount,required this.netAmount, this.isCancel,
   this.isApporve, this.isDone, this.notes,this.promoCode,this.Reason,this.userName, this.phone, this.address, this.functionPoint, 
    this.lat, this.long, this.logo, this.restaurantName,
    this.categoriesName, this.orderDetails,this.usersModel,this.SaleManId,this.IsSaleManApprove,
    this.IsSaleManCancel,this.SaleManName,this.costDelivery,
    this.isPreparing, this.isDriverEnRouteToPickup, this.isPickedUpFromRestaurant,
    this.isOutForDelivery, this.isDeliveryConfirmed, this.isDelivered,
    this.statusCode, this.pricingSource, this.pricingFromZone, this.pricingToZone,
    this.pricingZoneFee, this.pricingEcaFee, this.routeDistanceKm});

	factory OrdersModel.fromJson(Map<String, dynamic> json){
    final parsedDate = DateTime.tryParse(json['orderDate']?.toString() ?? '') ??
        DateTime.tryParse(json['OrderDate']?.toString() ?? '') ??
        DateTime.now();
    return OrdersModel(orderId: json['orderId'] ?? json['OrderId'], orderNo: json['orderNo'] ?? json['OrderNo'], 
    orderDate: parsedDate, restaurantId: json['restaurantId'] ?? json['RestaurantId'] ?? 0, userId: json['userId'] ?? json['UserId'],
     total:double.tryParse(json['total']?.toString() ?? ''), totalDiscount:double.tryParse( json['totalDiscount']?.toString() ?? ''), netAmount: double.tryParse(json['netAmount']?.toString() ?? ''),
      isCancel: json['isCancel'] ?? json['IsCancel'], isApporve: json['isApporve'] ?? json['IsApporve'], isDone: json['isDone'] ?? json['IsDone'],notes:json['notes'],promoCode:json['promoCode'],
       Reason: (json['reason'] ?? json['Reason'])?.toString(),
       userName: json['userName'], phone: json['phone'],
        address: json['address'], functionPoint: json['functionPoint'],
        lat: json['lat'], long: json['long'],
         logo: json['logo'], restaurantName: json['restaurantName'],
          categoriesName: json['categoriesName'], 
          orderDetails: json['orderDetails'] == null 
              ? null 
              : (json['orderDetails'] as List).map((d) => OrderDetailModel.fromJson(d)).toList(),
          usersModel: json['users'],
          SaleManId: json['saleManId'],
          IsSaleManApprove: json['isSaleManApprove'],IsSaleManCancel: json['isSaleManCancel'],
          SaleManName: json['saleManName'],costDelivery:double.tryParse(json['costDelivery']?.toString() ?? ''),
          isPreparing: json['isPreparing'],
          isDriverEnRouteToPickup: json['isDriverEnRouteToPickup'],
          isPickedUpFromRestaurant: json['isPickedUpFromRestaurant'],
          isOutForDelivery: json['isOutForDelivery'],
          isDeliveryConfirmed: json['isDeliveryConfirmed'],
          isDelivered: json['isDelivered'] ?? json['IsDelivered'],
          statusCode: int.tryParse((json['statusCode'] ?? json['StatusCode'])?.toString() ?? ''),
          pricingSource: json['pricingSource']?.toString(),
          pricingFromZone: json['pricingFromZone']?.toString(),
          pricingToZone: json['pricingToZone']?.toString(),
          pricingZoneFee: double.tryParse(
              json['pricingZoneFee']?.toString() ?? ''),
          pricingEcaFee:
              double.tryParse(json['pricingEcaFee']?.toString() ?? ''),
          routeDistanceKm: double.tryParse(
              json['routeDistanceKm']?.toString() ?? ''));
  }

	Map<String, dynamic> toJson(){
      List<Map<String,dynamic>> details=orderDetails!.map((e) => e.toJson()).toList();
   return { 'restaurantId':restaurantId,'userId':userId,'total':total,'notes':notes,'functionPoint':functionPoint,
    'totalDiscount':totalDiscount,'netAmount':netAmount,'costDelivery':costDelivery,'users':usersModel?.toJson(),'orderDetails':details
  };}
}