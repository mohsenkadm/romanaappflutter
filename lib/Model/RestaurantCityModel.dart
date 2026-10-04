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
          return RestaurantCityModel(
          RestaurantCityId: json['restaurantCityId'] ?? 0,
          CityId: json['cityId'] ?? 0,
          CityName: json['cityName']?.toString(),
          RestaurantId: json['restaurantId'] ?? 0,
          RestaurantName: json['restaurantName']?.toString(),
          costDelivery: _parseCostDelivery(json['costDelivery']));
         }

  static int? _parseCostDelivery(dynamic value) {
    if (value == null || value == '') return null;
    if (value is int) return value;
    if (value is num) return value.round();
    return int.tryParse(value.toString());
  }

         Map<String, dynamic> toJson()=>{
          'restaurantCityId':RestaurantCityId,
    'cityId':CityId,'restaurantId':RestaurantId,'costDelivery':costDelivery
  };
}