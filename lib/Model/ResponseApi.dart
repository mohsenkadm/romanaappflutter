
import 'package:romanaappflutter/Model/CategoriesModel.dart';

class ResponseApi {
    bool? success;
    List<CategoriesModel?>? data;

    ResponseApi({this.success, this.data}); 

    ResponseApi.fromJson(Map<String, dynamic> json) {
        success = json['success'];
        if (json['data'] != null) {
         data = <CategoriesModel>[];
         json['data'].forEach((v) {
         data!.add(CategoriesModel.fromJson(v));
        });
      }
    }
 
}