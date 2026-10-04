import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:romanaappflutter/linkapi.dart';
import 'package:romanaappflutter/main.dart';

class AppSplashController {
  static Future<void> showIfNeeded() async {
    try {
      final res = await http.get(
        Uri.https(AppLink.apiUrl, AppLink.appSplashGetForApp),
      );
      if (res.statusCode != 200) return;
      final result = json.decode(res.body);
      if (result['success'] != true) return;
      final data = result['data'];
      if (data == null || data['isVisible'] != true) return;
      final imageUrl = data['imageUrl']?.toString();
      final details = data['details']?.toString() ?? '';
      if (Get.context == null) return;

      await Get.dialog(
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (imageUrl != null && imageUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24)),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ).animate().fadeIn().slideY(begin: -0.08, end: 0),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  details,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.cairo(fontSize: 16, height: 1.5),
                ),
              ).animate().fadeIn(delay: 120.ms),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('متابعة',
                        style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    } catch (_) {}
  }
}
