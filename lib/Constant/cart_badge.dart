import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/AppBadgeController.dart';
import 'package:romanaappflutter/views/shoppingcart.dart';

/// Opens the cart screen and refreshes the badge when returning.
void openShoppingCart() {
  if (Get.isRegistered<AppBadgeController>()) {
    Get.find<AppBadgeController>().refreshCart();
  }
  Get.to(
    const shoppingcard(),
    duration: const Duration(milliseconds: 500),
    transition: Transition.rightToLeftWithFade,
  )?.then((_) {
    if (Get.isRegistered<AppBadgeController>()) {
      Get.find<AppBadgeController>().refreshCart();
    }
  });
}

/// Reactive badge showing total product quantity in the cart.
class CartBadge extends StatelessWidget {
  const CartBadge({
    super.key,
    required this.child,
    this.position,
  });

  final Widget child;
  final badges.BadgePosition? position;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<AppBadgeController>()) return child;
    final ctrl = Get.find<AppBadgeController>();
    return Obx(() {
      final count = ctrl.cartCount.value;
      return badges.Badge(
        showBadge: count > 0,
        badgeContent: Text(
          count > 99 ? '99+' : '$count',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
        position: position ?? badges.BadgePosition.topEnd(top: -4, end: -4),
        child: child,
      );
    });
  }
}

/// Standard app-bar cart icon with badge (used across customer app screens).
class CartIconButton extends StatelessWidget {
  const CartIconButton({
    super.key,
    this.icon = Icons.shopping_cart_outlined,
    this.iconColor,
    this.backgroundColor,
    this.iconSize = 24,
    this.margin = const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
    this.onPressed,
  });

  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final double iconSize;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final primary = iconColor ?? Theme.of(context).primaryColor;
    final bg = backgroundColor ?? Theme.of(context).secondaryHeaderColor;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: bg,
      ),
      child: CartBadge(
        child: IconButton(
          onPressed: onPressed ?? openShoppingCart,
          icon: Icon(icon, color: primary, size: iconSize),
        ),
      ),
    );
  }
}
