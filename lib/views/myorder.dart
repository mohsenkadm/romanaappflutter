import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/core/locale/locale_service.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Constant/order_status_resolver.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/MyTabController.dart';
import 'package:romanaappflutter/Controller/OrderDetailsController.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Controller/SendOrderController.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/AllRestaourent.dart';
import 'package:romanaappflutter/views/SendOrder.dart';
import 'package:romanaappflutter/views/orderdeitals.dart';
import 'package:shimmer/shimmer.dart';

// ignore: camel_case_types
class my_order extends StatefulWidget {
  const my_order({Key? key}) : super(key: key);
  @override
  State<my_order> createState() => _myorder();
}

// ignore: camel_case_types
class _myorder extends State<my_order> {
  final MyTabController _tabx = Get.put(MyTabController());
  final MyOrderController _controller = MyOrderController.instance;
  final ProfileuserController _profileuserController =
      Get.find<ProfileuserController>();

  final TextEditingController _searchDone = TextEditingController();
  final TextEditingController _searchCancel = TextEditingController();

  @override
  void dispose() {
    _searchDone.dispose();
    _searchCancel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: _buildAppBar(),
      body: Obx(() => _profileuserController.user.value == null
          ? _buildNotLoggedIn(context)
          : _buildTabView(context)),
    );
  }

  // ─── Not logged in ────────────────────────────────────────────────────────
  Widget _buildNotLoggedIn(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: primary.withOpacity(0.08),
            ),
            child: Icon(Icons.receipt_long_rounded, size: 64, color: primary.withOpacity(0.5)),
          ),
          const SizedBox(height: 20),
          Text('سجّل دخولك لرؤية طلباتك',
              style: GoogleFonts.cairo(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.grey[700])),
          const SizedBox(height: 6),
          Text('لم تسجّل دخولاً بعد',
              style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[500])),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.to(() => const AllRestaourent(),
                arguments: "", transition: Transition.fade,
                duration: const Duration(milliseconds: 450)),
            icon: const Icon(Icons.shopping_bag_rounded, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            ),
            label: Text('اطلب الآن',
                style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  // ─── Tab view ─────────────────────────────────────────────────────────────
  Widget _buildTabView(BuildContext context) {
    return TabBarView(controller: _tabx.controller, children: [
      _buildOrderList(context, _controller.itemsdone, _searchDone, showReorder: true),
      _buildOrderList(context, _controller.itemscancel, _searchCancel, showReorder: true),
      _buildCurrentOrders(context),
    ]);
  }

  Widget _buildOrderList(BuildContext context, dynamic items, TextEditingController searchCtrl, {bool showReorder = false}) {
    return Column(
      children: [
        _buildSearchBar(searchCtrl),
        Expanded(
          child: Obx(() => _controller.isloded.value
              ? const _OrderShimmer()
              : items.isEmpty
                  ? _buildEmpty()
                  : RefreshIndicator(
                      onRefresh: () => _controller.fetchData(),
                      color: myTheme.primaryColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: items.length,
                        itemBuilder: (_, i) {
                          final order = items[i] as OrdersModel;
                          final ts = _formatTimeAgo(order.orderDate);
                          return _OrderCard(items: order, timestamp: ts, showReorder: showReorder, index: i);
                        },
                      ),
                    )),
        ),
      ],
    );
  }

  Widget _buildCurrentOrders(BuildContext context) {
    // لا تستخدم Expanded هنا — TabBarView يعطي قيوداً مباشرة وليست داخل Flex.
    return RefreshIndicator(
      onRefresh: () => _controller.fetchData(),
      color: myTheme.primaryColor,
      child: Obx(() {
        if (_controller.isloded.value) return const _OrderShimmer();
        final list = _controller.itemscurrent;
        if (list.isEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              _buildEmpty(),
            ],
          );
        }
        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          itemCount: list.length,
          itemBuilder: (_, i) {
            final order = list[i] as OrdersModel;
            final ts = _formatTimeAgo(order.orderDate);
            return _OrderCard(items: order, timestamp: ts, index: i);
          },
        );
      }),
    );
  }

  static String _formatTimeAgo(DateTime? date) {
    try {
      final d = date ?? DateTime.now();
      return GetTimeAgo.parse(d, locale: LocaleService.to.code.value);
    } catch (_) {
      return '';
    }
  }

  Widget _buildSearchBar(TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: TextField(
          controller: ctrl,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          onChanged: (q) => _controller.fetchData(searchprod: q),
          decoration: InputDecoration(
            hintText: 'ابحث برقم الطلب',
            hintStyle: GoogleFonts.cairo(color: Colors.grey[400], fontSize: 13),
            hintTextDirection: TextDirection.rtl,
            prefixIcon: Icon(Icons.search_rounded, color: myTheme.primaryColor, size: 20),
            suffixIcon: IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.grey[400], size: 18),
              onPressed: () { ctrl.clear(); _controller.fetchData(); },
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox_rounded, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text('لا توجد طلبات',
              style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey[500])),
        ],
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 60,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: TabBar(
          controller: _tabx.controller,
          indicatorColor: myTheme.primaryColor,
          indicatorWeight: 3,
          labelColor: myTheme.primaryColor,
          unselectedLabelColor: Colors.grey[500],
          labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
          unselectedLabelStyle: GoogleFonts.cairo(fontSize: 13),
          tabs: [
            Tab(text: 'orders.previous'.tr, icon: const Icon(Icons.check_circle_outline_rounded, size: 20)),
            Tab(text: 'orders.cancelled'.tr, icon: const Icon(Icons.cancel_outlined, size: 20)),
            Tab(text: 'orders.current'.tr, icon: const Icon(Icons.pending_outlined, size: 20)),
          ],
        ),
      ),
      title: Text('orders.title'.tr, style: GoogleFonts.cairo(color: myTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Beautiful order card
// ─────────────────────────────────────────────────────────────────────────────
class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.items,
    required this.timestamp,
    this.showReorder = false,
    this.index = 0,
  });
  final OrdersModel items;
  final String timestamp;
  final bool showReorder;
  final int index;

  _StatusInfo get _status {
    final code = OrderStatusResolver.effectiveCode(items, items.statusCode);
    final label = OrderStatusHelper.labelFor(code);
    if (code == 9 || items.isCancel == true) {
      final cancelLabel = items.isUserCancel == true
          ? 'orders.cancelled_by_you'.tr
          : label;
      return _StatusInfo(cancelLabel, Colors.red, Icons.cancel_rounded);
    }
    if (code >= 7 || items.isDone == true) {
      return _StatusInfo(label, Colors.green, Icons.check_circle_rounded);
    }
    if (code >= 3) {
      return _StatusInfo(label, Colors.indigo, Icons.delivery_dining_rounded);
    }
    if (code >= 1 || items.isApporve == true) {
      return _StatusInfo(label, Colors.blue[700]!, Icons.thumb_up_rounded);
    }
    return _StatusInfo(label, Colors.orange[700]!, Icons.hourglass_top_rounded);
  }

  Future<void> _reorder() async {
    final orderId = items.orderId?.toString() ?? '0';
    final detailsCtrl = Get.put(OrderDetailsController(), tag: 'reorder_$orderId');
    detailsCtrl.OrderId = orderId;
    await detailsCtrl.fetchData();
    if (detailsCtrl.itemscurrent.isEmpty) {
      ErrorMessage.SnackMessage('لا يمكن إعادة هذا الطلب', Colors.red[400]!);
      Get.delete<OrderDetailsController>(tag: 'reorder_$orderId');
      return;
    }
    ListItemCard.itemscard.clear();
    for (final d in detailsCtrl.itemscurrent) {
      d.orderDetailId = null; d.orderId = null; d.orderNo = null;
      d.netAmount = null; d.totalDiscount = null; d.total = null;
      d.isCancel = null; d.isApporve = null; d.isDone = null;
      ListItemCard.itemscard.add(d);
    }
    if (Get.isRegistered<AppBadgeController>()) {
      Get.find<AppBadgeController>().refreshCart();
    }
    Get.delete<OrderDetailsController>(tag: 'reorder_$orderId');
    Get.delete<SendOrderController>(force: true);
    Get.to(const SendOrder(),
        duration: const Duration(milliseconds: 450),
        transition: Transition.rightToLeftWithFade);
  }

  @override
  Widget build(BuildContext context) {
    final st = _status;
    final primary = Theme.of(context).primaryColor;

    return GestureDetector(
      onTap: () => Get.to(
        () => const orderdeitals(),
        arguments: [items.orderId.toString()],
        duration: const Duration(milliseconds: 450),
        transition: Transition.fade,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(14, 6, 14, 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              // ── Row: logo + info + status ──────────────────────
              Row(
                children: [
                  // Status badge (left in RTL = leading)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: st.color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(st.icon, color: st.color, size: 13),
                      const SizedBox(width: 4),
                      Text(st.label,
                          style: GoogleFonts.cairo(
                              color: st.color, fontSize: 12, fontWeight: FontWeight.bold)),
                    ]),
                  ),

                  const Spacer(),

                  // Info (right-aligned)
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          items.restaurantName ?? '',
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cairo(
                              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[850]),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'رقم الطلب: ${items.orderNo ?? ""}',
                          textAlign: TextAlign.right,
                          style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  // Logo
                  ClipOval(
                    child: items.logo != null && items.logo!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: items.logo!,
                            width: 50, height: 50, fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: Colors.grey[100]),
                            errorWidget: (_, __, ___) => _logoFallback(primary),
                          )
                        : _logoFallback(primary),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.grey[100]),
              const SizedBox(height: 10),

              // ── Row: price + date ─────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Date
                  Row(children: [
                    Icon(Icons.access_time_rounded, size: 13, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(timestamp,
                        style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey[400])),
                  ]),
                  // Price
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${items.netAmount?.toStringAsFixed(0) ?? "0"} د.ع',
                      style: GoogleFonts.cairo(
                          color: primary, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              // ── Reorder button ────────────────────────────────
              if (showReorder) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _reorder,
                    icon: Icon(Icons.replay_rounded, size: 16, color: primary),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primary,
                      side: BorderSide(color: primary, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    label: Text('orders.reorder'.tr,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: primary)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
  }

  Widget _logoFallback(Color primary) => Container(
      width: 50, height: 50, color: primary.withOpacity(0.1),
      child: Icon(Icons.restaurant_rounded, color: primary.withOpacity(0.4), size: 24));
}

class _StatusInfo {
  final String label;
  final Color color;
  final IconData icon;
  const _StatusInfo(this.label, this.color, this.icon);
}

// ─────────────────────────────────────────────────────────────────────────────
// Shimmer placeholder
// ─────────────────────────────────────────────────────────────────────────────
class _OrderShimmer extends StatelessWidget {
  const _OrderShimmer();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[50]!,
        child: Container(
          height: 120,
          margin: const EdgeInsets.fromLTRB(14, 6, 14, 6),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}

// keep old alias so existing refs compile
class GetShimmer extends _OrderShimmer {
  const GetShimmer({Key? key}) : super();
}

// keep FillOrderaData so any external reference compiles
class FillOrderaData extends StatelessWidget {
  const FillOrderaData({Key? key, required this.items, required this.convertedTimestamp, this.showReorder = false}) : super(key: key);
  final OrdersModel items;
  final String convertedTimestamp;
  final bool showReorder;
  @override
  Widget build(BuildContext context) =>
      _OrderCard(items: items, timestamp: convertedTimestamp, showReorder: showReorder);
}
