import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:romanaappflutter/Constant/token_refresh_service.dart';
import 'package:romanaappflutter/linkapi.dart';

class ApiResponse {
  final bool success;
  final String? msg;
  final dynamic data;

  ApiResponse({required this.success, this.msg, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
        success: json['success'] == true,
        msg: json['msg']?.toString(),
        data: json['data'],
      );
}

class ApiClient {
  ApiClient({this.token});

  String? token;

  static String get baseUrl => 'https://${AppLink.apiUrl}/';

  Uri _uri(String path, [Map<String, String>? query]) {
    final p = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('$baseUrl$p').replace(queryParameters: query);
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token!.isNotEmpty)
          'Authorization': 'Bearer $token',
      };

  ApiResponse _parseResponse(http.Response res) {
    if (res.statusCode == 401) {
      // جلسة منتهية / غير مصرّح — خروج نظيف
      // ignore: unawaited_futures
      TokenRefreshService.forceLogout();
      return ApiResponse(success: false, msg: 'غير مصرح — سجّل الدخول مجدداً');
    }
    if (res.body.trim().isEmpty) {
      if (res.statusCode >= 200 && res.statusCode < 300) {
        return ApiResponse(success: true, data: null);
      }
      throw Exception('فشل الاتصال بالخادم (${res.statusCode})');
    }
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is! Map<String, dynamic>) {
        throw Exception('استجابة غير متوقعة من الخادم');
      }
      final r = ApiResponse.fromJson(decoded);
      return r;
    } on FormatException {
      throw Exception('تعذر قراءة استجابة الخادم (${res.statusCode})');
    }
  }

  Future<ApiResponse> get(String path, {Map<String, String>? query}) async {
    final res = await http.get(_uri(path, query), headers: _headers);
    return _parseResponse(res);
  }

  Map<String, String> get _authHeaders {
    return {
      'Accept': 'application/json',
      if (token != null && token!.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  Future<ApiResponse> postJson(
    String path,
    Map<String, dynamic>? body, {
    Map<String, String>? query,
  }) async {
    final res = await http.post(
      _uri(path, query),
      headers: _headers,
      body: jsonEncode(body ?? {}),
    );
    return _parseResponse(res);
  }

  /// POST بدون body — لـ Confirm/Resend OTP.
  Future<ApiResponse> postEmpty(String path) async {
    final res = await http.post(_uri(path), headers: _authHeaders);
    return _parseResponse(res);
  }

  /// multipart/form-data مع Bearer فقط (بدون application/json).
  Future<ApiResponse> postMultipart(
    String path,
    Map<String, String> fields,
  ) async {
    final request = http.MultipartRequest('POST', _uri(path));
    request.headers.addAll(_authHeaders);
    request.fields.addAll(fields);
    final streamed = await request.send();
    final res = await http.Response.fromStream(streamed);
    return _parseResponse(res);
  }

  void throwIfFailed(ApiResponse r) {
    if (!r.success) throw Exception(r.msg ?? 'فشل الطلب');
  }
}
