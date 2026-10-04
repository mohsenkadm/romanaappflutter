import 'package:get_storage/get_storage.dart';

class ApiAuth {
  static Map<String, String> headers({bool json = false}) {
    final token = GetStorage().read('token')?.toString();
    final h = <String, String>{};
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    if (json) h['Content-Type'] = 'application/json';
    return h;
  }
}
