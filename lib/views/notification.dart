import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/core/locale/locale_service.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/Controller/notificationController.dart';
import 'package:romanaappflutter/Model/NotifModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:shimmer/shimmer.dart';

// ignore: camel_case_types
class notification extends StatefulWidget {
  const notification({Key? key}) : super(key: key);

  @override
  State<notification> createState() => _notification();
}

// ignore: camel_case_types
class _notification extends State<notification> {
  final notificationController _controller =
      Get.find<notificationController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.markAllRead();
      if (Get.isRegistered<AppBadgeController>()) {
        Get.find<AppBadgeController>().clearNotifications();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = myTheme.primaryColor;
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: const Color(0xFFF8F9FC),
          body: NestedScrollView(
            headerSliverBuilder: (ctx, _) => [
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 110,
                elevation: 0,
                backgroundColor: Colors.white,
                surfaceTintColor: Colors.transparent,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios_rounded,
                        color: primary, size: 18),
                    onPressed: () => Get.back(),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding:
                      const EdgeInsets.only(right: 56, bottom: 14),
                  title: Text(
                    'الإشعارات',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primary.withOpacity(0.05), Colors.white],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 24, top: 52),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [primary, primary.withOpacity(0.7)]),
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                  color: primary.withOpacity(0.25),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3)),
                            ],
                          ),
                          child: const Icon(
                              Icons.notifications_rounded,
                              color: Colors.white,
                              size: 22),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: RefreshIndicator(
              color: primary,
              onRefresh: () => _controller.fetchData(),
              child: Obx(() {
                if (_controller.isloded.value) {
                  return const _GetShimmer();
                }
                if (_controller.items.isEmpty) {
                  return _buildEmpty(primary);
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: _controller.items.length,
                  itemBuilder: (context, index) {
                    final ts = GetTimeAgo.parse(
                        _controller.items[index].dateInsert,
                        locale: LocaleService.to.code.value);
                    return FadeInUp(
                      delay: Duration(milliseconds: 50 * index),
                      duration: const Duration(milliseconds: 350),
                      child: FillNotificationData(
                          items: _controller.items[index],
                          convertedTimestamp: ts),
                    );
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmpty(Color primary) {
    return Center(
      child: FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications_off_outlined,
                  size: 60, color: primary.withOpacity(0.4)),
            ),
            const SizedBox(height: 16),
            const Text(
              'لا توجد إشعارات',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF555555)),
            ),
            const SizedBox(height: 6),
            Text('ستظهر الإشعارات الجديدة هنا',
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
          ],
        ),
      ),
    );
  }
}

class FillNotificationData extends StatelessWidget {
  const FillNotificationData({
    Key? key,
    required this.items,
    required String convertedTimestamp,
  })  : _convertedTimestamp = convertedTimestamp,
        super(key: key);

  final NotifModel items;
  final String _convertedTimestamp;

  @override
  Widget build(BuildContext context) {
    final primary = myTheme.primaryColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (items.images != null && items.images!.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: items.images!,
                height: 140,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                    height: 140,
                    color: Colors.grey[100],
                    child: Center(
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: primary))),
                errorWidget: (_, __, ___) => const SizedBox(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        items.title,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: primary,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        items.details,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            _convertedTimestamp,
                            style: TextStyle(
                                fontSize: 11, color: Colors.grey[400]),
                          ),
                          const SizedBox(width: 5),
                          Icon(Icons.access_time_rounded,
                              size: 12, color: Colors.grey[400]),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primary, primary.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                          color: primary.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: const Icon(Icons.notifications_rounded,
                      color: Colors.white, size: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GetShimmer extends StatelessWidget {
  const _GetShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          highlightColor: Colors.grey[50]!,
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                            height: 14,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7))),
                        const SizedBox(height: 8),
                        Container(
                            height: 11,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6))),
                        const SizedBox(height: 8),
                        Container(
                            height: 10,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5))),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
