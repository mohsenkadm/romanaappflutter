// -- stars.dart --
class StarsModel {
	final int starsId;
	final int? userId;
	final int? starsCount;
	final int? restaurantId;
	final String? comments;
	final String? userName;
	final String? restaurantName;

	StarsModel({required this.starsId,required this.userId,
  required this.starsCount,required this.restaurantId,
  required this.comments, this.userName, this.restaurantName,});

	factory StarsModel.fromJson(Map<String, dynamic> json) {
    return StarsModel(starsId: json['starsId'],userId: json['userId'],
    starsCount: json['starsCount'],restaurantId:json['restaurantId'],
    comments: json['comments'],userName: json['userName']
    ,restaurantName: json['restaurantName']);
  }

	//Map<String, dynamic> toJson() => _$StarsToJson(this);
}