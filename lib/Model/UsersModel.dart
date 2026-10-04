// ignore_for_file: file_names

class UsersModel {
  int userId;
  String Name;
  String Phone;
  String? Token;
  String? Address;
  String FunctionPoint;
  String? Lat;
  String? Long;
  String? Password;
  int? CityId;
  bool? isConfirm;

  UsersModel({
    required this.userId,
    required this.Name,
    required this.Phone,
    required this.Address,
    required this.FunctionPoint,
    this.Lat,
    this.Long,
    this.Token,
    this.Password,
    this.CityId,
    this.isConfirm,
  });

  factory UsersModel.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    return UsersModel(
      userId: parseId(json['userId'] ?? json['UserId']),
      Name: (json['name'] ?? json['Name'])?.toString() ?? '',
      Phone: (json['phone'] ?? json['Phone'])?.toString() ?? '',
      Token: (json['token'] ?? json['Token'])?.toString(),
      Address: (json['address'] ?? json['Address'])?.toString(),
      FunctionPoint:
          (json['functionPoint'] ?? json['FunctionPoint'])?.toString() ?? '',
      Password: (json['password'] ?? json['Password'])?.toString(),
      Lat: (json['lat'] ?? json['Lat'])?.toString(),
      Long: (json['long'] ?? json['Long'])?.toString(),
      CityId: json['cityId'] == null && json['CityId'] == null
          ? null
          : parseId(json['cityId'] ?? json['CityId']),
      isConfirm: () {
        final v = json['isConfirm'] ?? json['IsConfirm'];
        if (v is bool) return v;
        if (v == null) return null;
        return v.toString().toLowerCase() == 'true';
      }(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': Name,
        'phone': Phone,
        'address': Address,
        'functionPoint': FunctionPoint,
        'lat': Lat,
        'long': Long,
        'cityId': CityId,
      };
}
