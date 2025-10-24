
class CityModel{  
        final int CityId;  
        final String CityName;

        CityModel({
        required  this.CityId,
       required  this.CityName});

         factory CityModel.fromJson(Map<String,dynamic> json){
          return CityModel(CityId:json['cityId'],CityName:json['cityName']);
         }
}