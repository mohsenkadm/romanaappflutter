import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/core/locale/locale_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Constant/restaurant_id_resolver.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Controller/SupportPhoneController.dart';
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/AllRestaourent.dart';
import 'package:romanaappflutter/Constant/location_storage.dart';
import 'package:romanaappflutter/views/CoverageGate.dart';
import 'package:romanaappflutter/views/SendOrder.dart';
import 'package:romanaappflutter/views/orderdeitals.dart';
import 'package:shimmer/shimmer.dart';

import '../Controller/OrderDetailsController.dart';

class MyLatestOrders extends StatefulWidget {
  const MyLatestOrders({Key? key}) : super(key: key);

  @override
  State<MyLatestOrders> createState() => _MyLatestOrdersState();
}

class _MyLatestOrdersState extends State<MyLatestOrders>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final MyOrderController _controller = MyOrderController.instance;
  final ProfileuserController _profileuserController =
      Get.find<ProfileuserController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => _profileuserController.user.value == null
        ? _buildNotLoggedIn(context)
        : _buildOrdersContent(context));
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: myTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 60,
                color: myTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'سجل دخولك لعرض طلباتك',
            style: TextStyle(
              color: myTheme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () => Get.to(
              () => const AllRestaourent(),
              arguments: "",
              duration: const Duration(milliseconds: 500),
              transition: Transition.rightToLeftWithFade,
            ),
            icon: const Icon(Icons.shopping_basket_rounded, color: Colors.white),
            style: ElevatedButton.styleFrom(
              backgroundColor: myTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            label: const Text('اطلب الان',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersContent(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          margin: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: myTheme.primaryColor,
              boxShadow: [
                BoxShadow(
                  color: myTheme.primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
            labelStyle: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                fontWeight: FontWeight.bold),
            unselectedLabelStyle:
                const TextStyle(fontFamily: 'Tajawal', fontSize: 13),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'الأخير'),
              Tab(text: 'السابقة'),
              Tab(text: 'الملغية'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Tab content
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildLatestOrderTab(context),
              _buildPreviousOrdersTab(context),
              _buildCancelledOrdersTab(context),
            ],
          ),
        ),
      ],
    );
  }

  // Latest Order Tab - shows the most recent order with details
  Widget _buildLatestOrderTab(BuildContext context) {
    return Obx(() {
      if (_controller.isloded.value) {
        return const _OrderShimmer();
      }

      // Show latest from current orders, or if none, from done orders
      OrdersModel? latestOrder;
      if (_controller.itemscurrent.isNotEmpty) {
        latestOrder = _controller.itemscurrent.first;
      } else if (_controller.itemsdone.isNotEmpty) {
        latestOrder = _controller.itemsdone.first;
      }

      if (latestOrder == null) {
        return _buildEmptyState(
          icon: Icons.receipt_long_rounded,
          message: 'لا توجد طلبات حديثة',
        );
      }

      return RefreshIndicator(
        onRefresh: () => _controller.fetchData(),
        color: myTheme.primaryColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: _LatestOrderCard(order: latestOrder),
          ),
        ),
      );
    });
  }

  // Previous Orders Tab
  Widget _buildPreviousOrdersTab(BuildContext context) {
    return Obx(() {
      if (_controller.isloded.value) {
        return const _OrderShimmer();
      }
      if (_controller.itemsdone.isEmpty) {
        return _buildEmptyState(
          icon: Icons.history_rounded,
          message: 'لا توجد طلبات سابقة',
        );
      }
      return RefreshIndicator(
        onRefresh: () => _controller.fetchData(),
        color: myTheme.primaryColor,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: _controller.itemsdone.length,
          itemBuilder: (context, index) {
            final order = _controller.itemsdone[index] as OrdersModel;
            final timeAgo =
                GetTimeAgo.parse(order.orderDate, locale: LocaleService.to.code.value);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (index * 80)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(30 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: _PreviousOrderCard(
                order: order,
                timeAgo: timeAgo,
              ),
            );
          },
        ),
      );
    });
  }

  // Cancelled Orders Tab
  Widget _buildCancelledOrdersTab(BuildContext context) {
    return Obx(() {
      if (_controller.isloded.value) {
        return const _OrderShimmer();
      }
      if (_controller.itemscancel.isEmpty) {
        return _buildEmptyState(
          icon: Icons.cancel_rounded,
          message: 'لا توجد طلبات ملغية',
        );
      }
      return RefreshIndicator(
        onRefresh: () => _controller.fetchData(),
        color: myTheme.primaryColor,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: _controller.itemscancel.length,
          itemBuilder: (context, index) {
            final order = _controller.itemscancel[index] as OrdersModel;
            final timeAgo =
                GetTimeAgo.parse(order.orderDate, locale: LocaleService.to.code.value);
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 300 + (index * 80)),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(30 * (1 - value), 0),
                    child: child,
                  ),
                );
              },
              child: _CancelledOrderCard(order: order, timeAgo: timeAgo),
            );
          },
        ),
      );
    });
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 50, color: Colors.grey[400]),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

// Latest Order Card with full details
class _LatestOrderCard extends StatelessWidget {
  final OrdersModel order;
  const _LatestOrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final timeAgo = GetTimeAgo.parse(order.orderDate, locale: LocaleService.to.code.value);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: myTheme.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusText(order),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                // Order info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      order.restaurantName ?? '',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'طلب رقم: ${order.orderNo}',
                      style:
                          TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                if (order.logo != null && order.logo!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: order.logo!,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (c, u) =>
                          const CircularProgressIndicator(color: Colors.white),
                      errorWidget: (c, u, e) =>
                          const Icon(Icons.store, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ),

          // Order details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildInfoRow(Icons.access_time_rounded, 'الوقت', timeAgo),
                const SizedBox(height: 10),
                _buildInfoRow(Icons.attach_money_rounded, 'المبلغ',
                    OrderStatusHelper.formatIqd(order.netAmount ?? 0)),
                const SizedBox(height: 10),
                if (order.total != null)
                  _buildInfoRow(Icons.receipt_rounded, 'المجموع',
                      OrderStatusHelper.formatIqd(order.total ?? 0)),
              ],
            ),
          ),

          // Action buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // View details
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(
                        () => const orderdeitals(),
                        arguments: [order.orderId.toString()],
                        duration: const Duration(milliseconds: 500),
                        transition: Transition.rightToLeftWithFade,
                      );
                    },
                    icon: const Icon(Icons.visibility_rounded,
                        color: Colors.white, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    label: const Text('عرض التفاصيل',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 10),
                // WhatsApp help button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _openWhatsApp(order),
                    icon: Icon(Icons.support_agent_rounded,
                        color: myTheme.primaryColor, size: 18),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: myTheme.primaryColor,
                      side: BorderSide(color: myTheme.primaryColor, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    label: Text('طلب مساعدة عبر واتساب',
                          style: TextStyle(
                              fontSize: 14,
                              color: myTheme.primaryColor,
                              fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Text(value,
            style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        const Spacer(),
        Text(label,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500)),
        const SizedBox(width: 8),
        Icon(icon, size: 18, color: myTheme.primaryColor),
      ],
    );
  }

  void _openWhatsApp(OrdersModel order) {
    SupportPhoneController.instance.openWhatsApp(
      message: 'مرحبا، أحتاج مساعدة بخصوص الطلب رقم: ${order.orderNo}',
    );
  }

  Color _getStatusColor(OrdersModel order) {
    if (order.isCancel == true) return Colors.red;
    if (order.isDone == true) return Colors.green;
    if (order.isApporve == true) return Colors.green[700]!;
    return Colors.orange;
  }

  String _getStatusText(OrdersModel order) {
    if (order.isCancel == true) return 'مرفوض';
    if (order.isDone == true) return 'منتهي';
    if (order.isApporve == true) return 'مقبول';
    return 'انتظار';
  }
}

// Previous Order Card with Reorder button
class _PreviousOrderCard extends StatelessWidget {
  final OrdersModel order;
  final String timeAgo;
  const _PreviousOrderCard({required this.order, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(
            () => const orderdeitals(),
            arguments: [order.orderId.toString()],
            duration: const Duration(milliseconds: 500),
            transition: Transition.rightToLeftWithFade,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  // Reorder button
                  SizedBox(
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: () => _reorder(context, order),
                      icon: const Icon(Icons.replay_rounded,
                          color: Colors.white, size: 16),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      label: const Text('اعادة الطلب',
                            style: TextStyle(
                                fontSize: 12, color: Colors.white)),
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        order.restaurantName ?? '',
                        style: TextStyle(
                            fontSize: 16,
                            color: myTheme.primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'طلب #${order.orderNo}',
                        style:
                            TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 2),
                      Text(timeAgo,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(width: 10),
                  if (order.logo != null && order.logo!.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: order.logo!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        placeholder: (c, u) =>
                            const CircularProgressIndicator(),
                        errorWidget: (c, u, e) =>
                            const Icon(Icons.store),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('منتهي',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    OrderStatusHelper.formatIqd(order.netAmount ?? 0),
                    style: TextStyle(
                        fontSize: 14,
                        color: myTheme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _reorder(BuildContext context, OrdersModel order) async {
    // Fetch order details and add items to cart
    try {
      final OrderDetailsController detailsController =
          Get.put(OrderDetailsController(), tag: 'reorder_${order.orderId}');
      detailsController.OrderId = order.orderId.toString();
      await detailsController.fetchData();

      if (detailsController.itemscurrent.isNotEmpty) {
        // Clear existing cart
        ListItemCard.itemscard.clear();
        // Add all items from the order to the cart
        for (var item in detailsController.itemscurrent) {
          final orderDetail = item as OrderDetailModel;
          ListItemCard.itemscard.add(OrderDetailModel(
            productsId: orderDetail.productsId,
            price: orderDetail.price ?? orderDetail.unitPrice,
            count: orderDetail.count > 0 ? orderDetail.count : 1,
            productsName: orderDetail.productsName,
            productsDetails: orderDetail.productsDetails,
            productsImage: orderDetail.productsImage,
            subCategoriesName: orderDetail.subCategoriesName,
            restaurantId: orderDetail.restaurantId > 0
                ? orderDetail.restaurantId
                : RestaurantIdResolver.fromProfileContext(),
          ));
        }
        if (Get.isRegistered<AppBadgeController>()) {
          Get.find<AppBadgeController>().refreshCart();
        }
        // Navigate to SendOrder (guarded by city selection).
        await _ensureCityThenSendOrder();
      }
      Get.delete<OrderDetailsController>(tag: 'reorder_${order.orderId}');
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء اعادة الطلب',
          backgroundColor: Colors.red[400], colorText: Colors.white);
    }
  }

  Future<void> _ensureCityThenSendOrder() async {
    if (!LocationStorage.coverageVerified) {
      Get.snackbar(
        'تحديد الموقع',
        'يجب تحديد موقعك والتحقق من التغطية أولاً',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 12,
        duration: const Duration(seconds: 2),
      );
      await Get.to(
        () => const CoverageGate(),
        duration: const Duration(milliseconds: 400),
        transition: Transition.rightToLeftWithFade,
      );
      if (!LocationStorage.coverageVerified) return;
    }

    Get.to(
      () => const SendOrder(),
      duration: const Duration(milliseconds: 500),
      transition: Transition.rightToLeftWithFade,
    );
  }
}

// Cancelled Order Card
class _CancelledOrderCard extends StatelessWidget {
  final OrdersModel order;
  final String timeAgo;
  const _CancelledOrderCard({required this.order, required this.timeAgo});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: Colors.red.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(
            () => const orderdeitals(),
            arguments: [order.orderId.toString()],
            duration: const Duration(milliseconds: 500),
            transition: Transition.rightToLeftWithFade,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('مرفوض',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    OrderStatusHelper.formatIqd(order.netAmount ?? 0),
                    style: TextStyle(
                        fontSize: 14,
                        color: myTheme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    order.restaurantName ?? '',
                    style: TextStyle(
                        fontSize: 16,
                        color: myTheme.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('طلب #${order.orderNo}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                  const SizedBox(height: 2),
                  Text(timeAgo,
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey[400])),
                ],
              ),
              const SizedBox(width: 10),
              if (order.logo != null && order.logo!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: order.logo!,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    placeholder: (c, u) =>
                        const CircularProgressIndicator(),
                    errorWidget: (c, u, e) => const Icon(Icons.store),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Shimmer loading
class _OrderShimmer extends StatelessWidget {
  const _OrderShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 90,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }
}
