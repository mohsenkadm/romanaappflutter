class RestaurantSubCategoriesModel {
	int restaurantSubCategoriesId;
	int subCategoriesId;
	int restaurantId;
	String subCategoriesName;
	String restaurantName;

	RestaurantSubCategoriesModel({required this.restaurantSubCategoriesId,required this.subCategoriesId,required this.restaurantId,required this.subCategoriesName,required this.restaurantName,});

	factory RestaurantSubCategoriesModel.fromJson(Map<String, dynamic> json) {
    return RestaurantSubCategoriesModel(restaurantSubCategoriesId: json['restaurantSubCategoriesId']
    , subCategoriesId: json['subCategoriesId'], 
    restaurantId: json['restaurantId'],
     subCategoriesName: json['subCategoriesName'],
      restaurantName: json['restaurantName']);
  }

	//Map<String, dynamic> toJson() => _$RestaurantSubCategoriesToJson(this);
}
