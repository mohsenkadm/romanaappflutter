import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Controller/SupportPhoneController.dart';
import 'package:romanaappflutter/views/Accounts.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/views/CoverageGate.dart';
import 'package:romanaappflutter/views/EditProfile.dart';
import 'package:romanaappflutter/views/login.dart';
import 'package:romanaappflutter/views/provicy.dart';
import 'package:romanaappflutter/views/questions_view.dart';
import 'package:romanaappflutter/core/locale/locale_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AboutApp.dart';

class Profileuser extends StatefulWidget {
  const Profileuser({Key? key}) : super(key: key);

  @override
  _ProfileuserState createState() => _ProfileuserState();
}

class _ProfileuserState extends State<Profileuser>
    with SingleTickerProviderStateMixin {
  late final ProfileuserController _controller;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<ProfileuserController>()
        ? Get.find<ProfileuserController>()
        : Get.put(ProfileuserController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.fetchData();
    });
    _animController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedItem(int index, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(
          (index * 0.07).clamp(0.0, 0.85),
          ((index * 0.07) + 0.4).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _animController,
          curve: Interval(
            (index * 0.07).clamp(0.0, 0.85),
            ((index * 0.07) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        )),
        child: child,
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? customLeading,
    Color? iconColor,
    Color? iconBg,
  }) {
    final primary = Theme.of(context).primaryColor;
    final bg = iconBg ?? Theme.of(context).secondaryHeaderColor;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              // Arrow icon on left (RTL: at start of row = visual left)
              Icon(Icons.arrow_back_ios_new_rounded,
                  size: 14, color: Colors.grey[400]),
              const Spacer(),
              // Title + subtitle in center-right
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Icon container on the right
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: bg,
                ),
                child: customLeading ??
                    Icon(icon, color: iconColor ?? primary, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Profile Header ──────────────────────────────────────────────────────────
  Widget _buildGuestHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.75),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.2),
                border:
                    Border.all(color: Colors.white.withOpacity(0.5), width: 2),
              ),
              child: const Icon(Icons.person_outline_rounded,
                  color: Colors.white, size: 38),
            ),
            const SizedBox(height: 14),
            const Text(
              'مرحباً بك في رمانة',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'سجّل دخولك للاستمتاع بجميع المزايا',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Get.to(
                  () => const Login(),
                  duration: const Duration(milliseconds: 500),
                  transition: Transition.rightToLeftWithFade,
                )?.then((_) => _controller.fetchData()),
                icon: const Icon(Icons.phone_android_rounded, size: 20),
                label: const Text('دخول برقم الواتساب'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedInHeader(dynamic user) {
    final initials = (user.Name as String)
        .trim()
        .split(' ')
        .take(2)
        .map((w) => w.isNotEmpty ? w[0] : '')
        .join();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            const Color(0xFFFF6B6B),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            // Edit & logout buttons on the left
            Column(
              children: [
                _iconActionButton(
                  icon: Icons.edit_rounded,
                  onTap: () => Get.to(
                    () => const EditProfile(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.rightToLeftWithFade,
                  ),
                  tooltip: 'تعديل',
                ),
                const SizedBox(height: 8),
                _iconActionButton(
                  icon: Icons.logout_rounded,
                  onTap: () {
                    AwesomeDialog(
                      buttonsBorderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                      context: context,
                      dialogType: DialogType.warning,
                      headerAnimationLoop: false,
                      animType: AnimType.bottomSlide,
                      title: 'تسجيل خروج',
                      reverseBtnOrder: true,
                      showCloseIcon: true,
                      btnOkText: 'نعم',
                      btnCancelText: 'إلغاء',
                      btnOkIcon: Icons.check_circle,
                      btnCancelIcon: Icons.cancel,
                      btnOkOnPress: () {
                        _controller.deleteuser(
                            id: _controller.user.value!.userId);
                      },
                      btnCancelOnPress: () {},
                      desc: 'هل تريد الخروج من الحساب حقاً؟',
                    ).show();
                  },
                  tooltip: 'خروج',
                ),
              ],
            ),
            const Spacer(),
            // User info on the right
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  user.Name ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      user.Phone ?? '',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 14),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.phone_rounded,
                        color: Colors.white70, size: 14),
                  ],
                ),
                if ((user.Address ?? '').toString().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        user.Address ?? '',
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 13),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.location_on_rounded,
                          color: Colors.white60, size: 14),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(width: 16),
            // Avatar
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.25),
                border: Border.all(
                    color: Colors.white.withOpacity(0.6), width: 2.5),
              ),
              child: Center(
                child: Text(
                  initials.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconActionButton(
      {required IconData icon,
      required VoidCallback onTap,
      String? tooltip}) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: tooltip ?? '',
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
            border:
                Border.all(color: Colors.white.withOpacity(0.4), width: 1.2),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  // ─── Notification tile ───────────────────────────────────────────────────────
  Widget _buildNotificationTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Obx(() => Switch(
                  onChanged: (_) => _controller.toggle(),
                  value: _controller.togglenotification.value,
                  activeColor: Theme.of(context).primaryColor,
                )),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('الإشعارات',
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                Text('تفعيل إشعارات الطلبات والعروض',
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: Icon(Icons.notifications_active_rounded,
                  color: Theme.of(context).primaryColor, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int itemIndex = 0;
    return RefreshIndicator(
      onRefresh: () => _controller.fetchData(),
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Profile header ─────────────────────────────────────────────
            _buildAnimatedItem(
              itemIndex++,
              Obx(() => _controller.user.value == null
                  ? _buildGuestHeader()
                  : _buildLoggedInHeader(_controller.user.value!)),
            ),

            // ── Section: الخدمات ───────────────────────────────────────────
            _buildAnimatedItem(
                itemIndex++, _buildSectionLabel('profile.services'.tr)),

            _buildAnimatedItem(
              itemIndex++,
              _buildMenuTile(
                icon: Icons.my_location_rounded,
                title: 'profile.update_location'.tr,
                subtitle: LocationStorage.zoneName != null
                    ? 'الزون: ${LocationStorage.zoneName}'
                    : 'تحديث الموقع والتحقق من التغطية',
                onTap: () async {
                  Get.to(
                    () => const CoverageGate(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.rightToLeftWithFade,
                  );
                },
              ),
            ),

            _buildAnimatedItem(
              itemIndex++,
              Obx(() {
                final lang = LocaleService.to.labelForCurrent();
                return _buildMenuTile(
                  icon: Icons.language_rounded,
                  title: 'profile.language'.tr,
                  subtitle: lang,
                  onTap: () => _showLanguageSheet(),
                );
              }),
            ),

            _buildAnimatedItem(
              itemIndex++,
              _buildMenuTile(
                icon: Icons.live_help_rounded,
                title: 'profile.help'.tr,
                subtitle: 'الأسئلة الشائعة والدعم',
                onTap: () => Get.to(
                  const QuestionsView(),
                  duration: const Duration(milliseconds: 500),
                  transition: Transition.rightToLeftWithFade,
                ),
              ),
            ),

            _buildAnimatedItem(
              itemIndex++,
              Obx(() {
                final support = SupportPhoneController.instance;
                return _buildMenuTile(
                  icon: Icons.support_agent_rounded,
                  title: 'تواصل مع الدعم',
                  subtitle: support.phone.value.isNotEmpty
                      ? support.phone.value
                      : 'اتصال أو واتساب',
                  onTap: () => support.showContactSheet(),
                );
              }),
            ),

            _buildAnimatedItem(itemIndex++, _buildNotificationTile()),

            // ── Section: عن التطبيق ────────────────────────────────────────
            _buildAnimatedItem(
                itemIndex++, _buildSectionLabel('profile.about'.tr)),

            _buildAnimatedItem(
              itemIndex++,
              _buildMenuTile(
                icon: Icons.share_rounded,
                title: 'profile.share'.tr,
                subtitle: 'شارك رمانة مع أصدقائك',
                onTap: () {
                  if (Platform.isAndroid || Platform.isIOS) {
                    Share.share(
                      'تطبيق رمانة.\n'
                      '"اختر ، اطلب ، استلم"\n'
                      'حمل التطبيق واستمتع بالخصومات\n'
                      'https://web.rummana.info',
                    );
                  }
                },
              ),
            ),

            _buildAnimatedItem(
              itemIndex++,
              _buildMenuTile(
                icon: Icons.info_rounded,
                title: 'عن رمانــة',
                onTap: () => Get.to(
                  const AboutApp(),
                  duration: const Duration(milliseconds: 500),
                  transition: Transition.rightToLeftWithFade,
                ),
              ),
            ),

            _buildAnimatedItem(
              itemIndex++,
              _buildMenuTile(
                icon: Icons.public_rounded,
                title: 'profile.accounts'.tr,
                subtitle: 'تابعنا على وسائل التواصل الاجتماعي',
                onTap: () => Get.to(
                  const Accounts(),
                  duration: const Duration(milliseconds: 500),
                  transition: Transition.rightToLeftWithFade,
                ),
              ),
            ),

            _buildAnimatedItem(
              itemIndex++,
              _buildMenuTile(
                icon: Icons.security_rounded,
                title: 'profile.privacy'.tr,
                subtitle: 'اطّلع على سياسة حماية بياناتك',
                onTap: () => Get.to(
                  const proficy(),
                  duration: const Duration(milliseconds: 500),
                  transition: Transition.rightToLeftWithFade,
                ),
              ),
            ),

            _buildAnimatedItem(
              itemIndex++,
              _buildMenuTile(
                icon: Icons.help_rounded,
                title: 'تعليمات التطبيق',
                subtitle: 'استعرض دليل استخدام التطبيق',
                onTap: () {
                  final urltele = Uri.parse("https://t.me/rummana_app");
                  launchUrl(urltele);
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _showLanguageSheet() {
    final current = LocaleService.to.code.value;
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'common.choose_language'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'common.language_subtitle'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Icon(Icons.check_circle,
                    color: current == 'ar'
                        ? Theme.of(Get.context!).primaryColor
                        : Colors.grey[300]),
                title: Text('common.arabic'.tr),
                onTap: () async {
                  await LocaleService.to.setLocale('ar');
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.check_circle,
                    color: current == 'en'
                        ? Theme.of(Get.context!).primaryColor
                        : Colors.grey[300]),
                title: Text('common.english'.tr),
                onTap: () async {
                  await LocaleService.to.setLocale('en');
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
