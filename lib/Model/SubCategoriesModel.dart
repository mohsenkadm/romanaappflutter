class SubCategoriesModel{
  final int SubCategoriesId;
  final String SubCategoriesName;
  SubCategoriesModel({required this.SubCategoriesId,required this.SubCategoriesName});
 
 factory SubCategoriesModel.fromJson(Map<String,dynamic> json){
    return SubCategoriesModel(SubCategoriesId: json['subCategoriesId'],
     SubCategoriesName: json['subCategoriesName']);
  }
}