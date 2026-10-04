class SubCategoriesModel {
  final int SubCategoriesId;
  final String SubCategoriesName;

  SubCategoriesModel({
    required this.SubCategoriesId,
    required this.SubCategoriesName,
  });

  factory SubCategoriesModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['subCategoriesId'] ?? json['SubCategoriesId'];
    return SubCategoriesModel(
      SubCategoriesId: rawId is int
          ? rawId
          : int.tryParse(rawId?.toString() ?? '') ?? 0,
      SubCategoriesName:
          (json['subCategoriesName'] ?? json['SubCategoriesName'] ?? '')
              .toString(),
    );
  }
}
