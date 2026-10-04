import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/category.dart';
import 'package:romanaappflutter/views/homepage.dart';
import 'package:romanaappflutter/views/myorder.dart';
import 'package:romanaappflutter/views/notification.dart';
import 'package:romanaappflutter/views/profileuser.dart';
import 'package:romanaappflutter/views/searchresandprod.dart';
import 'package:badges/badges.dart' as badges;
import 'package:romanaappflutter/Constant/dependencyinjection.dart';
import 'package:romanaappflutter/Constant/zone_guard.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Controller/NetworkController.dart';
import 'package:romanaappflutter/Controller/AppSplashController.dart';
import 'package:romanaappflutter/Service/order_hub_service.dart';
import 'package:romanaappflutter/Constant/cart_badge.dart';
import 'package:romanaappflutter/core/locale/locale_service.dart';

class MainApp extends StatefulWidget {
  const MainApp({ Key? key }) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  final RxInt currentIndex = 0.obs;
  late final AppBadgeController _badges;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  final List<Widget> tabs = [
    const homepage(),
    const category(),
    const my_order(),
    const Profileuser()
  ];  

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<NetworkController>()) {
      dependencyinjection.onInit();
    }
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
    _badges = Get.find<AppBadgeController>();
    final args = Get.arguments;
    if (args is Map && args['tab'] is int) {
      final tab = args['tab'] as int;
      if (tab >= 0 && tab < tabs.length) {
        currentIndex.value = tab;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _badges.refreshCart();
      await AppSplashController.showIfNeeded();
      await ZoneGuard.ensureZoneSelected();
      if (!Get.isRegistered<OrderHubService>()) {
        await Get.putAsync<OrderHubService>(() async {
          final s = OrderHubService();
          await s.connect();
          return s;
        });
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }
   
  @override
  Widget build(BuildContext context) {
   return Scaffold( 
      bottomNavigationBar: my_bottom_bar(),
        appBar: my_app_bar(),
        body: Obx(() {
          _fadeController.reset();
          _fadeController.forward();
          return FadeTransition(
            opacity: _fadeAnimation,
            child: tabs[currentIndex.value],
          );
        }),
        backgroundColor: Colors.white,
      );
  }

  // ignore: non_constant_identifier_names
  Widget my_bottom_bar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14),
        child: Obx(() {
          final _ = LocaleService.to.code.value; // rebuild on language change
          return GNav(
          selectedIndex: currentIndex.value,
          onTabChange: (index) => currentIndex.value = index,
          gap: 6,
          backgroundColor: Colors.white,
          color: Colors.grey[500]!,
          activeColor: Colors.white,
          tabBackgroundColor: myTheme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          duration: const Duration(milliseconds: 350),
          tabBorderRadius: 20,
          tabs: [
            GButton(icon: Icons.home_rounded, text: "common.home".tr),
            GButton(icon: Icons.category, text: "common.categories_tab".tr),
            GButton(icon: Icons.list_alt_rounded, text: "common.orders_tab".tr),
            GButton(icon: Icons.person_rounded, text: "common.account_tab".tr),
          ],
        );
        }),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  PreferredSizeWidget my_app_bar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      toolbarHeight: 60,
      automaticallyImplyLeading: false,
      titleSpacing: 12,
      title: Row(
        children: [
          // LEFT HALF: notification icon + "سلتي" cart chip
          Expanded(
            child: Row(
              children: [
                Obx(() => badges.Badge(
                  showBadge: _badges.unreadNotifications.value > 0,
                  badgeContent: Text(
                    '${_badges.unreadNotifications.value}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  position: badges.BadgePosition.topEnd(top: -4, end: -4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      _badges.clearNotifications();
                      Get.to(const notification(),
                          duration: const Duration(milliseconds: 500),
                          transition: Transition.rightToLeftWithFade);
                    },
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: myTheme.secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.notifications_active_rounded,
                          color: myTheme.primaryColor, size: 22),
                    ),
                  ),
                )),
                const SizedBox(width: 8),
                CartBadge(
                  position:
                      badges.BadgePosition.topEnd(top: -6, end: -2),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: openShoppingCart,
                    child: Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: myTheme.primaryColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_basket_rounded,
                              color: myTheme.primaryColor, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'سلتي',
                            style: TextStyle(
                              fontFamily: "Tajawal",
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: myTheme.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // RIGHT HALF: search field
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.to(const SearchResAndProd(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.rightToLeftWithFade);
              },
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: myTheme.secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded,
                        color: myTheme.primaryColor, size: 20),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'بحث',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 14,
                          color: myTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}