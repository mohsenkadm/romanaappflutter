class RestaurantModel {
	int restaurantId;
	String name;
	String details;
	String address;
	String logo;
	String background;
	String phone;
	String lat;
	String long;
	String code;
	String whatsapp;  
	int? starCount;
	bool? isClosed;
	bool? isStars;
	double minimumPrice;
	String areaname;
	int categoriesId;
	String categoriesName;

	RestaurantModel({required this.restaurantId,required this.name,required this.details,required this.address,required this.logo,required this.background,required this.phone,required this.lat,required this.long,required this.code,required this.whatsapp,required this.starCount,required this.isClosed,required this.isStars,required this.minimumPrice,required this.areaname,required this.categoriesId,required this.categoriesName,});

	factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(restaurantId: json['restaurantId'],
     name: json['name'], details: json['details'],
      address: json['address'], 
      logo: json['logo'], background: json['background'], phone: json['phone'],
       lat: json['lat'], long: json['long'], code: json['code'], whatsapp: json['whatsapp'],
        starCount: json['starCount'], isClosed: json['isClosed'], isStars: json['isStars'],
         minimumPrice: json['minimumPrice'], areaname: json['areaname'], categoriesId: json['categoriesId'],
          categoriesName: json['categoriesName']);
  }

//	Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
