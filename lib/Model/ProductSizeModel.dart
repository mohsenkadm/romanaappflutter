class ProductSizeModel {
  final int productSizeId;
  final int productsId;
  final String sizeName;
  final double sizePrice;

  ProductSizeModel({
    required this.productSizeId,
    required this.productsId,
    required this.sizeName,
    required this.sizePrice,
  });

  factory ProductSizeModel.fromJson(Map<String, dynamic> json) {
    return ProductSizeModel(
      productSizeId: json['productSizeId'] ?? 0,
      productsId: json['productsId'] ?? 0,
      sizeName: json['sizeName'] ?? '',
      sizePrice: double.tryParse(json['sizePrice'].toString()) ?? 0.0,
    );
  }
}
