// ignore_for_file: file_names

class UsersModel{

         int userId ;
          String Name ;
          String Phone ;      
          String? Token ;        
          String? Address ;    
          String FunctionPoint ;
          String? Lat ;
          String? Long ;
          String? Password;
          int? CityId;

      UsersModel({required this.userId,required this.Name,required this.Phone,required this.Address,required this.FunctionPoint
      , this.Lat, this.Long, this.Token,this.Password,this.CityId});
      factory UsersModel.fromJson(Map<String,dynamic> json){
        return UsersModel(userId:int.parse(json['userId'].toString()),
         Name: json['name'], Phone: json['phone'],Token: json['token'],
          Address: json['address'], FunctionPoint: json['functionPoint'],Password:json['password']
          ,CityId:json['cityId']);
      }
      Map<String, dynamic> toJson()=>{
    'userId':userId,'name':Name,'phone':Phone,'address':Address,
    'functionPoint':FunctionPoint,'lat':Lat,'long':Long,'password':Password
    ,'cityId':CityId
  };
}