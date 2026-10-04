// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/views/RestaourantProfile.dart';
import 'package:shimmer/shimmer.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────

void _openRestaurant(RestaurantModel items, bool closed) {
  if (closed) {
    ErrorMessage.SnackMessage('res.closed_snack'.tr, Colors.red[400]!);
    return;
  }
  Get.to(() => const RestaourantProfile(),
      arguments: [items.restaurantId.toString()],
      duration: const Duration(milliseconds: 450),
      transition: Transition.fade);
}

Widget _starsBadge(int count,
    {double size = 12, Color textColor = Colors.white}) {
  return Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(Icons.star_rounded, size: size + 2, color: Colors.amber[400]),
    const SizedBox(width: 3),
    Text(
      count.toString(),
      style: GoogleFonts.cairo(
          color: textColor, fontSize: size, fontWeight: FontWeight.bold),
    ),
  ]);
}

Widget _chip({
  required IconData icon,
  required String label,
  required Color bg,
  required Color fg,
  double fontSize = 10.5,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
    decoration:
        BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(label,
          style: GoogleFonts.cairo(
              color: fg, fontSize: fontSize, fontWeight: FontWeight.w600)),
      const SizedBox(width: 4),
      Icon(icon, size: fontSize + 1, color: fg),
    ]),
  );
}

Widget _logoCircle(
    {required String url, required Color primary, double size = 44}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.white,
      border: Border.all(color: Colors.white, width: 2.5),
      boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 3))
      ],
    ),
    child: ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) =>
            Icon(Icons.storefront_rounded, color: primary, size: size * 0.5),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Grid card — used in "جميع المتاجر"
// ─────────────────────────────────────────────────────────────────────────────
class FillResData extends StatelessWidget {
  const FillResData({Key? key, required this.items, this.index = 0})
      : super(key: key);
  final RestaurantModel items;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool closed = items.isClosed == true;
    final primary = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => _openRestaurant(items, closed),
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 6)),
            BoxShadow(
                color: primary.withOpacity(0.08),
                blurRadius: 12,
                spreadRadius: 0,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Cover image ──────────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(22)),
              child: SizedBox(
                height: 118,
                child: Stack(fit: StackFit.expand, children: [
                  // Background image (grayscale when closed)
                  closed
                      ? ColorFiltered(
                          colorFilter: const ColorFilter.matrix(<double>[
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0.2126, 0.7152, 0.0722, 0, 0,
                            0, 0, 0, 1, 0,
                          ]),
                          child: CachedNetworkImage(
                            imageUrl: items.background ?? '',
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                                Container(color: const Color(0xFFF0F0F0)),
                            errorWidget: (_, __, ___) => Container(
                                color: const Color(0xFFF0F0F0),
                                child: Icon(Icons.storefront_rounded,
                                    color: Colors.grey[400], size: 38)),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: items.background ?? '',
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: const Color(0xFFF0F0F0)),
                          errorWidget: (_, __, ___) => Container(
                              color: const Color(0xFFF0F0F0),
                              child: Icon(Icons.storefront_rounded,
                                  color: Colors.grey[400], size: 38)),
                        ),
                  // Bottom gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.35, 1.0],
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(closed ? 0.75 : 0.62),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Closed overlay
                  if (closed)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.45),
                        alignment: Alignment.center,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.72),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.35),
                                  width: 1),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.35),
                                    blurRadius: 12)
                              ]),
                          child: Text('مغلق حاليا',
                              style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14)),
                        ),
                      ),
                    ),
                  // Stars badge — top left
                  if ((items.starCount ?? 0) > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber[700]!.withOpacity(0.92),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.amber.withOpacity(0.4),
                                blurRadius: 6)
                          ],
                        ),
                        child:
                            _starsBadge(items.starCount ?? 0, size: 10.5),
                      ),
                    ),
                  // Category badge — top right
                  if ((items.categoriesName ?? '').isNotEmpty)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                  color: primary.withOpacity(0.45),
                                  blurRadius: 6)
                            ]),
                        child: Text(
                          items.categoriesName!,
                          style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  // Restaurant name — bottom
                  Positioned(
                    bottom: 8,
                    right: 10,
                    left: 10,
                    child: Text(
                      items.name ?? '',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          shadows: const [
                            Shadow(
                                color: Colors.black54,
                                blurRadius: 6,
                                offset: Offset(0, 1))
                          ]),
                    ),
                  ),
                ]),
              ),
            ),

            // ── Info section ─────────────────────────────────────────────
            Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text column (RTL: text on left, logo on right)
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Location row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  items.areaname ?? items.address ?? '',
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.cairo(
                                      fontSize: 10.5,
                                      color: Colors.grey[500],
                                      height: 1.2),
                                ),
                              ),
                              const SizedBox(width: 3),
                              Icon(Icons.location_on_rounded,
                                  size: 12, color: primary),
                            ],
                          ),
                          if ((items.minimumPrice ?? 0) > 0) ...[
                            const SizedBox(height: 5),
                            Align(
                              alignment: Alignment.centerRight,
                              child: _chip(
                                icon: Icons.payments_rounded,
                                label: 'أدنى ${items.minimumPrice}₪',
                                bg: primary.withOpacity(0.09),
                                fg: primary,
                                fontSize: 9.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Logo
                    _logoCircle(
                        url: items.logo ?? '', primary: primary, size: 42),
                  ],
                ),
            ),

            // ── Bottom accent bar ─────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(22)),
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primary.withOpacity(0.0),
                      primary.withOpacity(0.5),
                      primary
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 60))
        .fadeIn(duration: 380.ms)
        .slideY(begin: 0.12, end: 0, curve: Curves.easeOutCubic);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Horizontal featured card — used in "المتاجر المفضلة"
// ─────────────────────────────────────────────────────────────────────────────
class FillResDataForTop extends StatelessWidget {
  const FillResDataForTop({Key? key, required this.items, this.index = 0})
      : super(key: key);
  final RestaurantModel items;
  final int index;

  @override
  Widget build(BuildContext context) {
    final bool closed = items.isClosed == true;
    final primary = Theme.of(context).primaryColor;
    const double logoSize = 52.0;
    const double logoOverlap = logoSize / 2; // 26px

    return GestureDetector(
      onTap: () => _openRestaurant(items, closed),
      child: Container(
        width: 298,
        margin: const EdgeInsets.fromLTRB(10, 6, 4, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 24,
                spreadRadius: 0,
                offset: const Offset(0, 8)),
            BoxShadow(
                color: primary.withOpacity(0.07),
                blurRadius: 14,
                spreadRadius: 0,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // ── Base column ───────────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // ── Cover image ───────────────────────────────────────────
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24)),
                  child: SizedBox(
                    height: 170,
                    child: Stack(fit: StackFit.expand, children: [
                      // Background image (grayscale when closed)
                      closed
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.matrix(<double>[
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0.2126, 0.7152, 0.0722, 0, 0,
                                0, 0, 0, 1, 0,
                              ]),
                              child: CachedNetworkImage(
                                imageUrl: items.background ?? '',
                                fit: BoxFit.cover,
                                placeholder: (_, __) =>
                                    Container(color: const Color(0xFFF0F0F0)),
                                errorWidget: (_, __, ___) => Container(
                                    color: const Color(0xFFF0F0F0),
                                    child: Icon(Icons.storefront_rounded,
                                        color: Colors.grey[400], size: 54)),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: items.background ?? '',
                              fit: BoxFit.cover,
                              placeholder: (_, __) =>
                                  Container(color: const Color(0xFFF0F0F0)),
                              errorWidget: (_, __, ___) => Container(
                                  color: const Color(0xFFF0F0F0),
                                  child: Icon(Icons.storefront_rounded,
                                      color: Colors.grey[400], size: 54)),
                            ),
                      // Strong gradient for text readability
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: const [0.0, 0.35, 1.0],
                              colors: [
                                Colors.black.withOpacity(0.12),
                                Colors.transparent,
                                Colors.black.withOpacity(closed ? 0.82 : 0.75),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Category badge — top right
                      if ((items.categoriesName ?? '').isNotEmpty)
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                      color: primary.withOpacity(0.45),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2))
                                ]),
                            child: Text(
                              items.categoriesName!,
                              style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      // Closed overlay
                      if (closed)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.45),
                            alignment: Alignment.center,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.72),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.35),
                                      width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.35),
                                        blurRadius: 14)
                                  ]),
                              child: Text('مغلق حاليا',
                                  style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ),
                          ),
                        ),
                      // Restaurant name + stars — bottom of image
                      Positioned(
                        bottom: logoOverlap + 10,
                        left: 14,
                        right: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              items.name ?? '',
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  shadows: const [
                                    Shadow(
                                        color: Colors.black54,
                                        blurRadius: 6,
                                        offset: Offset(0, 1))
                                  ]),
                            ),
                            if ((items.starCount ?? 0) > 0) ...[
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                        color:
                                            Colors.amber[700]!.withOpacity(0.9),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: _starsBadge(items.starCount ?? 0,
                                        size: 11),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ]),
                  ),
                ),

                // ── Info section (below image) ────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 28, 14, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Location row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              '${items.areaname ?? ''} ${items.address ?? ''}'
                                  .trim(),
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                  fontSize: 12, color: Colors.grey[500]),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.place_rounded, size: 13, color: primary),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Action row: "اطلب الآن" + min price chip
                      Row(
                        children: [
                          // Order button
                          if (!closed)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 9),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    primary,
                                    primary.withOpacity(0.82)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                      color: primary.withOpacity(0.42),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4))
                                ],
                              ),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.shopping_bag_rounded,
                                        color: Colors.white, size: 16),
                                    const SizedBox(width: 6),
                                    Text('common.order_now'.tr,
                                        style: GoogleFonts.cairo(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold)),
                                  ]),
                            ),
                          const Spacer(),
                          // Min order chip
                          if ((items.minimumPrice ?? 0) > 0)
                            _chip(
                              icon: Icons.payments_rounded,
                              label: 'أدنى ${items.minimumPrice}₪',
                              bg: primary.withOpacity(0.09),
                              fg: primary,
                              fontSize: 10.5,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Logo overlapping image / info boundary ─────────────────────
            Positioned(
              top: 170 - logoOverlap, // imageHeight - half logo
              left: 16,
              child: Container(
                width: logoSize,
                height: logoSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: items.logo ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Icon(
                        Icons.storefront_rounded,
                        color: primary,
                        size: logoSize * 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 70))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.12, end: 0, curve: Curves.easeOutCubic);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer placeholders
// ─────────────────────────────────────────────────────────────────────────────
class GetShimmerRes extends StatelessWidget {
  const GetShimmerRes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 298,
            margin: const EdgeInsets.fromLTRB(10, 6, 4, 14),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Image placeholder
                Container(
                  height: 170,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                ),
                // Info placeholder
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 36, 14, 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                          height: 12,
                          width: 120,
                          color: Colors.white,
                          margin: const EdgeInsets.only(bottom: 8)),
                      Container(
                          height: 32,
                          width: double.infinity,
                          color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GetShimmerResAll extends StatelessWidget {
  const GetShimmerResAll({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:
            MediaQuery.of(context).size.width < 600 ? 2 : 3,
        childAspectRatio: 0.88,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image placeholder
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
                child: Container(height: 125, color: Colors.white),
              ),
              // Info placeholder
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                              height: 10, width: 80, color: Colors.white),
                          const SizedBox(height: 5),
                          Container(
                              height: 18, width: 110, color: Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
