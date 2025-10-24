
class NotifModel {
  final String title;
  final String details;
  final DateTime? dateInsert;
  final String? images; 
  NotifModel( {required this.title,required this.details,required this.dateInsert,
    this.images});
   factory NotifModel.fromJson(Map<String,dynamic> json){
          return NotifModel(title:json['title'],
          details:json['details']
          ,dateInsert:json['dateInsert'] == null ? null : DateTime.parse(json['dateInsert'] as String),images:json['images']   );
         }
}