class RestaurantModel {
	int? restaurantId;
	String? name;
	String? details;
	String? address;
	String? logo;
	String? background;
	String? phone;
	String? lat;
	String? long;
	String? code;
	String? whatsapp;  
	int? starCount;
	bool? isClosed;
	bool? isStars;
	int? minimumPrice;
  int? costDelivery;
	String? areaname;
	int? categoriesId;
	String? categoriesName;
	String? insta;
	RestaurantModel({ this.restaurantId, this.name, this.details, this.address, this.logo, this.background,
   this.phone, this.lat, this.long, this.code, this.whatsapp, this.starCount,
    this.isClosed, this.isStars, this.minimumPrice,this.costDelivery, this.areaname, this.categoriesId, this.categoriesName,this.insta});

	factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(restaurantId: json['restaurantId'],
     name: json['name'], details: json['details'],
      address: json['address'], 
      logo: json['logo'], background: json['background'], phone: json['phone'],
       lat: json['lat'], long: json['long'], code: json['code'], whatsapp: json['whatsapp'],
        starCount: json['starCount'], isClosed: json['isClosed'], isStars: json['isStars'],
         minimumPrice: json['minimumPrice'],costDelivery:json['costDelivery'], areaname: json['areaname'], categoriesId: json['categoriesId'],
          categoriesName: json['categoriesName'],insta:json['insta']);
  }

//	Map<String, dynamic> toJson() => _$RestaurantToJson(this);
}
