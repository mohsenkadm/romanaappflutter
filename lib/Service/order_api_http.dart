import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// طلبات HTTP الخاصة بالطلبات مع تسجيل الإرسال والاستقبال.
class OrderApiHttp {
  OrderApiHttp._();

  static const String _logName = 'OrderAPI';
  static const int _maxBodyLength = 4000;

  /// في وضع التطوير مفعّل افتراضياً. للتفعيل في الإصدار: `OrderApiHttp.enabled = true`
  static bool enabled = kDebugMode;

  static Future<http.Response> get(
    Uri url, {
    Map<String, String>? headers,
  }) =>
      _execute(
        () => http.get(url, headers: headers),
        method: 'GET',
        url: url,
        headers: headers,
      );

  static Future<http.Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _execute(
        () => http.post(url, headers: headers, body: body, encoding: encoding),
        method: 'POST',
        url: url,
        headers: headers,
        body: body?.toString(),
      );

  static Future<http.Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) =>
      _execute(
        () => http.delete(url, headers: headers, body: body, encoding: encoding),
        method: 'DELETE',
        url: url,
        headers: headers,
        body: body?.toString(),
      );

  static Future<http.Response> _execute(
    Future<http.Response> Function() call, {
    required String method,
    required Uri url,
    Map<String, String>? headers,
    String? body,
  }) async {
    final sw = Stopwatch()..start();
    _logOutgoing(method, url, headers, body);
    try {
      final response = await call();
      _logIncoming(method, url, response, sw.elapsed);
      return response;
    } catch (e, st) {
      _logFailure(method, url, e, st, sw.elapsed);
      rethrow;
    }
  }

  static void _logOutgoing(
    String method,
    Uri url,
    Map<String, String>? headers,
    String? body,
  ) {
    if (!enabled) return;
    developer.log(
      '➡️ $method ${url.toString()}\n'
      'Headers: ${_formatHeaders(headers)}\n'
      '${body != null && body.isNotEmpty ? 'Body: ${_truncate(body)}' : 'Body: (empty)'}',
      name: _logName,
    );
  }

  static void _logIncoming(
    String method,
    Uri url,
    http.Response response,
    Duration elapsed,
  ) {
    if (!enabled) return;
    developer.log(
      '⬅️ $method ${url.toString()} → ${response.statusCode} (${elapsed.inMilliseconds}ms)\n'
      'Body: ${_truncate(response.body)}',
      name: _logName,
    );
  }

  static void _logFailure(
    String method,
    Uri url,
    Object error,
    StackTrace stack,
    Duration elapsed,
  ) {
    if (!enabled) return;
    developer.log(
      '❌ $method ${url.toString()} (${elapsed.inMilliseconds}ms)\n'
      'Error: $error\n$stack',
      name: _logName,
      level: 1000,
    );
  }

  static String _formatHeaders(Map<String, String>? headers) {
    if (headers == null || headers.isEmpty) return '{}';
    return jsonEncode(headers.map((k, v) {
      if (k.toLowerCase() == 'authorization') {
        return MapEntry(k, _maskToken(v));
      }
      return MapEntry(k, v);
    }));
  }

  static String _maskToken(String value) {
    if (value.length <= 12) return '***';
    return '${value.substring(0, 7)}…***';
  }

  static String _truncate(String text) {
    if (text.length <= _maxBodyLength) return text;
    return '${text.substring(0, _maxBodyLength)}… [truncated ${text.length - _maxBodyLength} chars]';
  }
}
