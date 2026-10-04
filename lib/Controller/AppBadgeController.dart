import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/ShoppingCardController.dart';

/// شارات السلة والإشعارات في الشريط العلوي.
class AppBadgeController extends GetxController {
  final RxInt cartCount = 0.obs;
  final RxInt unreadNotifications = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshCart();
  }

  void refreshCart() {
    cartCount.value = ListItemCard.itemscard.fold<int>(
      0,
      (sum, item) => sum + item.count,
    );
    if (Get.isRegistered<ShoppingCardController>()) {
      Get.find<ShoppingCardController>().SumPrice();
    }
  }

  void bumpNotification() {
    unreadNotifications.value++;
  }

  void clearNotifications() {
    unreadNotifications.value = 0;
  }

  void setNotificationCount(int n) {
    unreadNotifications.value = n.clamp(0, 99);
  }
}
