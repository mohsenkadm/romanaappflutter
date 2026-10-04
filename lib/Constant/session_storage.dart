import 'package:get_storage/get_storage.dart';
import 'package:romanaappflutter/Model/UsersModel.dart';

/// قراءة موحّدة لجلسة المستخدم بعد OTP أو تسجيل الدخول الكلاسيكي.
class SessionStorage {
  SessionStorage._();

  static int userId(GetStorage box) {
    final v = box.read('UserId') ?? box.read('userId');
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static String token(GetStorage box) =>
      box.read('token')?.toString() ?? '';

  static bool isLoggedIn(GetStorage box) =>
      userId(box) > 0 && token(box).isNotEmpty;

  static Future<void> persistUser(GetStorage box, UsersModel user) async {
    await box.write('islogin', true);
    await box.write('UserId', user.userId);
    await box.write('userId', user.userId);
    final t = user.Token?.toString() ?? '';
    if (t.isNotEmpty) await box.write('token', t);
    await box.write('Name', user.Name);
    await box.write('Phone', user.Phone);
    await box.write('Address', user.Address);
    await box.write('FunctionPoint', user.FunctionPoint);
    if (user.CityId != null) await box.write('CityId', user.CityId);
  }

  static UsersModel userFromBox(GetStorage box) {
    return UsersModel(
      userId: userId(box),
      Name: box.read('Name')?.toString() ?? '',
      Phone: box.read('Phone')?.toString() ?? '',
      Address: box.read('Address')?.toString() ?? '',
      FunctionPoint: box.read('FunctionPoint')?.toString() ?? '',
      Token: token(box),
      CityId: box.read('CityId') as int?,
    );
  }

  /// يبني [UsersModel] من استجابة VerifyOtp / ConfirmCode (شكل مختصر أو كامل).
  static UsersModel fromOtpPayload(
    Map<String, dynamic> data, {
    required String phoneFallback,
  }) {
    return UsersModel.fromJson({
      'userId': data['userId'] ?? data['UserId'] ?? data['id'] ?? data['Id'] ?? 0,
      'name': data['name'] ?? data['Name'] ?? phoneFallback,
      'phone': data['phone'] ?? data['Phone'] ?? phoneFallback,
      'token': data['token'] ?? data['Token'] ?? '',
      'address': data['address'] ?? data['Address'] ?? '',
      'functionPoint': data['functionPoint'] ?? data['FunctionPoint'] ?? '',
      'cityId': data['cityId'] ?? data['CityId'],
      'isConfirm': data['isConfirm'] ?? data['IsConfirm'],
    });
  }
}
