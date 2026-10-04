
 // ignore_for_file: non_constant_identifier_names
 
class CategoriesModel{  
        final int CategoriesId; 
        final String CategoriesName; 
        final String CategoriesImages;
        final String? CategoriesDetails;

        CategoriesModel({
        required  this.CategoriesId,
        required  this.CategoriesImages,
       required  this.CategoriesName,
       this.CategoriesDetails});

         factory CategoriesModel.fromJson(Map<String,dynamic> json){
          return CategoriesModel(CategoriesId:json['categoriesId'],
          CategoriesImages:json['categoriesImages'] ?? json['CategoriesImages'] ?? '',
          CategoriesName:json['categoriesName'] ?? json['CategoriesName'] ?? '',
          CategoriesDetails: (json['categoriesDetails'] ??
                  json['CategoriesDetails'] ??
                  json['details'] ??
                  json['description'])
              ?.toString());
         }
}