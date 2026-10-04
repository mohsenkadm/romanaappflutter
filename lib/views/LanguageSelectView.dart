import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/core/locale/locale_service.dart';
import 'package:romanaappflutter/main.dart';

/// شاشة اختيار اللغة عند أول تشغيل (افتراضي: عربي).
class LanguageSelectView extends StatefulWidget {
  const LanguageSelectView({Key? key, this.onDone}) : super(key: key);

  /// يُستدعى بعد الحفظ — إن وُجد يُستخدم بدل الانتقال الافتراضي.
  final VoidCallback? onDone;

  @override
  State<LanguageSelectView> createState() => _LanguageSelectViewState();
}

class _LanguageSelectViewState extends State<LanguageSelectView> {
  String _selected = 'ar';

  @override
  void initState() {
    super.initState();
    _selected = LocaleService.to.code.value;
  }

  Future<void> _continue() async {
    await LocaleService.to.setLocale(_selected);
    if (widget.onDone != null) {
      widget.onDone!();
    } else {
      Get.offAll(() => _resolveHomeAfterLocale());
    }
  }

  Widget _resolveHomeAfterLocale() {
    // يُعاد استخدام منطق main عبر استيراد lazy — نمرّر عبر Get.off في main.
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final primary = myTheme.primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primary.withOpacity(0.08),
                    border: Border.all(color: primary.withOpacity(0.15), width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      'assets/images/icon.png',
                      width: 64,
                      height: 64,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.85, 0.85)),
              const SizedBox(height: 28),
              Text(
                'lang.title'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[850],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'lang.subtitle'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 40),
              _LangCard(
                title: 'العربية',
                subtitle: 'Arabic',
                selected: _selected == 'ar',
                flag: 'ع',
                onTap: () => setState(() => _selected = 'ar'),
              ),
              const SizedBox(height: 14),
              _LangCard(
                title: 'English',
                subtitle: 'الإنجليزية',
                selected: _selected == 'en',
                flag: 'EN',
                onTap: () => setState(() => _selected = 'en'),
              ),
              const Spacer(),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    _selected == 'ar'
                        ? 'lang.continue_ar'.tr
                        : 'lang.continue_en'.tr,
                    style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}

class _LangCard extends StatelessWidget {
  const _LangCard({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.flag,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final String flag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: selected ? primary.withOpacity(0.08) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: selected ? primary : Colors.grey.shade300,
              width: selected ? 2 : 1.2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: primary.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? primary : Colors.grey.shade200,
                ),
                child: Text(
                  flag,
                  style: GoogleFonts.cairo(
                    color: selected ? Colors.white : Colors.grey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850],
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(
                          fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(
                selected
                    ? Icons.check_circle_rounded
                    : Icons.circle_outlined,
                color: selected ? primary : Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
