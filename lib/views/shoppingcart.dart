import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Controller/ShoppingCardController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/views/CoverageGate.dart';
import 'package:romanaappflutter/views/SendOrder.dart';
import 'package:romanaappflutter/views/login.dart';

// ignore: camel_case_types
class shoppingcard extends StatefulWidget {
  const shoppingcard({Key? key}) : super(key: key);
  @override
  State<shoppingcard> createState() => _shoppingcard();
}

// ignore: camel_case_types
class _shoppingcard extends State<shoppingcard> {
  late final ShoppingCardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.isRegistered<ShoppingCardController>()
        ? Get.find<ShoppingCardController>()
        : Get.put(ShoppingCardController());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: MyAppBar(),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () => _controller.fetchData(),
          child: GetBuilder<ShoppingCardController>(
            builder: (controller) => ListItemCard.itemscard.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined,
                            size: 80, color: Colors.grey[350]),
                        const SizedBox(height: 12),
                        Text('السلة فارغة',
                            style: GoogleFonts.cairo(
                                fontSize: 18, color: Colors.grey[600])),
                      ],
                    ),
                  )
                : ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: ListItemCard.itemscard.length,
                        itemBuilder: (context, index) {
                          final item = ListItemCard.itemscard[index];
                          final lineTotal = item.unitPrice * item.count;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                  color: myTheme.primaryColor
                                      .withValues(alpha: 0.12)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 72,
                                    height: 72,
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2)),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.fastfood,
                                              color: Colors.grey[400]),
                                      imageUrl: item.productsImage.isNotEmpty
                                          ? item.productsImage
                                          : 'https://via.placeholder.com/80',
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.productsName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.cairo(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${OrderStatusHelper.formatIqd(item.unitPrice)} × ${item.count}',
                                        style: GoogleFonts.cairo(
                                            color: Colors.grey[600],
                                            fontSize: 12),
                                      ),
                                      Text(
                                        OrderStatusHelper.formatIqd(lineTotal),
                                        style: GoogleFonts.cairo(
                                            color: Theme.of(context)
                                                .primaryColor,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      if (item.selectedSizeName != null &&
                                          item.selectedSizeName!.isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Text(
                                            'الحجم: ${item.selectedSizeName}',
                                            style: GoogleFonts.cairo(
                                                fontSize: 12,
                                                color: Colors.grey[700]),
                                          ),
                                        ),
                                      if (item.selectedIngredients != null &&
                                          item.selectedIngredients!.isNotEmpty)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 3),
                                          child: Text(
                                            'المكونات: ${item.selectedIngredients}',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.cairo(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                                fontStyle: FontStyle.italic),
                                          ),
                                        ),
                                      const SizedBox(height: 8),
                                      _QtyStepper(
                                        count: item.count,
                                        onMinus: () =>
                                            controller.DeIncrement(index),
                                        onPlus: () =>
                                            controller.Increment(index),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    AwesomeDialog(
                                            buttonsBorderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5)),
                                            context: context,
                                            dialogType: DialogType.warning,
                                            headerAnimationLoop: true,
                                            animType: AnimType.bottomSlide,
                                            title: 'حذف المنتج',
                                            reverseBtnOrder: true,
                                            showCloseIcon: true,
                                            btnOkText: 'نعم',
                                            btnCancelText: 'الغاء',
                                            btnOkIcon: Icons.check_circle,
                                            btnCancelIcon: Icons.cancel,
                                            btnOkOnPress: () {
                                              ListItemCard.itemscard
                                                  .removeAt(index);
                                              controller.SumPrice();
                                              controller.update();
                                            },
                                            btnCancelOnPress: () {},
                                            desc: 'هل تريد حذف المنتج حقا؟')
                                        .show();
                                  },
                                  tooltip: 'حذف المنتج',
                                  icon: Icon(Icons.clear,
                                      size: 22, color: myTheme.primaryColor),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ListTile(
                              trailing: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: myTheme.secondaryHeaderColor),
                                  child: Icon(Icons.currency_exchange,
                                      size: 30, color: myTheme.primaryColor)),
                              title: Text(
                                'المبلغ الكلي',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: Obx(
                                () => Text(
                                  OrderStatusHelper.formatIqd(
                                      controller.totalprice.value),
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: myTheme.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () async {
                                  final box = GetStorage();
                                  final userId = box.read('UserId') ?? 0;
                                  if (userId == 0) {
                                    ErrorLogin();
                                    return;
                                  }
                                  if (!LocationStorage.coverageVerified) {
                                    final ok = await Get.to(
                                        () => const CoverageGate());
                                    if (ok != true &&
                                        !LocationStorage.coverageVerified) {
                                      return;
                                    }
                                  }
                                  Get.to(() => const SendOrder(),
                                      duration:
                                          const Duration(milliseconds: 400),
                                      transition:
                                          Transition.rightToLeftWithFade);
                                },
                                child: Text(
                                  'إرسال الطلب',
                                  style: GoogleFonts.cairo(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
          ),
        ),
        backgroundColor: const Color(0xFFF7F8FC),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  PreferredSizeWidget MyAppBar() {
    return AppBar(
        actions: [
          GetBuilder<ShoppingCardController>(
            builder: (controller) => IconButton(
                onPressed: () {
                  if (ListItemCard.itemscard.isEmpty) return;
                  AwesomeDialog(
                          buttonsBorderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          context: context,
                          dialogType: DialogType.warning,
                          headerAnimationLoop: true,
                          animType: AnimType.bottomSlide,
                          title: 'تفريغ السلة',
                          reverseBtnOrder: true,
                          showCloseIcon: true,
                          btnOkText: 'نعم',
                          btnCancelText: 'الغاء',
                          btnOkIcon: Icons.check_circle,
                          btnCancelIcon: Icons.cancel,
                          btnOkOnPress: () => controller.ClearCard(),
                          btnCancelOnPress: () {},
                          desc: 'هل تريد تفريغ السلة؟')
                      .show();
                },
                tooltip: "حذف السلة",
                icon: Icon(Icons.remove_shopping_cart,
                    size: 28, color: Theme.of(context).primaryColor)),
          ),
        ],
        leading: IconButton(
            onPressed: () => navigator?.pop(),
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "سلة الطلب",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }

  // ignore: non_constant_identifier_names
  void ErrorLogin() {
    AwesomeDialog(
            buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
            context: context,
            dialogType: DialogType.warning,
            headerAnimationLoop: true,
            animType: AnimType.bottomSlide,
            title: 'تسجيل الدخول',
            reverseBtnOrder: true,
            showCloseIcon: true,
            btnOkText: 'نعم',
            btnCancelText: 'الغاء',
            btnOkIcon: Icons.check_circle,
            btnCancelIcon: Icons.cancel,
            btnOkOnPress: () {
              Get.to(() => const Login(),
                  duration: const Duration(milliseconds: 500),
                  transition: Transition.fade);
            },
            desc:
                'يجب تسجيل حساب جديد او تسجيل دخول للتطبيق لتتمكن من اضافة طلبك')
        .show();
  }
}

class _QtyStepper extends StatelessWidget {
  const _QtyStepper({
    required this.count,
    required this.onMinus,
    required this.onPlus,
  });

  final int count;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _qtyBtn(icon: Icons.remove_rounded, onTap: onMinus, color: primary),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) => ScaleTransition(
              scale: anim,
              child: FadeTransition(opacity: anim, child: child),
            ),
            child: Padding(
              key: ValueKey(count),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '$count',
                style: GoogleFonts.cairo(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ),
          ),
          _qtyBtn(
              icon: Icons.add_rounded,
              onTap: onPlus,
              color: primary,
              filled: true),
        ],
      ),
    );
  }

  Widget _qtyBtn({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    bool filled = false,
  }) {
    return Material(
      color: filled ? color : Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: filled ? Colors.white : color),
        ),
      ),
    );
  }
}
