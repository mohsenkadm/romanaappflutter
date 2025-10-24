class RestaurantCityModel{ 
  final int RestaurantCityId; 
        final int CityId;  
        final int RestaurantId;  
        final String? CityName;
        final String? RestaurantName;
        int? costDelivery;
        RestaurantCityModel({
          required this.RestaurantCityId,
        required  this.CityId,required this.RestaurantId,
         this.CityName,this.RestaurantName,this.costDelivery});

         factory RestaurantCityModel.fromJson(Map<String,dynamic> json){
          return RestaurantCityModel(RestaurantCityId:json['restaurantCityId'],
          CityId:json['cityId'],CityName:json['cityName'],
          RestaurantId:json['restaurantId'],RestaurantName:json['restaurantName'],costDelivery:json['costDelivery']);
         }

         Map<String, dynamic> toJson()=>{
          'restaurantCityId':RestaurantCityId,
    'cityId':CityId,'restaurantId':RestaurantId,'costDelivery':costDelivery
  };
}