import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Model/CategoriesModel.dart';
import 'package:romanaappflutter/views/AllRestaourent.dart';
import 'package:shimmer/shimmer.dart';

class FillcategoriesData extends StatelessWidget {
  const FillcategoriesData({Key? key, required this.items, this.index = 0})
      : super(key: key);
  final CategoriesModel items;
  final int index;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final details = items.CategoriesDetails?.trim();
    return GestureDetector(
      onTap: () => Get.to(
        () => const AllRestaourent(),
        arguments: [items.CategoriesId.toString()],
        duration: const Duration(milliseconds: 450),
        transition: Transition.rightToLeftWithFade,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: primary.withValues(alpha: 0.18), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primary.withValues(alpha: 0.06),
                border: Border.all(color: primary.withValues(alpha: 0.15)),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: items.CategoriesImages,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Center(child: CircularProgressIndicator(color: primary, strokeWidth: 2)),
                errorWidget: (_, __, ___) =>
                    Icon(Icons.category_rounded, color: primary, size: 32),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              items.CategoriesName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A2E),
              ),
            ),
            if (details != null && details.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                details,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate(delay: (40 * index).ms)
        .fadeIn(duration: 280.ms)
        .slideY(begin: 0.08, end: 0);
  }
}

class GetShimmercategories extends StatelessWidget {
  const GetShimmercategories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.92,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
