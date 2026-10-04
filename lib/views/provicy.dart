import 'package:flutter/material.dart';
import 'package:get/get.dart';

class proficy extends StatelessWidget {
  const proficy({Key? key}) : super(key: key);

  static const Color _primary = Color(0xFFDB2820);
  static const Color _primaryLight = Color(0x1FDB2820);

  // ── Policy sections data ────────────────────────────────────────────────────
  static const List<_PolicySection> _sections = [
    _PolicySection(
      number: '١',
      icon: Icons.info_outline_rounded,
      title: 'المعلومات التي نقوم بجمعها',
      content: '',
      subsections: [
        _SubSection(
          label: 'أ. المعلومات الشخصية:',
          bullets: [
            'الاسم الكامل',
            'رقم الهاتف',
            'البريد الإلكتروني',
            'عنوان التوصيل',
            'معلومات الدفع (عبر مزودي خدمة الدفع الآمن)',
          ],
        ),
        _SubSection(
          label: 'ب. معلومات الاستخدام:',
          bullets: [
            'سجل الطلبات',
            'الموقع الجغرافي لتحديد أقرب المتاجر والسائقين',
            'بيانات الجهاز (نوع الجهاز، نظام التشغيل، عنوان IP)',
          ],
        ),
      ],
    ),
    _PolicySection(
      number: '٢',
      icon: Icons.manage_accounts_rounded,
      title: 'كيفية استخدام المعلومات',
      content: 'نستخدم معلوماتك للأغراض التالية:',
      subsections: [
        _SubSection(
          label: '',
          bullets: [
            'معالجة وتنفيذ الطلبات',
            'تحسين تجربة المستخدم',
            'تقديم الدعم الفني',
            'إرسال الإشعارات المتعلقة بالطلبات والعروض',
            'تحسين خدماتنا وتحليل الأداء',
          ],
        ),
      ],
    ),
    _PolicySection(
      number: '٣',
      icon: Icons.share_rounded,
      title: 'مشاركة المعلومات',
      content:
          'نحن لا نبيع بياناتك الشخصية لأي طرف ثالث. قد تتم مشاركة المعلومات فقط مع:',
      subsections: [
        _SubSection(
          label: '',
          bullets: [
            'المتاجر والبائعين لإتمام الطلب',
            'السائقين لتوصيل الطلبات',
            'مزودي خدمات الدفع',
            'الجهات القانونية عند الطلب الرسمي',
          ],
        ),
      ],
    ),
    _PolicySection(
      number: '٤',
      icon: Icons.security_rounded,
      title: 'حماية البيانات',
      content: 'نستخدم إجراءات أمنية وتقنية متقدمة لحماية بياناتك من:',
      subsections: [
        _SubSection(
          label: '',
          bullets: [
            'الوصول غير المصرح به',
            'التعديل أو الحذف غير القانوني',
            'التسريب أو الاختراق',
          ],
        ),
      ],
    ),
    _PolicySection(
      number: '٥',
      icon: Icons.cookie_rounded,
      title: 'ملفات تعريف الارتباط (Cookies)',
      content:
          'قد نستخدم ملفات تعريف الارتباط لتحسين الأداء وتجربة الاستخدام.',
      subsections: [],
    ),
    _PolicySection(
      number: '٦',
      icon: Icons.verified_user_rounded,
      title: 'حقوق المستخدم',
      content: 'يحق لك:',
      subsections: [
        _SubSection(
          label: '',
          bullets: [
            'الوصول إلى بياناتك',
            'تعديل بياناتك',
            'حذف حسابك',
            'إلغاء الاشتراك في الرسائل التسويقية',
          ],
        ),
      ],
    ),
    _PolicySection(
      number: '٧',
      icon: Icons.storage_rounded,
      title: 'الاحتفاظ بالبيانات',
      content:
          'نحتفظ ببياناتك طالما كان ذلك ضرورياً لتقديم الخدمات أو وفقاً للقوانين المحلية.',
      subsections: [],
    ),
    _PolicySection(
      number: '٨',
      icon: Icons.update_rounded,
      title: 'التعديلات على السياسة',
      content:
          'قد نقوم بتحديث سياسة الخصوصية من وقت لآخر، وسيتم إشعار المستخدمين بأي تغييرات مهمة.',
      subsections: [],
    ),
    _PolicySection(
      number: '٩',
      icon: Icons.contact_support_rounded,
      title: 'التواصل معنا',
      content: 'إذا كانت لديك أي استفسارات حول سياسة الخصوصية، يمكنك التواصل معنا عبر:',
      subsections: [
        _SubSection(
          label: '',
          bullets: [
            'البريد الإلكتروني: support@rummana.app',
            'الهاتف: ',
          ],
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: CustomScrollView(
        slivers: [
          // ── Hero AppBar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: _primary,
            foregroundColor: Colors.white,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Gradient background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFDB2820), Color(0xFFFF6B6B)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                  // Decorative circles
                  Positioned(
                    top: -30,
                    left: -30,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.07),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    right: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.07),
                      ),
                    ),
                  ),
                  // Content
                  Positioned(
                    bottom: 28,
                    right: 24,
                    left: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const SizedBox(width: 10),
                            const Text(
                              'سياسة الخصوصية',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.privacy_tip_rounded,
                                  color: Colors.white, size: 26),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'تطبيق رمانة (Rummana)',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'آخر تحديث: ٢٠٢٥',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Intro banner ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryLight,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _primary.withOpacity(0.2)),
                ),
                child: const Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Icon(Icons.favorite_rounded, color: _primary, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'في تطبيق رمانة، نحترم خصوصيتك ونلتزم بحماية بياناتك الشخصية.',
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 13,
                          color: _primary,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Policy sections ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) =>
                    _buildSectionCard(context, _sections[index]),
                childCount: _sections.length,
              ),
            ),
          ),

          // ── Footer agreement ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDB2820), Color(0xFFFF6B6B)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _primary.withOpacity(0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.handshake_rounded,
                        color: Colors.white, size: 32),
                    const SizedBox(height: 10),
                    const Text(
                      'باستخدامك تطبيق رمانة، فإنك توافق على سياسة الخصوصية هذه',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.6,
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

  Widget _buildSectionCard(BuildContext context, _PolicySection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Section header
            Row(
              textDirection: TextDirection.rtl,
              children: [
                // Number badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      section.number,
                      style: const TextStyle(
                        color: _primary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    section.title,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(section.icon, color: _primary, size: 18),
                ),
              ],
            ),

            if (section.content.isNotEmpty) ...[
              const SizedBox(height: 10),
              const Divider(color: Color(0xFFF0F0F0), thickness: 1),
              const SizedBox(height: 8),
              Text(
                section.content,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF555555),
                  height: 1.7,
                ),
              ),
            ],

            // Subsections
            for (final sub in section.subsections) ...[
              if (sub.label.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  sub.label,
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
              const SizedBox(height: 6),
              for (final bullet in sub.bullets)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 7, left: 8),
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _primary,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          bullet,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF555555),
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Data models ──────────────────────────────────────────────────────────────

class _SubSection {
  final String label;
  final List<String> bullets;
  const _SubSection({required this.label, required this.bullets});
}

class _PolicySection {
  final String number;
  final IconData icon;
  final String title;
  final String content;
  final List<_SubSection> subsections;
  const _PolicySection({
    required this.number,
    required this.icon,
    required this.title,
    required this.content,
    required this.subsections,
  });
}

