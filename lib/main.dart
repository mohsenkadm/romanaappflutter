import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/PushNotificationHandler.dart';
import 'package:romanaappflutter/Constant/dependencyinjection.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/Constant/session_storage.dart';
import 'package:romanaappflutter/core/locale/app_translations.dart';
import 'package:romanaappflutter/core/locale/locale_service.dart';
import 'package:romanaappflutter/views/CoverageGate.dart';
import 'package:romanaappflutter/views/LanguageSelectView.dart';
import 'package:romanaappflutter/views/MainApp.dart';
import 'package:romanaappflutter/views/OnBourding.dart';

int? initScreen;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final localeService = Get.put(LocaleService(), permanent: true);

  GetTimeAgo.setDefaultLocale(localeService.code.value == 'en' ? 'en' : 'ar');

  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize("c8dfb903-9803-44d7-b6d5-b7660fa2e527");
  OneSignal.Notifications.requestPermission(true);
  PushNotificationHandler.register();

  final box = GetStorage();
  initScreen = box.read("initScreen");
  final uid = box.read('UserId') ?? box.read('userId');
  if (uid != null && uid.toString() != '0') {
    await OneSignal.login(uid.toString());
  }
  dependencyinjection.onInit();
  runApp(const _MyApp());
}

/// الشاشة التالية بعد اختيار اللغة / عند التشغيل العادي.
Widget resolveAppHome() {
  final box = GetStorage();
  if (!LocaleService.to.hasSelectedLocale) {
    return LanguageSelectView(
      onDone: () => Get.offAll(() => resolveAppHome()),
    );
  }
  if (initScreen == 0 || initScreen == null) return const OnBoarding();
  if (SessionStorage.isLoggedIn(box) &&
      !LocationStorage.coverageVerified &&
      !LocationStorage.requestSubmitted) {
    return const CoverageGate();
  }
  return const MainApp();
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    Get.put(determinePositionLocation(), permanent: true);
    final localeService = LocaleService.to;

    return GetMaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: localeService.locale,
      fallbackLocale: const Locale('ar'),
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: resolveAppHome(),
    );
  }
}

const Color _primary = Color(0xFFDB2820);
const Color _primaryLight = Color(0x32DB2820);

ThemeData myTheme = ThemeData(
  fontFamily: "Tajawal",
  primaryColor: _primary,
  secondaryHeaderColor: _primaryLight,
  scaffoldBackgroundColor: const Color(0xFFF7F7F7),
  colorScheme: ColorScheme.fromSeed(
    seedColor: _primary,
    primary: _primary,
    surface: Colors.white,
    background: const Color(0xFFF7F7F7),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    foregroundColor: _primary,
    surfaceTintColor: Colors.white,
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
    titleTextStyle: GoogleFonts.cairo(
        color: _primary, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  cardTheme: const CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16))),
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      shadowColor: _primary.withOpacity(0.35),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      minimumSize: const Size(64, 48),
      alignment: Alignment.center,
      textStyle: GoogleFonts.cairo(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        height: 1.25,
      ),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: _primary),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[50],
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 1.5)),
    hintStyle: GoogleFonts.cairo(color: Colors.grey[400], fontSize: 14),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: _primary,
    foregroundColor: Colors.white,
    elevation: 4,
  ),
  dividerTheme: const DividerThemeData(color: Color(0xFFEEEEEE), thickness: 1),
);
