
class NotifModel {
  final String title;
  final String details;
  final String datetime;
  final String images;
  final int userId;
  NotifModel( {required this.title,required this.details,required this.datetime,
   required this.images,required this.userId});
   factory NotifModel.fromJson(Map<String,dynamic> json){
          return NotifModel(title:json['title'],
          details:json['details']
          ,datetime:json['datetime'],images:json['images']
          ,userId:json['userId']);
         }
}