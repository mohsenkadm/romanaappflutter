import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/core/locale/locale_service.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Constant/order_status_resolver.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/OrderDetailsController.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Controller/SupportPhoneController.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:romanaappflutter/views/orderdeitals.dart';

class LastOrderView extends StatefulWidget {
  const LastOrderView({Key? key}) : super(key: key);

  @override
  State<LastOrderView> createState() => _LastOrderViewState();
}

class _LastOrderViewState extends State<LastOrderView> {
  final MyOrderController _orderController = MyOrderController.instance;
  final ProfileuserController _profileController =
      Get.find<ProfileuserController>();

  List<OrdersModel> _orders = [];
  int? _expandedOrderId;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    if (_profileController.user.value == null) {
      setState(() {
        _orders = [];
        _initialLoadDone = true;
      });
      return;
    }
    await _orderController.fetchData();
    final all = <OrdersModel>[
      ..._orderController.itemscurrent.cast<OrdersModel>(),
      ..._orderController.itemsdone.cast<OrdersModel>(),
      ..._orderController.itemscancel.cast<OrdersModel>(),
    ];
    all.sort((a, b) => b.orderDate.compareTo(a.orderDate));
    if (!mounted) return;
    setState(() {
      _orders = all;
      _initialLoadDone = true;
    });
  }

  void _toggleExpand(int? orderId) {
    setState(() {
      _expandedOrderId = _expandedOrderId == orderId ? null : orderId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios, color: primary),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'orders.last_title'.tr,
          style: GoogleFonts.cairo(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primary,
          ),
        ),
      ),
      body: Obx(() {
        if (_profileController.user.value == null) {
          return _empty('orders.login_to_view'.tr);
        }
        if (_orderController.isloded.value && !_initialLoadDone) {
          return const Center(child: CircularProgressIndicator());
        }
        if (_initialLoadDone && _orders.isEmpty) {
          return _empty('orders.empty'.tr);
        }
        return RefreshIndicator(
          color: primary,
          onRefresh: _loadOrders,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              final order = _orders[index];
              final id = order.orderId;
              final expanded = id != null && _expandedOrderId == id;
              return _ExpandableOrderCard(
                order: order,
                expanded: expanded,
                index: index,
                onToggle: () => _toggleExpand(id),
                onCancelled: _loadOrders,
              );
            },
          ),
        );
      }),
    );
  }

  Widget _empty(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_rounded, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(text, style: GoogleFonts.cairo(fontSize: 16)),
        ],
      ),
    );
  }
}

class _ExpandableOrderCard extends StatefulWidget {
  const _ExpandableOrderCard({
    required this.order,
    required this.expanded,
    required this.index,
    required this.onToggle,
    required this.onCancelled,
  });

  final OrdersModel order;
  final bool expanded;
  final int index;
  final VoidCallback onToggle;
  final Future<void> Function() onCancelled;

  @override
  State<_ExpandableOrderCard> createState() => _ExpandableOrderCardState();
}

class _ExpandableOrderCardState extends State<_ExpandableOrderCard> {
  OrderDetailsController? _details;
  bool _loadingDetails = false;

  @override
  void didUpdateWidget(covariant _ExpandableOrderCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.expanded && !oldWidget.expanded) {
      _ensureDetails();
    }
  }

  @override
  void dispose() {
    final id = widget.order.orderId;
    if (id != null) {
      final tag = 'last_order_$id';
      if (Get.isRegistered<OrderDetailsController>(tag: tag)) {
        Get.delete<OrderDetailsController>(tag: tag);
      }
    }
    super.dispose();
  }

  Future<void> _ensureDetails() async {
    final id = widget.order.orderId;
    if (id == null) return;
    final tag = 'last_order_$id';
    setState(() => _loadingDetails = true);
    _details = Get.isRegistered<OrderDetailsController>(tag: tag)
        ? Get.find<OrderDetailsController>(tag: tag)
        : Get.put(OrderDetailsController(), tag: tag);
    _details!.OrderId = id.toString();
    await _details!.fetchData();
    if (mounted) setState(() => _loadingDetails = false);
  }

  _StatusVisual get _status {
    final code = OrderStatusResolver.effectiveCode(
      widget.order,
      widget.order.statusCode,
    );
    final label = OrderStatusHelper.labelFor(code);
    if (code == 9 || widget.order.isCancel == true) {
      return _StatusVisual(label, Colors.red, Icons.cancel_rounded);
    }
    if (code >= 7 || widget.order.isDone == true) {
      return _StatusVisual(label, Colors.green, Icons.check_circle_rounded);
    }
    if (code >= 4) {
      return _StatusVisual(label, Colors.indigo, Icons.delivery_dining_rounded);
    }
    if (code >= 1 || widget.order.isApporve == true) {
      return _StatusVisual(label, Colors.blue[700]!, Icons.thumb_up_rounded);
    }
    return _StatusVisual(label, Colors.orange[700]!, Icons.hourglass_top_rounded);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    final st = _status;
    final o = widget.order;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onToggle,
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      AnimatedRotation(
                        turns: widget.expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(Icons.keyboard_arrow_down_rounded,
                            color: primary, size: 28),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: st.color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(st.icon, color: st.color, size: 13),
                            const SizedBox(width: 4),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 110),
                              child: Text(
                                st.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.cairo(
                                  color: st.color,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              o.restaurantName ?? '',
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.cairo(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[850],
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'orders.order_no'.trParams({'no': '${o.orderNo ?? o.orderId ?? ''}'}),
                              textAlign: TextAlign.right,
                              style: GoogleFonts.cairo(
                                  fontSize: 12, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      ClipOval(
                        child: (o.logo ?? '').isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: o.logo!,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorWidget: (_, __, ___) =>
                                    _logoFallback(primary),
                              )
                            : _logoFallback(primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,
                              size: 13, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            GetTimeAgo.parse(o.orderDate, locale: LocaleService.to.code.value),
                            style: GoogleFonts.cairo(
                                fontSize: 11, color: Colors.grey[400]),
                          ),
                        ],
                      ),
                      Text(
                        '${o.netAmount?.toStringAsFixed(0) ?? '0'} د.ع',
                        style: GoogleFonts.cairo(
                          color: primary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: _buildExpanded(primary),
            crossFadeState: widget.expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 280),
          ),
        ],
      ),
    );
  }

  Widget _buildExpanded(Color primary) {
    if (_loadingDetails ||
        (_details != null && _details!.isloded.value)) {
      return const Padding(
        padding: EdgeInsets.all(20),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    final details = _details?.itemscurrent ?? [];
    final ord = _details?.order.value ?? widget.order;
    final canCancel = OrderDetailsController.canCustomerCancel(ord);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(height: 1, color: Colors.grey[200]),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'orders.details'.tr,
              style: GoogleFonts.cairo(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: primary,
              ),
            ),
          ),
          const SizedBox(height: 8),
          if (details.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'orders.no_product_details'.tr,
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(color: Colors.grey[500], fontSize: 13),
              ),
            )
          else
            ...details.map((item) {
              final line =
                  ((item.price ?? 0) * item.count).toStringAsFixed(0);
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      '$line د.ع',
                      style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: primary),
                    ),
                    const Spacer(),
                    Text(
                      '×${item.count}  ${item.productsName}',
                      textAlign: TextAlign.right,
                      style: GoogleFonts.cairo(fontSize: 13),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          _totalRow('orders.subtotal'.tr, '${ord.total?.toStringAsFixed(0) ?? 0} د.ع'),
          _totalRow(
              'orders.delivery'.tr, '${ord.costDelivery?.toStringAsFixed(0) ?? 0} د.ع'),
          _totalRow(
              'orders.discount'.tr, '${ord.totalDiscount?.toStringAsFixed(0) ?? 0} د.ع'),
          _totalRow(
            'orders.net'.tr,
            '${ord.netAmount?.toStringAsFixed(0) ?? 0} د.ع',
            bold: true,
          ),
          if ((ord.notes ?? '').isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              'ملاحظة: ${ord.notes}',
              textAlign: TextAlign.right,
              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (canCancel)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _confirmCancel(ord),
                    icon: const Icon(Icons.cancel_outlined,
                        color: Colors.red, size: 18),
                    label: Text(
                      'orders.cancel'.tr,
                      style: GoogleFonts.cairo(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              if (canCancel) const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final id = ord.orderId?.toString() ?? '0';
                    Get.to(
                      () => const orderdeitals(),
                      arguments: [id],
                      duration: const Duration(milliseconds: 400),
                      transition: Transition.fade,
                    );
                  },
                  icon: const Icon(Icons.open_in_new_rounded,
                      color: Colors.white, size: 16),
                  label: Text(
                    'orders.full_details'.tr,
                    style: GoogleFonts.cairo(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              final orderNo =
                  ord.orderNo?.toString() ?? ord.orderId?.toString() ?? '';
              SupportPhoneController.instance.openWhatsApp(
                message:
                    'رقم الطلب: $orderNo\nرجاءً المساعدة بخصوص هذا الطلب',
              );
            },
            icon: const Icon(Icons.support_agent_rounded, size: 18),
            label: Text('orders.whatsapp_help'.tr,
                style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmCancel(OrdersModel ord) async {
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
            child: Text('orders.cancel_confirm_ok'.tr,
                style: GoogleFonts.cairo(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
    if (ok != true) return;
    final ctrl = _details ??
        (() {
          final id = ord.orderId ?? 0;
          final tag = 'last_order_$id';
          return Get.isRegistered<OrderDetailsController>(tag: tag)
              ? Get.find<OrderDetailsController>(tag: tag)
              : Get.put(OrderDetailsController(), tag: tag);
        })();
    ctrl.OrderId = (ord.orderId ?? 0).toString();
    final success = await ctrl.cancelOrderByCustomer();
    if (success) {
      await widget.onCancelled();
    }
  }

  Widget _totalRow(String label, String value, {bool bold = false}) {
    final style = GoogleFonts.cairo(
      fontSize: bold ? 14 : 12,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: Colors.grey[800],
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: style),
          Text(label, style: style),
        ],
      ),
    );
  }

  Widget _logoFallback(Color primary) {
    return Container(
      width: 48,
      height: 48,
      color: primary.withOpacity(0.1),
      child: Icon(Icons.storefront_rounded, color: primary),
    );
  }
}

class _StatusVisual {
  const _StatusVisual(this.label, this.color, this.icon);
  final String label;
  final Color color;
  final IconData icon;
}
