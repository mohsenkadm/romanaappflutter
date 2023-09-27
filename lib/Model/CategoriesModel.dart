
 // ignore_for_file: non_constant_identifier_names
 
class CategoriesModel{  
        final int CategoriesId; 
        final String CategoriesName; 
        final String CategoriesImages;

        CategoriesModel({
        required  this.CategoriesId,
        required  this.CategoriesImages,
       required  this.CategoriesName});

         factory CategoriesModel.fromJson(Map<String,dynamic> json){
          return CategoriesModel(CategoriesId:json['categoriesId'],
          CategoriesImages:json['categoriesImages'],CategoriesName:json['categoriesName']);
         }
}