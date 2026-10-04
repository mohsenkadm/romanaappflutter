import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/views/ProductView.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Constant/restaurant_id_resolver.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/views/login.dart';

class FillProduct extends StatefulWidget {
  const FillProduct({
    Key? key,
    required this.items,
    this.index = 0,
    this.isGrid = false,
  }) : super(key: key);
  final ProductsModel items;
  final int index;
  /// When true, layout fits inside a [SliverGrid] cell without overflow.
  final bool isGrid;

  @override
  State<FillProduct> createState() => _FillProductState();
}

class _FillProductState extends State<FillProduct> {
  // ── Cart helpers ──────────────────────────────────────────────────────────
  int get _cartCount {
    final idx = ListItemCard.itemscard
        .indexWhere((e) => e.productsId == widget.items.ProductsId);
    return idx == -1 ? 0 : ListItemCard.itemscard[idx].count;
  }

  void _openDetail() {
    Get.to(
      () => const ProductView(),
      arguments: [widget.items.ProductsId.toString()],
      duration: const Duration(milliseconds: 450),
      transition: Transition.fade,
    )?.then((_) {
      if (mounted) setState(() {});
    });
  }

  void _increment() {
    final available = widget.items.availableForOrder;
    if (!available) {
      ErrorMessage.SnackMessage('common.unavailable'.tr, Colors.orange[700]!);
      return;
    }

    // Login check
    final box = GetStorage();
    final userId = box.read('UserId') ?? 0;
    if (userId == 0) {
      AwesomeDialog(
              buttonsBorderRadius:
                  const BorderRadius.all(Radius.circular(5)),
              context: Get.context!,
              dialogType: DialogType.warning,
              headerAnimationLoop: true,
              animType: AnimType.bottomSlide,
              title: 'product.login_required_title'.tr,
              reverseBtnOrder: true,
              showCloseIcon: true,
              btnOkText: 'نعم',
              btnCancelText: 'الغاء',
              btnOkIcon: Icons.check_circle,
              btnCancelIcon: Icons.cancel,
              btnOkOnPress: () {
                Get.to(const Login(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
              },
              desc:
                  'product.login_required_desc'.tr)
          .show();
      return;
    }

    final idx = ListItemCard.itemscard
        .indexWhere((e) => e.productsId == widget.items.ProductsId);

    // Existing item -> just increment count
    if (idx != -1) {
      final resId = RestaurantIdResolver.fromProductId(widget.items.RestaurantId);
      if (resId > 0 && ListItemCard.itemscard[idx].restaurantId <= 0) {
        ListItemCard.itemscard[idx].restaurantId = resId;
      }
      if (mounted) setState(() => ListItemCard.itemscard[idx].count++);
      if (Get.isRegistered<AppBadgeController>()) {
        Get.find<AppBadgeController>().refreshCart();
      }
      return;
    }

    // New item -> cross-restaurant check
    final newResId = RestaurantIdResolver.fromProductId(widget.items.RestaurantId);
    if (newResId <= 0) {
      ErrorMessage.SnackMessage(
          'تعذر تحديد المطعم، افتح المطعم من جديد', Colors.red[400]!);
      return;
    }
    final hasOther = ListItemCard.itemscard
        .any((c) => c.restaurantId != newResId);
    if (hasOther) {
      AwesomeDialog(
              buttonsBorderRadius:
                  const BorderRadius.all(Radius.circular(5)),
              context: Get.context!,
              dialogType: DialogType.warning,
              headerAnimationLoop: true,
              animType: AnimType.bottomSlide,
              title: 'حذف السلة',
              reverseBtnOrder: true,
              showCloseIcon: true,
              btnOkText: 'نعم',
              btnCancelText: 'الغاء',
              btnOkIcon: Icons.check_circle,
              btnCancelIcon: Icons.cancel,
              btnOkOnPress: () {
                ListItemCard.itemscard.clear();
                if (Get.isRegistered<AppBadgeController>()) {
                  Get.find<AppBadgeController>().refreshCart();
                }
                if (mounted) setState(() {});
              },
              btnCancelOnPress: () {},
              desc:
                  'لا يمكن الطلب اكثر من مطعم  هل تريد حذف السلة  ؟')
          .show();
      return;
    }

    // Add directly to cart with default options
    final basePrice =
        double.tryParse(widget.items.ProductsPrice?.toString() ?? '0') ?? 0.0;
    setState(() {
      ListItemCard.itemscard.add(OrderDetailModel(
        orderDetailId: 0,
        orderId: 0,
        productsId: widget.items.ProductsId!,
        price: basePrice,
        count: 1,
        total: 0,
        productsName: widget.items.ProductsName ?? '',
        productsDetails: widget.items.ProductsDetails?.toString() ?? '',
        productsImage: widget.items.productsImageFirst ?? '',
        subCategoriesName: widget.items.SubCategoriesName ?? '',
        restaurantId: newResId,
      ));
    });
    ErrorMessage.SnackMessage('تمت الاضافة الى السلة', Colors.green[400]!);
    if (Get.isRegistered<AppBadgeController>()) {
      Get.find<AppBadgeController>().refreshCart();
    }
  }

  void _decrement() {
    final idx = ListItemCard.itemscard
        .indexWhere((e) => e.productsId == widget.items.ProductsId);
    if (idx == -1 || !mounted) return;
    setState(() {
      if (ListItemCard.itemscard[idx].count > 1) {
        ListItemCard.itemscard[idx].count--;
      } else {
        ListItemCard.itemscard.removeAt(idx);
      }
    });
    if (Get.isRegistered<AppBadgeController>()) {
      Get.find<AppBadgeController>().refreshCart();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final card = widget.isGrid ? _buildGridCard(context) : _buildListCard(context);

    if (widget.index >= 8) return card;

    return card
        .animate(delay: Duration(milliseconds: widget.index * 40))
        .fadeIn(duration: 250.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _buildGridCard(BuildContext context) {
    final bool available = widget.items.availableForOrder;
    final primary = Theme.of(context).primaryColor;
    final int count = _cartCount;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // الصورة تملأ الفراغ المتبقي بدل مساحة بيضاء في الوسط
              Expanded(
                child: GestureDetector(
                  onTap: available
                      ? _openDetail
                      : () => ErrorMessage.SnackMessage(
                          'common.unavailable'.tr, Colors.orange[700]!),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _productImage(),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.items.ProductsName ?? '',
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                  color: Colors.grey[850],
                ),
              ),
              const SizedBox(height: 6),
              _cartControl(
                available: available,
                primary: primary,
                count: count,
                compact: true,
              ),
            ],
          ),
          _priceBadge(primary),
          if ((widget.items.preparationTimeMinutes ?? 0) > 0)
            _prepTimeBadge(),
          if (!available) _unavailableOverlay(),
        ],
      ),
    );
  }

  Widget _buildListCard(BuildContext context) {
    final bool available = widget.items.availableForOrder;
    final primary = Theme.of(context).primaryColor;
    final int count = _cartCount;

    return Container(
      constraints: const BoxConstraints(minHeight: 110),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: available
                    ? _openDetail
                    : () => ErrorMessage.SnackMessage(
                        'common.unavailable'.tr, Colors.orange[700]!),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: SizedBox(
                    height: 130,
                    child: _productImage(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      widget.items.ProductsName ?? '',
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[850],
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (widget.items.SubCategoriesName != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.items.SubCategoriesName!,
                            style: GoogleFonts.cairo(
                                fontSize: 10, color: primary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 10),
                child: _cartControl(
                  available: available,
                  primary: primary,
                  count: count,
                  compact: false,
                ),
              ),
            ],
          ),
          _priceBadge(primary),
          if ((widget.items.preparationTimeMinutes ?? 0) > 0) _prepTimeBadge(),
          if (!available) _unavailableOverlay(),
        ],
      ),
    );
  }

  Widget _productImage() {
    return CachedNetworkImage(
      imageUrl: widget.items.productsImageFirst ?? '',
      fit: BoxFit.cover,
      memCacheWidth: 400,
      placeholder: (_, __) => Container(color: Colors.grey[100]),
      errorWidget: (_, __, ___) => Container(
        color: Colors.grey[100],
        child: Icon(Icons.fastfood, color: Colors.grey[300], size: 40),
      ),
    );
  }

  Widget _priceBadge(Color primary) {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.35),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          OrderStatusHelper.formatIqd(widget.items.ProductsPrice ?? 0),
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _prepTimeBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.timer_outlined, color: Colors.white, size: 12),
            const SizedBox(width: 4),
            Text(
              '${widget.items.preparationTimeMinutes} د',
              style: GoogleFonts.cairo(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _unavailableOverlay() {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.black.withOpacity(0.38),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'غير متوفر',
                style: GoogleFonts.cairo(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[700],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cartControl({
    required bool available,
    required Color primary,
    required int count,
    required bool compact,
  }) {
    final btnHeight = compact ? 30.0 : 34.0;
    final fontSize = compact ? 10.0 : 11.0;

    if (count == 0) {
      return GestureDetector(
        onTap: _increment,
        child: Container(
          height: btnHeight,
          decoration: BoxDecoration(
            color: available ? primary : Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_shopping_cart_rounded,
                  color: Colors.white, size: compact ? 14 : 15),
              const SizedBox(width: 4),
              Text(
                'أضف للسلة',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: btnHeight,
      decoration: BoxDecoration(
        color: primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _increment,
            child: Container(
              width: compact ? 32 : 36,
              height: btnHeight,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.add,
                  color: Colors.white, size: compact ? 16 : 18),
            ),
          ),
          Expanded(
            child: Text(
              count.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: compact ? 13 : 15,
                color: primary,
              ),
            ),
          ),
          GestureDetector(
            onTap: _decrement,
            child: Container(
              width: compact ? 32 : 36,
              height: btnHeight,
              decoration: BoxDecoration(
                border: Border.all(color: primary, width: 1.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.remove, color: primary, size: compact ? 16 : 18),
            ),
          ),
        ],
      ),
    );
  }
}
