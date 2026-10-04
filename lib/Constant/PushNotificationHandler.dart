import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/driver_tracking_navigation.dart';
import 'package:romanaappflutter/Constant/order_refresh_coordinator.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/views/LastOrderView.dart';
import 'package:romanaappflutter/views/PostOrderRatingView.dart';
import 'package:romanaappflutter/views/notification.dart';
import 'package:romanaappflutter/views/orderdeitals.dart';

/// Wires OneSignal foreground / open handlers to show in-app UI.
class PushNotificationHandler {
  static bool _registered = false;

  static void register() {
    if (_registered) return;
    _registered = true;

    // FOREGROUND: show in-app banner AND let the system display the notification
    // in the tray (so the user always sees it, even when the app is open).
    OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
      final data = event.notification.additionalData;
      final orderId = int.tryParse(data?['orderId']?.toString() ?? '');
      if ((data?['type'] ?? '').toString() == 'order_status' && orderId != null) {
        await OrderRefreshCoordinator.refreshForOrder(orderId);
      }
      showInAppBanner(
        title: event.notification.title ?? 'إشعار جديد',
        body: event.notification.body ?? '',
        data: data,
      );
      if (Get.isRegistered<AppBadgeController>()) {
        Get.find<AppBadgeController>().bumpNotification();
      }
    });

    // BACKGROUND/CLOSED TAP: navigate to relevant screen
    OneSignal.Notifications.addClickListener((event) {
      _navigateForData(event.notification.additionalData);
    });
  }

  static void showInAppBanner({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) {
    void present({int tries = 0}) {
      final ctx = Get.overlayContext ?? Get.context;
      if (ctx == null) {
        if (tries >= 15) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          present(tries: tries + 1);
        });
        return;
      }

      final overlay = Overlay.maybeOf(ctx, rootOverlay: true);
      if (overlay == null) {
        if (tries >= 15) return;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          present(tries: tries + 1);
        });
        return;
      }

      late OverlayEntry entry;

      final map =
          data != null ? Map<String, dynamic>.from(data) : null;
      final statusCode = OrderStatusHelper.codeFromPayload(map);
      final statusKey = (data?['statusKey'] ?? data?['status'] ?? '')
          .toString()
          .toLowerCase();
      final statusText = statusCode != null
          ? OrderStatusHelper.labelFor(statusCode)
          : (data?['statusText'] ?? _arabicStatus(statusKey)).toString();

      entry = OverlayEntry(builder: (_) {
        return _BannerWidget(
          title: title,
          body: body,
          statusText: statusText.isEmpty ? null : statusText,
          statusColor: _statusColorFromCode(statusCode, statusKey),
          statusIcon: _statusIconFromCode(statusCode, statusKey),
          onTap: () {
            entry.remove();
            _navigateForData(data);
          },
          onDismiss: () => entry.remove(),
        );
      });

      overlay.insert(entry);

      Future.delayed(const Duration(seconds: 5), () {
        try {
          entry.remove();
        } catch (_) {}
      });
    }

    present();
  }

  static void _navigateForData(Map<String, dynamic>? data) {
    final type = (data?['type'] ?? data?['screen'] ?? '').toString();
    final statusKey = (data?['statusKey'] ?? '').toString();
    if (statusKey == 'confirmed' || statusKey == 'done') {
      final id = int.tryParse(data?['orderId']?.toString() ?? '');
      if (id != null && id > 0) {
        Get.to(() => PostOrderRatingView(orderId: id),
            duration: const Duration(milliseconds: 400),
            transition: Transition.downToUp);
        return;
      }
    }
    if (DriverTrackingNavigation.shouldOpenTracking(statusKey: statusKey)) {
      final id = int.tryParse(data?['orderId']?.toString() ?? '');
      if (id != null && id > 0) {
        DriverTrackingNavigation.openIfTrackable(id, statusKey: statusKey);
        return;
      }
    }
    switch (type) {
      case 'order':
      case 'order_status':
        final id = data?['orderId']?.toString();
        if (id != null && id.isNotEmpty) {
          Get.to(const orderdeitals(),
              arguments: [id],
              duration: const Duration(milliseconds: 400),
              transition: Transition.rightToLeftWithFade);
          return;
        }
        Get.to(const LastOrderView());
        return;
      case 'last_order':
        Get.to(const LastOrderView());
        return;
      default:
        Get.to(const notification(),
            duration: const Duration(milliseconds: 400),
            transition: Transition.rightToLeftWithFade);
    }
  }

  static String _arabicStatus(String s) {
    switch (s) {
      case 'pending':
      case 'wait':
      case 'waiting':
        return 'انتظار';
      case 'approved':
      case 'approve':
      case 'accepted':
        return 'مقبول';
      case 'done':
      case 'completed':
        return 'منتهي';
      case 'cancel':
      case 'canceled':
      case 'rejected':
        return 'مرفوض';
      default:
        return '';
    }
  }

  static Color _statusColorFromCode(int? code, String statusKey) {
    if (code == 9) return const Color(0xFFD32F2F);
    if (code != null && code >= 8) return const Color(0xFF2E7D32);
    if (code == 0) return const Color(0xFFEF6C00);
    if (code != null && code >= 1) return const Color(0xFF1B5E20);
    return _statusColor(statusKey);
  }

  static IconData _statusIconFromCode(int? code, String statusKey) {
    if (code == 9) return Icons.cancel_rounded;
    if (code != null && code >= 8) return Icons.check_circle_rounded;
    if (code == 0) return Icons.hourglass_top_rounded;
    if (code != null && code >= 5) return Icons.delivery_dining_rounded;
    return _statusIcon(statusKey);
  }

  static Color _statusColor(String s) {
    switch (s) {
      case 'done':
      case 'completed':
        return const Color(0xFF2E7D32); // green
      case 'approved':
      case 'approve':
      case 'accepted':
        return const Color(0xFF1B5E20); // dark green
      case 'cancel':
      case 'canceled':
      case 'rejected':
        return const Color(0xFFD32F2F); // red
      case 'pending':
      case 'wait':
      case 'waiting':
        return const Color(0xFFEF6C00); // orange
      default:
        return const Color(0xFFDB2820); // brand
    }
  }

  static IconData _statusIcon(String s) {
    switch (s) {
      case 'done':
      case 'completed':
        return Icons.check_circle_rounded;
      case 'approved':
      case 'approve':
      case 'accepted':
        return Icons.thumb_up_alt_rounded;
      case 'cancel':
      case 'canceled':
      case 'rejected':
        return Icons.cancel_rounded;
      case 'pending':
      case 'wait':
      case 'waiting':
        return Icons.hourglass_top_rounded;
      default:
        return Icons.notifications_active_rounded;
    }
  }
}

class _BannerWidget extends StatefulWidget {
  final String title;
  final String body;
  final String? statusText;
  final Color statusColor;
  final IconData statusIcon;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _BannerWidget({
    required this.title,
    required this.body,
    required this.statusColor,
    required this.statusIcon,
    this.statusText,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  State<_BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<_BannerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _slide = Tween<Offset>(
            begin: const Offset(0, -1), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.statusColor;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 12,
      right: 12,
      child: SlideTransition(
        position: _slide,
        child: Material(
          elevation: 12,
          borderRadius: BorderRadius.circular(18),
          color: Colors.transparent,
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.white,
                    accent.withOpacity(0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: accent.withOpacity(0.25), width: 1),
                boxShadow: [
                  BoxShadow(
                      color: accent.withOpacity(0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                children: [
                  // Top accent bar
                  Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: accent,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: widget.onDismiss,
                          icon: Icon(Icons.close,
                              color: Colors.grey[400], size: 18),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (widget.statusText != null &&
                                      widget.statusText!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: accent.withOpacity(0.12),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                            color: accent.withOpacity(0.4),
                                            width: 1),
                                      ),
                                      child: Text(
                                        widget.statusText!,
                                        style: GoogleFonts.cairo(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: accent),
                                      ),
                                    ),
                                  if (widget.statusText != null &&
                                      widget.statusText!.isNotEmpty)
                                    const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(widget.title,
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.cairo(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(widget.body,
                                  textAlign: TextAlign.right,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      color: Colors.grey[700])),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: accent.withOpacity(0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: accent.withOpacity(0.35), width: 1)),
                          child: Icon(widget.statusIcon,
                              color: accent, size: 22),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ).animate().fadeIn(duration: 250.ms),
      ),
    );
  }
}
