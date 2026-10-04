class DriverModel {
  final int? saleManId;
  final String? name;
  final String? phone;
  final String? lat;
  final String? long;
  final bool? isAvailable;

  DriverModel({
    this.saleManId,
    this.name,
    this.phone,
    this.lat,
    this.long,
    this.isAvailable,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    dynamic v(String a, String b) => json[a] ?? json[b];
    return DriverModel(
      saleManId: v('saleManId', 'SaleManId') as int?,
      name: v('name', 'Name')?.toString(),
      phone: v('phone', 'Phone')?.toString(),
      lat: v('lat', 'Lat')?.toString(),
      long: v('long', 'Long')?.toString(),
      isAvailable: v('isAvailable', 'IsAvailable') as bool?,
    );
  }
}
