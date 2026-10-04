import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Accounts extends StatefulWidget {
  const Accounts({Key? key}) : super(key: key);

  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  static const _accounts = <_SocialAccount>[
    _SocialAccount(
      title: 'إنستغرام',
      subtitle: '@rummana.food',
      url: 'https://www.instagram.com/rummana.food?stkn=dHJxMjhscmdkZGJm',
      icon: Icons.camera_alt_rounded,
      colors: [Color(0xFFF58529), Color(0xFFDD2A7B), Color(0xFF8134AF)],
    ),
    _SocialAccount(
      title: 'فيسبوك',
      subtitle: 'Rummana Food',
      url: 'https://www.facebook.com/share/1EQKpbQijf/?mibextid=wwXIfr',
      icon: Icons.facebook_rounded,
      colors: [Color(0xFF1877F2), Color(0xFF0D65D9)],
    ),
    _SocialAccount(
      title: 'تيك توك',
      subtitle: '@rummana.food',
      url: 'https://www.tiktok.com/@rummana.food?_r=1&_t=ZS9h163FfV9Z',
      icon: Icons.music_note_rounded,
      colors: [Color(0xFF161616), Color(0xFF25F4EE), Color(0xFFFE2C55)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F1),
      appBar: _buildAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
        physics: const BouncingScrollPhysics(),
        children: [
          _buildHero()
              .animate()
              .fadeIn(duration: 420.ms)
              .slideY(begin: 0.12, curve: Curves.easeOutCubic),
          const SizedBox(height: 22),
          ...List.generate(_accounts.length, (index) {
            final account = _accounts[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index == _accounts.length - 1 ? 0 : 14),
              child: _SocialCard(
                account: account,
                onTap: () => _openUrl(account.url),
              )
                  .animate(delay: (120 + index * 90).ms)
                  .fadeIn(duration: 420.ms)
                  .slideX(begin: 0.08, curve: Curves.easeOutCubic)
                  .scale(
                    begin: const Offset(0.96, 0.96),
                    curve: Curves.easeOutBack,
                  ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFFE53935), Color(0xFFC62828)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE53935).withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'تابع رمانة',
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر متابعتنا على إنستغرام، فيسبوك أو تيك توك لمعرفة العروض الجديدة.',
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
              color: Colors.white.withValues(alpha: 0.92),
              fontSize: 14,
              height: 1.55,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => navigator?.pop(),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFFE53935)),
      ),
      title: Text(
        'حساباتنا',
        style: GoogleFonts.cairo(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: const Color(0xFFE53935),
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر فتح الرابط',
            style: GoogleFonts.cairo(),
          ),
        ),
      );
    }
  }
}

class _SocialAccount {
  const _SocialAccount({
    required this.title,
    required this.subtitle,
    required this.url,
    required this.icon,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final String url;
  final IconData icon;
  final List<Color> colors;
}

class _SocialCard extends StatefulWidget {
  const _SocialCard({
    required this.account,
    required this.onTap,
  });

  final _SocialAccount account;
  final VoidCallback onTap;

  @override
  State<_SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<_SocialCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final account = widget.account;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: account.colors.first.withValues(alpha: 0.14),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F1EE),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: Color(0xFF6D655E),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      account.title,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2B2420),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      account.subtitle,
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8A8178),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: account.colors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: account.colors.first.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(account.icon, color: Colors.white, size: 28),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
