import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Controller/SupportPhoneController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/DriverTrackingScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:shimmer/shimmer.dart';

import '../Controller/OrderDetailsController.dart';

// ignore: camel_case_types
class orderdeitals extends StatefulWidget {
  const orderdeitals({Key? key}) : super(key: key);
  @override
  State<orderdeitals> createState() => _Orderdeitals();
}

class _Orderdeitals extends State<orderdeitals>
    with SingleTickerProviderStateMixin {
  final OrderDetailsController _ctrl = Get.put(OrderDetailsController());
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
        lowerBound: 0.85,
        upperBound: 1.15)
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(primary),
      body: RefreshIndicator(
        color: primary,
        onRefresh: () => _ctrl.fetchData(),
        child: Obx(() {
          if (_ctrl.isloded.value) return _shimmerLoad();
          if (_ctrl.itemscurrent.isEmpty) return _emptyState(primary);
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _statusStepper(primary),
                _rejectReasonBanner(primary),
                const Divider(height: 1),
                ..._ctrl.itemscurrent.asMap().entries.map((e) =>
                    _orderItemCard(e.value, e.key, primary)),
                _invoiceSummary(primary),
                _supportWhatsAppButton(primary),
                Obx(() {
                  if (!_ctrl.canCancelAsCustomer) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _ctrl.isCancelling.value
                            ? null
                            : () => _confirmCancelOrder(),
                        icon: _ctrl.isCancelling.value
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.cancel_outlined,
                                color: Colors.red),
                        label: Text(
                          'orders.cancel'.tr,
                          style: GoogleFonts.cairo(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red, width: 1.4),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _rejectReasonBanner(Color primary) {
    return Obx(() {
      final ord = _ctrl.order.value;
      final reason = (ord?.Reason ?? '').trim();
      final cancelled =
          ord?.isCancel == true || (ord?.statusCode ?? -1) == 9;
      if (reason.isEmpty && !cancelled) return const SizedBox.shrink();
      if (reason.isEmpty) return const SizedBox.shrink();
      return Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.info_outline, color: Colors.red[700], size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'سبب الرفض',
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.red[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    reason,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.cairo(
                      fontSize: 13,
                      color: Colors.red[900],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _supportWhatsAppButton(Color primary) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            final ord = _ctrl.order.value;
            final no = ord?.orderNo ?? ord?.orderId ?? '';
            SupportPhoneController.instance.openWhatsApp(
              message: 'مرحبا! اود استفسار عن طلب رقم $no',
            );
          },
          icon: const Icon(Icons.support_agent, color: Colors.white),
          label: Text(
            'مراسلة الدعم',
            style: GoogleFonts.cairo(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF25D366),
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _appBar(Color primary) {
    return AppBar(
      leading: IconButton(
          onPressed: () => navigator?.pop(),
          icon: Icon(Icons.arrow_back_ios, color: primary)),
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text('orders.details'.tr,
          style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: primary)),
    );
  }

  Widget _shimmerLoad() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(children: List.generate(
          5,
          (i) => Container(
              height: 80,
              margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12))))),
    );
  }

  Widget _emptyState(Color primary) {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.production_quantity_limits, size: 80, color: primary),
      const SizedBox(height: 16),
      Text('لا توجد تفاصيل',
          style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey[600])),
    ]));
  }

  // ─── Animated Status Stepper ─────────────────────────────────────────────────
  /// نفس ترتيب مسار الطلب الموحّد (statusCode 0→7+) باختصار بصري لـ 5 خطوات.
  static const List<String> _stepLabels = [
    'في الانتظار',
    'تمت الموافقة',
    'جار تجهيز الطلب',
    'السائق في الطريق',
    'تم التسليم',
  ];

  static const List<IconData> _stepIcons = [
    Icons.access_time,
    Icons.check_circle_outline,
    Icons.soup_kitchen_outlined,
    Icons.two_wheeler_rounded,
    Icons.handshake_outlined,
  ];

  Widget _statusStepper(Color primary) {
    return Obx(() {
      final OrdersModel? ord = _ctrl.order.value;
      final int step = _ctrl.getStatusStep(ord);
      final bool cancelled = step == -1;

      return Container(
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 16),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cancelled
              ? Colors.red.shade50
              : myTheme.secondaryHeaderColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3))
          ],
        ),
        child: cancelled
            ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.cancel_outlined,
                    color: Colors.red, size: 26),
                const SizedBox(width: 8),
                Text('orders.cancelled_ok'.tr,
                    style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red)),
              ])
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        ord?.restaurantName != null
                            ? 'طلب من ${ord!.restaurantName}'
                            : 'orders.status_title'.tr,
                        style: GoogleFonts.cairo(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.receipt_long,
                          color: primary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_ctrl.statusCode.value >= 0 && ord != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        OrderStatusHelper.labelAr(_ctrl.statusCode.value),
                        style: GoogleFonts.cairo(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: primary),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  _buildStepperRow(step, primary),
                  const SizedBox(height: 10),
                  if (_ctrl.driver.value != null) ...[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text(
                              'السائق: ${_ctrl.driver.value!.name ?? ''}',
                              style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: primary,
                                  fontWeight: FontWeight.bold)),
                          if (_ctrl.driver.value!.phone != null) ...[
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () async {
                                final p = _ctrl.driver.value!.phone!;
                                await launchUrl(Uri(scheme: 'tel', path: p));
                              },
                              child: Icon(Icons.phone, color: primary, size: 16),
                            ),
                          ],
                          const SizedBox(width: 4),
                          Icon(Icons.delivery_dining, color: primary, size: 14),
                        ]),
                      ),
                    ),
                  ] else if (ord?.SaleManName != null &&
                      ord!.SaleManName!.isNotEmpty)
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Text('السائق: ${ord.SaleManName}',
                              style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: primary,
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          Icon(Icons.person, color: primary, size: 14),
                        ]),
                      ),
                    ),
                  if (_ctrl.isTrackable && ord?.orderId != null) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Get.to(
                          () => DriverTrackingScreen(
                            orderId: ord!.orderId!,
                          ),
                          duration: const Duration(milliseconds: 400),
                          transition: Transition.rightToLeftWithFade,
                        ),
                        icon: const Icon(Icons.map, color: Colors.white),
                        label: Text(
                          _ctrl.statusCode.value >= 5
                              ? 'orders.track_driver'.tr
                              : 'orders.follow_driver'.tr,
                          style: GoogleFonts.cairo(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
      );
    });
  }

  Widget _buildStepperRow(int activeStep, Color primary) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_stepLabels.length * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final lineIndex = i ~/ 2;
          final isCompleted = lineIndex < activeStep;
          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 3,
              decoration: BoxDecoration(
                  color: isCompleted ? primary : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2)),
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isDone = stepIndex < activeStep;
        final isActive = stepIndex == activeStep;
        return _stepDot(stepIndex, isDone, isActive, primary);
      }),
    );
  }

  Widget _stepDot(int idx, bool done, bool active, Color primary) {
    Widget dot = AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      width: active ? 36 : 28,
      height: active ? 36 : 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: done || active ? primary : Colors.grey[200],
        boxShadow: active
            ? [
                BoxShadow(
                    color: primary.withOpacity(0.35),
                    blurRadius: 10,
                    spreadRadius: 2)
              ]
            : [],
      ),
      child: Icon(
        done ? Icons.check : _stepIcons[idx],
        color: done || active ? Colors.white : Colors.grey[400],
        size: active ? 18 : 14,
      ),
    );

    if (active) {
      dot = ScaleTransition(scale: _pulseCtrl, child: dot);
    }

    return Column(mainAxisSize: MainAxisSize.min, children: [
      dot,
      const SizedBox(height: 4),
      SizedBox(
        width: 44,
        child: Text(
          _stepLabels[idx],
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(
              fontSize: 8,
              color: done || active ? primary : Colors.grey[500],
              fontWeight:
                  active ? FontWeight.bold : FontWeight.normal),
        ),
      ),
    ]);
  }

  // ─── Order Item Card ─────────────────────────────────────────────────────────
  Widget _orderItemCard(OrderDetailModel item, int index, Color primary) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14)),
            child: CachedNetworkImage(
              imageUrl: item.productsImage,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[100]),
              errorWidget: (_, __, ___) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey[100],
                  child: const Icon(Icons.fastfood, color: Colors.grey)),
            ),
          ),
          // Details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item.productsName,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: primary)),
                  const SizedBox(height: 4),
                  // Size
                  if (item.selectedSizeName != null &&
                      item.selectedSizeName!.isNotEmpty)
                    _infoChip(
                        'الحجم: ${item.selectedSizeName}'
                        '${item.selectedSizePrice != null ? " (+${item.selectedSizePrice!.toStringAsFixed(0)} د.ع)" : ""}',
                        Icons.straighten,
                        primary),
                  // Ingredients
                  if (item.selectedIngredients != null &&
                      item.selectedIngredients!.isNotEmpty)
                    _ingredientTags(item.selectedIngredients!, primary),
                  const SizedBox(height: 4),
                  // Qty & unit price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '${item.price?.toStringAsFixed(0) ?? 0} د.ع × ${item.count}',
                        style: GoogleFonts.cairo(
                            fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          '${((item.price ?? 0) * item.count).toStringAsFixed(0)} د.ع',
                          style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: primary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: index * 60))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.12, end: 0);
  }

  Widget _infoChip(String label, IconData icon, Color primary) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: GoogleFonts.cairo(
                  fontSize: 11, color: Colors.grey[700])),
          const SizedBox(width: 4),
          Icon(icon, size: 12, color: Colors.grey[500]),
        ],
      ),
    );
  }

  Widget _ingredientTags(String ingredientsStr, Color primary) {
    final tags = ingredientsStr.split(',').map((s) => s.trim()).toList();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Wrap(
        alignment: WrapAlignment.end,
        spacing: 4,
        runSpacing: 3,
        children: tags.map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                  color: primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: primary.withOpacity(0.3), width: 1)),
              child: Text(t,
                  style: GoogleFonts.cairo(
                      fontSize: 10, color: primary)),
            )).toList(),
      ),
    );
  }

  // ─── Invoice Summary ─────────────────────────────────────────────────────────
  Widget _invoiceSummary(Color primary) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Obx(() {
            return Column(
            children: [
              _invoiceRow('orders.invoice_subtotal'.tr, _ctrl.totalprice.value,
                  Icons.receipt, primary, index: 0),
              _divider(),
              _invoiceRow('orders.invoice_delivery'.tr, _ctrl.costDelivery.value,
                  Icons.delivery_dining, primary, index: 1),
              _divider(),
              _invoiceRow('orders.invoice_discount'.tr, _ctrl.discountprice.value,
                  Icons.discount_outlined, Colors.green, index: 2),
              _divider(),
              _invoiceRow('orders.invoice_net'.tr, _ctrl.netAmount.value,
                  Icons.currency_exchange, primary,
                  index: 3, bold: true),
            ],
          );
          }),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _invoiceRow(
      String label, double amount, IconData icon, Color color,
      {required int index, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              bold
                  ? OrderStatusHelper.formatIqd(amount)
                  : OrderStatusHelper.formatIqd(amount),
              style: GoogleFonts.cairo(
                  fontSize: bold ? 17 : 15,
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500,
                  color: color)),
          Row(children: [
            Text(label,
                style: GoogleFonts.cairo(
                    fontSize: bold ? 16 : 14,
                    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                    color: Colors.grey[800])),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, size: 16, color: color),
            ),
          ]),
        ],
      ),
    )
        .animate(delay: Duration(milliseconds: 200 + index * 80))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.1, end: 0);
  }

  Widget _divider() => Divider(
      height: 1, thickness: 0.5, color: Colors.grey[200], indent: 8);

  Future<void> _confirmCancelOrder() async {
    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: Text(
          'orders.cancel_confirm_title'.tr,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'orders.cancel_confirm_body'.tr,
          textAlign: TextAlign.right,
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('common.back'.tr, style: GoogleFonts.cairo()),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              'orders.cancel_confirm_ok'.tr,
              style: GoogleFonts.cairo(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final success = await _ctrl.cancelOrderByCustomer();
    if (success) {
      ErrorMessage.SnackMessage('orders.cancelled_ok'.tr, Colors.orange[400]!);
      await _ctrl.fetchData();
    }
  }
}
