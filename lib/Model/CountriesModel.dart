
class CountriesModel{  
        final int CountriesId;  
        final String CountriesName;

        CountriesModel({
        required  this.CountriesId,
       required  this.CountriesName});

         factory CountriesModel.fromJson(Map<String,dynamic> json){
          return CountriesModel(CountriesId:json['countriesId'],CountriesName:json['countriesName']);
         }
}