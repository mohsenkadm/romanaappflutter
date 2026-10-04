import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/FillImageProductsCarousel.dart';
import 'package:romanaappflutter/Controller/ProductController.dart';
import 'package:romanaappflutter/Controller/ShoppingCardController.dart';
import 'package:romanaappflutter/Model/ProductIngredientModel.dart';
import 'package:romanaappflutter/Model/ProductSizeModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/Constant/cart_badge.dart';
import 'package:shimmer/shimmer.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);
  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView>
    with SingleTickerProviderStateMixin {
  late AnimationController _cartBtnCtrl;

  final ProductController _controller = Get.put(ProductController());
  final ShoppingCardController _shopCtrl = Get.find<ShoppingCardController>();

  @override
  void initState() {
    super.initState();
    _cartBtnCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.noteController.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _controller.fetchData());
  }

  @override
  void dispose() {
    _cartBtnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final secondary = Theme.of(context).secondaryHeaderColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(primary, secondary),
      body: RefreshIndicator(
        color: primary,
        onRefresh: () => _controller.fetchData(),
        child: Obx(() {
          if (_controller.isloded.value) return _shimmerFull();
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _carousel(),
                _productHeader(primary),
                _priceAndQty(primary, secondary),
                _sizesSection(primary, secondary),
                _ingredientsSection(primary, secondary),
                _noteSection(primary, secondary),
                _detailsSection(primary),
                const SizedBox(height: 20),
                _addToCartButton(primary),
                const SizedBox(height: 30),
              ],
            ),
          );
        }),
      ),
    );
  }

  AppBar _appBar(Color primary, Color secondary) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text('تفاصيل المنتج',
          style: GoogleFonts.cairo(
              fontSize: 20, fontWeight: FontWeight.bold, color: primary)),
      actions: [
        CartIconButton(
          iconColor: primary,
          backgroundColor: secondary,
          onPressed: () {
            _shopCtrl.SumPrice();
            openShoppingCart();
          },
        ),
      ],
      leading: IconButton(
        onPressed: () => _controller.backToRestourantprofile(),
        icon: Icon(Icons.arrow_back_ios, color: primary),
      ),
    );
  }

  Widget _shimmerFull() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(children: [
        Container(
            height: 220,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16))),
        for (int i = 0; i < 5; i++)
          Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12))),
      ]),
    );
  }

  Widget _carousel() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Stack(children: [
        Obx(() => _controller.itemsCarousel.isEmpty
            ? CachedNetworkImage(
                imageUrl: _controller.item.value.productsImageFirst ?? '',
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(height: 220, color: Colors.grey[100]),
                errorWidget: (_, __, ___) =>
                    Container(height: 220, color: Colors.grey[100]))
            : CarouselSlider.builder(
                itemCount: _controller.itemsCarousel.length,
                itemBuilder: (ctx, i, ri) => FillImageProductsCarousel(
                    item: _controller.itemsCarousel[i]),
                options: CarouselOptions(
                    height: 220,
                    scrollPhysics: const BouncingScrollPhysics(),
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 1,
                    onPageChanged: (i, _) =>
                        _controller.onPageChanged(i)))),
        Obx(() => Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    _controller.itemsCarousel.asMap().entries.map((e) {
                  final active = _controller.currentIndex.value == e.key;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: active ? 18 : 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: active
                            ? myTheme.primaryColor
                            : Colors.grey[300]),
                  );
                }).toList()))),
      ]),
    );
  }

  Widget _productHeader(Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: _controller.item.value.Logo ?? '',
                width: 46,
                height: 46,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) =>
                    Icon(Icons.restaurant, color: primary, size: 30),
              ),
            ),
            const SizedBox(width: 8),
            Text(_controller.item.value.RestaurantName ?? '',
                style: GoogleFonts.cairo(
                    fontSize: 13, color: Colors.grey[600])),
          ]),
          Flexible(
            child: Text(_controller.item.value.ProductsName ?? '',
                textAlign: TextAlign.right,
                style: GoogleFonts.cairo(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primary)),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.15, end: 0);
  }

  Widget _priceAndQty(Color primary, Color secondary) {
    return Obx(() {
      final base = (_controller.item.value.ProductsPrice ?? 0).toDouble();
      final extra = _controller.selectedSize.value?.sizePrice ?? 0.0;
      final effectiveUnit = base + extra;
      final total = effectiveUnit * _controller.count.value;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: secondary, borderRadius: BorderRadius.circular(30)),
              child: Row(children: [
                IconButton(
                  icon: Icon(Icons.remove, color: primary),
                  onPressed: () {
                    if (_controller.count.value > 0) {
                      _controller.count.value--;
                      _controller.update();
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(_controller.count.value.toString(),
                      style: GoogleFonts.cairo(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: primary),
                  onPressed: () {
                    _controller.count.value++;
                    _controller.update();
                  },
                ),
              ]),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${effectiveUnit.toStringAsFixed(0)} د.ع',
                  style: GoogleFonts.cairo(
                      fontSize: 16, color: Colors.grey[700])),
              if (_controller.count.value > 0)
                Text('الإجمالي: ${total.toStringAsFixed(0)} د.ع',
                    style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary)),
            ]),
          ],
        ),
      );
    }).animate().fadeIn(delay: 100.ms, duration: 400.ms);
  }

  Widget _sizesSection(Color primary, Color secondary) {
    return Obx(() {
      if (_controller.isSizesLoading.value) return _shimmerRow();
      if (_controller.sizes.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('اختيار الحجم *',
                  style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primary)),
              const SizedBox(width: 6),
              Icon(Icons.straighten, color: primary, size: 20),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: _controller.sizes.asMap().entries.map((e) {
                final i = e.key;
                final ProductSizeModel sz = e.value;
                final bool sel = _controller.selectedSize.value
                        ?.productSizeId ==
                    sz.productSizeId;
                return GestureDetector(
                  onTap: () => _controller.selectedSize.value = sz,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: sel ? primary : secondary,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: sel ? primary : Colors.transparent,
                          width: 2),
                      boxShadow: sel
                          ? [
                              BoxShadow(
                                  color: primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3))
                            ]
                          : [],
                    ),
                    child: Column(children: [
                      Text(sz.sizeName,
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: sel ? Colors.white : primary,
                              fontSize: 14)),
                      Text('+ ${sz.sizePrice.toStringAsFixed(0)} د.ع',
                          style: GoogleFonts.cairo(
                              fontSize: 11,
                              color:
                                  sel ? Colors.white70 : Colors.grey[600])),
                    ]),
                  ),
                )
                    .animate(delay: Duration(milliseconds: i * 60))
                    .fadeIn(duration: 300.ms)
                    .slideX(begin: 0.2, end: 0);
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
        ],
      );
    });
  }

  Widget _ingredientsSection(Color primary, Color secondary) {
    return Obx(() {
      if (_controller.isIngredientsLoading.value) return _shimmerRow();
      if (_controller.ingredients.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Text('المكونات',
                  style: GoogleFonts.cairo(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: primary)),
              const SizedBox(width: 6),
              Icon(Icons.restaurant_menu, color: primary, size: 20),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 8,
              children: _controller.ingredients.asMap().entries.map((e) {
                final i = e.key;
                final ProductIngredientModel ing = e.value;
                final bool sel = _controller.selectedIngredients.any(
                    (s) => s.productIngredientId == ing.productIngredientId);
                return GestureDetector(
                  onTap: () => _controller.toggleIngredient(ing),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? primary.withOpacity(0.12)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: sel ? primary : Colors.grey[300]!,
                          width: 1.5),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(
                        sel
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: sel ? primary : Colors.grey[400],
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(ing.ingredientName,
                          style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: sel
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: sel ? primary : Colors.grey[700])),
                    ]),
                  ),
                )
                    .animate(delay: Duration(milliseconds: i * 50))
                    .fadeIn(duration: 280.ms)
                    .slideX(begin: 0.15, end: 0);
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),
        ],
      );
    });
  }

  Widget _noteSection(Color primary, Color secondary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('ملاحظة',
            style: GoogleFonts.cairo(
                fontSize: 17, fontWeight: FontWeight.bold, color: primary)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
              color: secondary, borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: _controller.noteController,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            decoration: InputDecoration(
              hintText: 'أضف ملاحظتك هنا...',
              hintStyle:
                  GoogleFonts.cairo(color: Colors.grey[500], fontSize: 14),
              contentPadding: const EdgeInsets.all(14),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ]),
    ).animate().fadeIn(delay: 200.ms, duration: 350.ms);
  }

  Widget _detailsSection(Color primary) {
    final d = _controller.item.value.ProductsDetails;
    if (d == null || d.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text('التفاصيل',
            style: GoogleFonts.cairo(
                fontSize: 17, fontWeight: FontWeight.bold, color: primary)),
        const SizedBox(height: 4),
        Text(d,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(fontSize: 15, color: Colors.grey[700])),
      ]),
    ).animate().fadeIn(delay: 250.ms, duration: 350.ms);
  }

  Widget _addToCartButton(Color primary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.08).animate(
            CurvedAnimation(parent: _cartBtnCtrl, curve: Curves.easeOut)),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton.icon(
            onPressed: () {
              final added =
                  _controller.AddToListCard(_controller.item.value);
              if (added) {
                _cartBtnCtrl.forward().then((_) {
                  _cartBtnCtrl.reverse();
                  _shopCtrl.SumPrice();
                  _shopCtrl.update();
                });
              }
            },
            icon: const Icon(Icons.shopping_cart_checkout,
                color: Colors.white, size: 22),
            label: Text('إضافة إلى السلة',
                style: GoogleFonts.cairo(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              elevation: 4,
              shadowColor: primary.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerRow() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
