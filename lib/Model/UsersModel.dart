class UsersModel{

       final int UserId ;
        final String Name ;
        final String Phone ;      
        final String? Token ;        
        final String? Address ;    
        final String FunctionPoint ;
        final String? Lat ;
        final String? Long ;
      UsersModel({required this.UserId,required this.Name,required this.Phone,required this.Address,required this.FunctionPoint
      , this.Lat, this.Long, this.Token});
      factory UsersModel.fromJson(Map<String,dynamic> json){
        return UsersModel(UserId: json['userId'],
         Name: json['name'], Phone: json['phone'],
          Address: json['address'], FunctionPoint: json['functionPoint']);
      }
}