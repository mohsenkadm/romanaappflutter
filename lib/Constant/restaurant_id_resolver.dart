import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/RestaourantProfileController.dart';
/// Resolves restaurant id when product JSON omits it.
class RestaurantIdResolver {
  RestaurantIdResolver._();

  static int fromProductId(int? restaurantId) {
    if (restaurantId != null && restaurantId > 0) return restaurantId;
    return fromProfileContext();
  }

  static int fromCartOrProfile() {
    for (final item in ListItemCard.itemscard) {
      if (item.restaurantId > 0) return item.restaurantId;
    }
    return fromProfileContext();
  }

  static int fromProfileContext() {
    if (Get.isRegistered<RestaourantProfileController>()) {
      final c = Get.find<RestaourantProfileController>();
      final fromResId = int.tryParse(c.resId) ?? 0;
      if (fromResId > 0) return fromResId;
      final fromRestaurant = c.item.value.restaurantId;
      if (fromRestaurant != null && fromRestaurant > 0) return fromRestaurant;
    }
    return 0;
  }

  static void patchCartRestaurantIds(int restaurantId) {
    if (restaurantId <= 0) return;
    for (final item in ListItemCard.itemscard) {
      if (item.restaurantId <= 0) {
        item.restaurantId = restaurantId;
      }
    }
  }

}
