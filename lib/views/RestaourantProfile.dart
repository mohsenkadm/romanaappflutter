import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/FillProduct.dart';
import 'package:romanaappflutter/Controller/RestaourantProfileController.dart'; 
import 'package:romanaappflutter/main.dart'; 
import 'package:romanaappflutter/views/StarsView.dart';
import 'package:romanaappflutter/Constant/cart_badge.dart';
import 'package:shimmer/shimmer.dart';

class RestaourantProfile extends StatefulWidget {
  const RestaourantProfile({Key? key}) : super(key: key);

  @override
  _RestaourantProfileState createState() => _RestaourantProfileState();
}

class _RestaourantProfileState extends State<RestaourantProfile> {
  late final RestaourantProfileController restourentController;

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _chipScrollController = ScrollController();
  final GlobalKey _topContentKey = GlobalKey();
  final Map<int, GlobalKey> _sectionKeys = {};
  final Map<int, GlobalKey> _chipKeys = {};
  int? _lastVisibleSubId;
  bool _ignoreScrollSync = false;

  static const double _gridHPad = 10;
  static const double _gridMainSpacing = 10;
  static const double _gridCrossSpacing = 10;
  static const double _childAspectRatio = 0.85;
  static const double _sectionVPad = 10; // fromLTRB 6+4

  @override
  void initState() {
    super.initState();
    final resId = (Get.arguments as List)[0].toString();
    if (Get.isRegistered<RestaourantProfileController>()) {
      Get.delete<RestaourantProfileController>();
    }
    restourentController = Get.put(
      RestaourantProfileController(resId: resId),
    );
    restourentController.onSectionScrollRequest = _scrollToSection;
    _scrollController.addListener(_onScrollUpdate);
  }

  void _ensureSectionKey(int subId) {
    _sectionKeys.putIfAbsent(subId, GlobalKey.new);
  }

  GlobalKey _chipKeyFor(int subId) =>
      _chipKeys.putIfAbsent(subId, GlobalKey.new);

  double _gridItemHeight(double viewportWidth) {
    final usable = viewportWidth - (_gridHPad * 2) - _gridCrossSpacing;
    final itemWidth = usable / 2;
    return itemWidth / _childAspectRatio;
  }

  double _sectionHeight(int productCount, double viewportWidth) {
    if (productCount <= 0) return 8;
    final rows = (productCount + 1) ~/ 2;
    final itemH = _gridItemHeight(viewportWidth);
    final gridH =
        rows * itemH + (rows > 0 ? (rows - 1) * _gridMainSpacing : 0);
    return 8 + _sectionVPad + gridH;
  }

  double _sectionHeightFor(ProductSection section, double viewportWidth) {
    if (RestaourantProfileController.isMostOrderedSubId(section.subId)) {
      // badge row + horizontal list + paddings
      return 8 + 48 + 210 + 14;
    }
    return _sectionHeight(section.products.length, viewportWidth);
  }

  /// Absolute scroll offset where [subId] section is fully visible
  /// just below the pinned category chips (not hidden underneath them).
  double? _offsetForSection(int subId) {
    final sections = restourentController.productSections;
    final index = sections.indexWhere((s) => s.subId == subId);
    if (index < 0) return null;

    final topObj = _topContentKey.currentContext?.findRenderObject();
    final topHeight =
        (topObj is RenderBox && topObj.hasSize) ? topObj.size.height : 280.0;
    // Header + gap only. Do NOT add sticky height: pinned chips overlap
    // following content, so including them pushes the first row under the bar.
    var offset = _sectionsAnchor(topHeight);

    final width = MediaQuery.sizeOf(context).width;
    for (var i = 0; i < index; i++) {
      offset += _sectionHeightFor(sections[i], width);
    }
    return offset;
  }

  /// Jump product list to the tapped category section.
  Future<void> _scrollToSection(int subId) async {
    _ignoreScrollSync = true;
    _lastVisibleSubId = subId;
    restourentController.SubIdActive.value = subId;
    _scrollChipToActive(subId);

    // Wait until sections are laid out / loaded.
    for (var attempt = 0; attempt < 12; attempt++) {
      if (!mounted) return;
      if (!_scrollController.hasClients) {
        await WidgetsBinding.instance.endOfFrame;
        continue;
      }

      final target = _offsetForSection(subId);
      if (target == null) {
        await WidgetsBinding.instance.endOfFrame;
        continue;
      }

      final clamped = target.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );

      await _scrollController.animateTo(
        clamped.toDouble(),
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
      break;
    }

    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (mounted) {
      restourentController.SubIdActive.value = subId;
      _ignoreScrollSync = false;
    }
  }

  void _scrollChipToActive(int subId) {
    // Center the active chip in the horizontal bar only (not the product list).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_chipScrollController.hasClients) return;
      final ctx = _chipKeys[subId]?.currentContext;
      if (ctx != null) {
        final obj = ctx.findRenderObject();
        if (obj is RenderBox && obj.hasSize) {
          final viewport = RenderAbstractViewport.maybeOf(obj);
          if (viewport != null) {
            final reveal = viewport.getOffsetToReveal(obj, 0.5);
            final target = reveal.offset.clamp(
              0.0,
              _chipScrollController.position.maxScrollExtent,
            );
            if ((_chipScrollController.offset - target).abs() > 1.5) {
              _chipScrollController.animateTo(
                target,
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
              );
            }
            return;
          }
        }
      }
      final index = restourentController.itemSubCategory
          .indexWhere((s) => s.SubCategoriesId == subId);
      if (index < 0) return;
      final viewport = _chipScrollController.position.viewportDimension;
      const approxChip = 100.0;
      final target = (index * approxChip) - (viewport / 2) + (approxChip / 2);
      _chipScrollController.animateTo(
        target.clamp(0.0, _chipScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    });
  }

  /// Scroll position where product sections sit just below the pinned chips.
  double _sectionsAnchor(double topHeight) => topHeight + 8;

  void _onScrollUpdate() {
    if (_ignoreScrollSync || restourentController.isSearchActive) return;
    if (!_scrollController.hasClients) return;

    final sections = restourentController.productSections;
    if (sections.isEmpty) return;

    final topObj = _topContentKey.currentContext?.findRenderObject();
    final topHeight =
        (topObj is RenderBox && topObj.hasSize) ? topObj.size.height : 280.0;
    final width = MediaQuery.sizeOf(context).width;
    final scrollY = _scrollController.offset;
    final sectionsStart = _sectionsAnchor(topHeight);

    // Still on restaurant header / before products → keep first category.
    if (scrollY < sectionsStart - 4) {
      final firstId = sections.first.subId;
      if (firstId != _lastVisibleSubId) {
        _lastVisibleSubId = firstId;
        restourentController.updateActiveSectionFromScroll(firstId);
        _scrollChipToActive(firstId);
      }
      return;
    }

    // Activate a section only after its top has reached the sticky bar.
    // Use scrollY itself (not ahead of it) so earlier products stay focused
    // while they still fill the top of the list.
    final probe = scrollY + 6;
    var activeSubId = sections.first.subId;
    var start = sectionsStart;
    for (final section in sections) {
      final h = _sectionHeightFor(section, width);
      if (probe >= start) {
        activeSubId = section.subId;
      } else {
        break;
      }
      start += h;
    }

    if (activeSubId != _lastVisibleSubId) {
      _lastVisibleSubId = activeSubId;
      restourentController.updateActiveSectionFromScroll(activeSubId);
      _scrollChipToActive(activeSubId);
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    _scrollController.removeListener(_onScrollUpdate);
    _scrollController.dispose();
    _chipScrollController.dispose();
    if (Get.isRegistered<RestaourantProfileController>()) {
      Get.delete<RestaourantProfileController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: openShoppingCart,
            backgroundColor: myTheme.primaryColor,
            icon: const CartBadge(
              child: Icon(Icons.shopping_cart_rounded, color: Colors.white),
            ),
            label: Text('عرض سلتك',
                style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
            appBar: MyAppBar(),
            body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () => restourentController.fetchData(forceRefresh: true),
              child: Obx(() {
                // Rebuild when catalog sections finish loading.
                restourentController.catalogRevision.value;
                restourentController.sectionsLoading.value;
                return CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                  SliverToBoxAdapter(
                    child: KeyedSubtree(
                      key: _topContentKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          restourentController.isloded.value
                              ? Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Column(children: [
                                    Container(
                                        width: double.infinity,
                                        height: 200,
                                        color: Colors.white),
                                    const SizedBox(height: 12),
                                    Container(
                                        width: 80,
                                        height: 80,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle)),
                                    const SizedBox(height: 8),
                                    Container(
                                        width: 160,
                                        height: 18,
                                        color: Colors.white),
                                  ]))
                              : _buildRestaurantHeader(context),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(14),
                            ),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            child: TextField(
                              controller: textEditingController,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              onChanged: restourentController.searchProducts,
                              decoration: InputDecoration(
                                hintTextDirection: TextDirection.rtl,
                                hintText: 'ابحث عن المنتجات',
                                hintStyle: GoogleFonts.cairo(
                                    color: Colors.grey[500], fontSize: 14),
                                prefixIcon: Icon(Icons.search_rounded,
                                    color: myTheme.primaryColor),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    textEditingController.clear();
                                    restourentController.clearSearch();
                                  },
                                  icon: Icon(Icons.close_rounded,
                                      color: Colors.grey[400]),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 14, horizontal: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 8)),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _StickySubCategoryDelegate(
                      controller: restourentController,
                      chipScrollController: _chipScrollController,
                      chipKeyFor: _chipKeyFor,
                    ),
                  ),
                  ..._productSlivers(),
                ],
              );
              }),
            ));
  }

  List<Widget> _productSlivers() {
    final loading = restourentController.islodedprod.value &&
        restourentController.productSections.isEmpty &&
        (restourentController.sectionsLoading.value ||
            restourentController.islodedsub.value);

    if (loading) {
      return [
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                ),
              ),
              childCount: 6,
            ),
          ),
        ),
      ];
    }

    final sections = restourentController.productSections;
    if (sections.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'لا توجد منتجات',
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(color: Colors.grey[600]),
            ),
          ),
        ),
      ];
    }

    final slivers = <Widget>[];
    for (final section in sections) {
      _ensureSectionKey(section.subId);
      final sectionKey = _sectionKeys[section.subId]!;
      final isMostOrdered =
          RestaourantProfileController.isMostOrderedSubId(section.subId);

      if (isMostOrdered) {
        slivers.add(
          SliverToBoxAdapter(
            child: KeyedSubtree(
              key: sectionKey,
              child: _buildMostOrderedHorizontal(section),
            ),
          ),
        );
        continue;
      }

      // Key must be on a box child (not the Sliver) to avoid RenderSliver cast errors.
      slivers.add(
        SliverToBoxAdapter(
          child: SizedBox(key: sectionKey, height: 0),
        ),
      );
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.85,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => RepaintBoundary(
                child: FillProduct(
                  items: section.products[index],
                  index: index,
                  isGrid: true,
                ),
              ),
              childCount: section.products.length,
              addRepaintBoundaries: true,
            ),
          ),
        ),
      );
    }
    slivers.add(const SliverToBoxAdapter(child: SizedBox(height: 80)));
    return slivers;
  }

  Widget _buildMostOrderedHorizontal(ProductSection section) {
    final accent = const Color(0xFFE53935);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent,
                      accent.withOpacity(0.82),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.30),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.22),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_fire_department_rounded,
                          color: Colors.white, size: 15),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'الأكثر مبيعا',
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            itemCount: section.products.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 148,
                child: RepaintBoundary(
                  child: FillProduct(
                    items: section.products[index],
                    index: index,
                    isGrid: true,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(delay: Duration(milliseconds: 40 * index))
                  .slideX(begin: 0.08, end: 0);
            },
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  // ─── Beautiful restaurant header ──────────────────────────────────────────
  Widget _buildRestaurantHeader(BuildContext context) {
    final r = restourentController.item.value;
    final primary = Theme.of(context).primaryColor;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Hero image with gradient overlay
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: 220,
              child: CachedNetworkImage(
                imageUrl: r.background ?? '',
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: Colors.grey[200]),
                errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: Icon(Icons.restaurant, color: Colors.grey[400], size: 60)),
              ),
            ),
            // Bottom dark gradient
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  ),
                ),
              ),
            ),
            // Restaurant name over image
            Positioned(
              bottom: 14,
              right: 16,
              left: 80,
              child: Text(
                r.name ?? '',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 8)]),
              ),
            ),
            // Logo circle at bottom-right overlapping image
            Positioned(
              bottom: -36,
              right: 16,
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ],
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: r.logo ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) =>
                        Icon(Icons.restaurant, color: primary, size: 36),
                  ),
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms),

        const SizedBox(height: 36), // space for overlapping logo

        // Info row: stars, min order, location, rate button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Rate button
              GestureDetector(
                onTap: () {
                  if (r.isStars == true) {
                    Get.to(() => const StarsView(),
                        arguments: [r.restaurantId.toString()],
                        duration: const Duration(milliseconds: 500),
                        transition: Transition.fade);
                  } else {
                    ErrorMessage.SnackMessage('res.no_rate_now'.tr, Colors.orange[600]!);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3))
                    ],
                  ),
                  child: Row(children: [
                    const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text('res.rate'.tr, style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ]),
                ),
              ),

              // Stats chips
              Row(
                children: [
                  _infoChip(context, Icons.star_rounded, '${r.starCount ?? 0}',
                      color: Colors.amber[600]!),
                  const SizedBox(width: 8),
                  _infoChip(context, Icons.currency_exchange,
                      '${r.minimumPrice ?? 0} د.ع'),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 350.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 10),

        // Address row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${r.address ?? ''}, ${r.areaname ?? ''}',
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[600]),
              ),
              const SizedBox(width: 4),
              Icon(Icons.location_on, size: 15, color: primary),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 350.ms),

        const SizedBox(height: 4),

        // Divider
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Divider(color: Colors.grey[200], thickness: 1),
        ),
      ],
    );
  }

  Widget _infoChip(BuildContext context, IconData icon, String label,
      {Color? color}) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (color ?? primary).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(children: [
        Icon(icon, size: 14, color: color ?? primary),
        const SizedBox(width: 4),
        Text(label,
            style: GoogleFonts.cairo(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color ?? primary)),
      ]),
    );
  }

  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
      actions: [
        CartIconButton(
          iconColor: myTheme.primaryColor,
          backgroundColor: myTheme.secondaryHeaderColor,
        ),
      ],
      elevation: 2,
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            restourentController.OnClose();
          },
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor)),
    );
  }
}

/// شريط الأصناف ثابت أعلى القائمة أثناء التمرير.
class _StickySubCategoryDelegate extends SliverPersistentHeaderDelegate {
  _StickySubCategoryDelegate({
    required this.controller,
    required this.chipScrollController,
    required this.chipKeyFor,
  });

  final RestaourantProfileController controller;
  final ScrollController chipScrollController;
  final GlobalKey Function(int subId) chipKeyFor;

  static const double _height = 58;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      elevation: overlapsContent ? 3 : 0,
      color: Colors.white,
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          color: Colors.white,
          border: overlapsContent
              ? Border(bottom: BorderSide(color: Colors.grey[200]!))
              : null,
        ),
        child: Obx(() {
          final activeSubId = controller.SubIdActive.value;
          if (controller.islodedsub.value) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 6,
              itemBuilder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 90,
                  height: 36,
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }

          return ListView.builder(
            controller: chipScrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: controller.itemSubCategory.length,
            itemBuilder: (context, index) {
              final sub = controller.itemSubCategory[index];
              final isActive = activeSubId == sub.SubCategoriesId;
              const activeRed = Color(0xFFE53935);
              return KeyedSubtree(
                key: chipKeyFor(sub.SubCategoriesId),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: GestureDetector(
                    onTap: () =>
                        controller.ChooseSubCategory(sub.SubCategoriesId),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? activeRed : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? activeRed : Colors.grey[300]!,
                          width: isActive ? 1.8 : 1.2,
                        ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: activeRed.withOpacity(0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Text(
                        sub.SubCategoriesName,
                        style: GoogleFonts.cairo(
                          color: isActive ? Colors.white : Colors.grey[700],
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _StickySubCategoryDelegate oldDelegate) =>
      oldDelegate.controller != controller ||
      oldDelegate.chipScrollController != chipScrollController ||
      oldDelegate.chipKeyFor != chipKeyFor;
}
