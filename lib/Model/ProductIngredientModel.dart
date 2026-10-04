class ProductIngredientModel {
  final int productIngredientId;
  final int productsId;
  final String ingredientName;

  ProductIngredientModel({
    required this.productIngredientId,
    required this.productsId,
    required this.ingredientName,
  });

  factory ProductIngredientModel.fromJson(Map<String, dynamic> json) {
    return ProductIngredientModel(
      productIngredientId: json['productIngredientId'] ?? 0,
      productsId: json['productsId'] ?? 0,
      ingredientName: json['ingredientName'] ?? '',
    );
  }
}
