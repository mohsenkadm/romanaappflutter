import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Constant/order_status_helper.dart';
import 'package:romanaappflutter/Controller/SendOrderController.dart';
import 'package:romanaappflutter/main.dart';

// ignore: camel_case_types
class SendOrder extends StatefulWidget {
  const SendOrder({Key? key}) : super(key: key);
  @override
  State<SendOrder> createState() => _SendOrder();
}

// ignore: camel_case_types
class _SendOrder extends State<SendOrder> {
  final SendOrderController _controller = Get.put(SendOrderController());
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Container(
            child: ListItemCard.itemscard.isEmpty
                ? Center(
                    child: Container(
                      height: 250,
                      width: 300,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(
                            Icons.production_quantity_limits,
                            size: 100,
                            color: myTheme.primaryColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'لا توجد منتجات في السلة',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  )
                : GetBuilder<SendOrderController>(
                    init: _controller,
                    builder: (controller) => Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: ListItemCard.itemscard.length,
                          itemBuilder: (context, index) {
                            return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color:
                                        Theme.of(context).secondaryHeaderColor),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                padding: const EdgeInsets.all(0),
                                child: ListTile(
                                  title: Text(
                                    ListItemCard.itemscard[index].productsName,
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  leading: Text(
                                    ' ${OrderStatusHelper.formatIqd((ListItemCard.itemscard[index].unitPrice *
                                                    ListItemCard
                                                        .itemscard[index].count))}',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18),
                                  ),
                                  trailing: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: myTheme.secondaryHeaderColor),
                                    child: Center(
                                      child: Text(
                                        ListItemCard.itemscard[index].count
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: Text(
                              'ادخال المعلومات',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
                        Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Theme.of(context)
                                //         .secondaryHeaderColor, // Set your desired background color here
                                //     borderRadius: BorderRadius.circular(
                                //         8.0), // Optional: Add rounded corners
                                //   ),
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 15, vertical: 10),
                                //   width: double.infinity,
                                //   child: TextFormField(
                                //       controller: controller.nameController,
                                //       validator: (value) {
                                //         if (value == null || value.isEmpty) {
                                //           return 'اكتب اسمك الكامل';
                                //         }
                                //         return null;
                                //       },
                                //       decoration: const InputDecoration(
                                //         hintTextDirection: TextDirection.rtl,
                                //         hintText: 'اسمك الكامل',
                                //         contentPadding: EdgeInsets.all(15),
                                //         border: OutlineInputBorder(
                                //           borderSide: BorderSide.none,
                                //         ),
                                //       )),
                                // ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Theme.of(context)
                                //         .secondaryHeaderColor, // Set your desired background color here
                                //     borderRadius: BorderRadius.circular(
                                //         8.0), // Optional: Add rounded corners
                                //   ),
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 15, vertical: 10),
                                //   width: double.infinity,
                                //   child: TextFormField(
                                //       controller: controller.phoneController,
                                //       validator: (value) {
                                //         if (value == null || value.isEmpty) {
                                //           return 'اكتب رقم الهاتف';
                                //         }
                                //         return null;
                                //       },
                                //       decoration: const InputDecoration(
                                //         hintTextDirection: TextDirection.rtl,
                                //         hintText: 'رقم الهاتف',
                                //         contentPadding: EdgeInsets.all(15),
                                //         border: OutlineInputBorder(
                                //           borderSide: BorderSide.none,
                                //         ),
                                //       )),
                                // ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Theme.of(context)
                                //         .secondaryHeaderColor, // Set your desired background color here
                                //     borderRadius: BorderRadius.circular(
                                //         8.0), // Optional: Add rounded corners
                                //   ),
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 15, vertical: 10),
                                //   width: double.infinity,
                                //   child: TextFormField(
                                //       controller: controller.addressController,
                                //       validator: (value) {
                                //         if (value == null || value.isEmpty) {
                                //           return 'اكتب عنوانك الكامل';
                                //         }
                                //         return null;
                                //       },
                                //       decoration: const InputDecoration(
                                //         hintTextDirection: TextDirection.rtl,
                                //         hintText: 'عنوانك',
                                //         contentPadding: EdgeInsets.all(15),
                                //         border: OutlineInputBorder(
                                //           borderSide: BorderSide.none,
                                //         ),
                                //       )),
                                // ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     color: Theme.of(context)
                                //         .secondaryHeaderColor, // Set your desired background color here
                                //     borderRadius: BorderRadius.circular(
                                //         8.0), // Optional: Add rounded corners
                                //   ),
                                //   margin: const EdgeInsets.symmetric(
                                //       horizontal: 15, vertical: 10),
                                //   width: double.infinity,
                                //   child: TextFormField(
                                //       controller: controller.pointController,
                                //       validator: (value) {
                                //         if (value == null || value.isEmpty) {
                                //           return 'اكتب اقرب نقطة دالة';
                                //         }
                                //         return null;
                                //       },
                                //       decoration: const InputDecoration(
                                //         hintTextDirection: TextDirection.rtl,
                                //         hintText: 'اقرب نقطة دالة',
                                //         contentPadding: EdgeInsets.all(15),
                                //         border: OutlineInputBorder(
                                //           borderSide: BorderSide.none,
                                //         ),
                                //       )),
                                // ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor, // Set your desired background color here
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Optional: Add rounded corners
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: TextField(
                                      controller: controller.noteController,
                                      decoration: const InputDecoration(
                                        hintTextDirection: TextDirection.rtl,
                                        hintText: 'ملاحظات',
                                        contentPadding: EdgeInsets.all(15),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                      )),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .secondaryHeaderColor,
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: double.infinity,
                                  child: TextField(
                                    controller:
                                        controller.promocodeController,
                                    textAlign: TextAlign.right,
                                    decoration: InputDecoration(
                                      hintTextDirection: TextDirection.rtl,
                                      hintText: 'اكتب كود الخصم',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 14),
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Obx(
                                        () => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 6),
                                          child: TextButton(
                                            onPressed:
                                                _controller.islodedbtn.value
                                                    ? null
                                                    : () => _controller
                                                        .getpromocode(),
                                            style: TextButton.styleFrom(
                                              backgroundColor: Theme.of(
                                                      context)
                                                  .primaryColor,
                                              foregroundColor: Colors.white,
                                              disabledBackgroundColor:
                                                  Theme.of(context)
                                                      .primaryColor
                                                      .withOpacity(0.5),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: _controller
                                                    .islodedbtn.value
                                                ? const SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    'تطبيق الخصم',
                                                    style: GoogleFonts.cairo(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 0,
                                        minHeight: 0,
                                      ),
                                    ),
                                  ),
                                ),
                                Obx(() => _controller.promoError.value.isEmpty
                                    ? const SizedBox.shrink()
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 4),
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            _controller.promoError.value,
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12),
                                          ),
                                        ),
                                      )),
                                Obx(() => _controller.promoApplied.value
                                    ? Container(
                                        width: double.infinity,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade50,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: Colors.green.shade300),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle,
                                                color: Colors.green[700],
                                                size: 26),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'تم تطبيق الخصم',
                                                    style: GoogleFonts.cairo(
                                                      color: Colors.green[800],
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    OrderStatusHelper.formatIqd(
                                                        _controller
                                                            .discountprice
                                                            .value),
                                                    textAlign: TextAlign.right,
                                                    style: GoogleFonts.cairo(
                                                      color: Colors.green[700],
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox.shrink()),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      16, 12, 16, 6),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      'ملخص التكلفة',
                                      style: GoogleFonts.cairo(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                _buildCostSummaryCard(context),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(14, 10, 14, 0),
                                  child: Obx(() {
                                    final canSend = _controller.canSubmitOrder;
                                    final sending =
                                        _controller.islodedbtnsend.value;
                                    final quoting =
                                        _controller.islodedQuote.value;
                                    final belowMin =
                                        !_controller.meetsMinOrder &&
                                            _controller.totalprice.value > 0;
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        if (belowMin)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Text(
                                              'الحد الأدنى للطلب ${OrderStatusHelper.formatIqd(_controller.minOrderAmount)}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.orange[800],
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ElevatedButton.icon(
                                          onPressed: sending
                                              ? null
                                              : () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    controller.sendorder();
                                                  }
                                                },
                                          icon: sending
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Icon(
                                                  Icons.shopping_cart_checkout,
                                                  color: Colors.white,
                                                ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: canSend
                                                ? myTheme.primaryColor
                                                : Colors.grey.shade400,
                                            disabledBackgroundColor:
                                                Colors.grey.shade400,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          label: Text(
                                            sending
                                                ? 'cart.sending'.tr
                                                : quoting
                                                    ? 'cart.quoting'.tr
                                                    : belowMin
                                                        ? 'الحد الأدنى ${_controller.minOrderAmount} د.ع'
                                                        : 'cart.send'.tr,
                                            style: GoogleFonts.cairo(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                                const SizedBox(height: 30),
                              ],
                            ))
                      ],
                    ),
                  ),
          ),
        ),
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
      );
  }

  Widget _buildCostSummaryCard(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final showDiscount = _controller.promoApplied.value ||
            _controller.discountprice.value > 0;
        return Column(
          children: [
            _costLine(
              icon: Icons.shopping_bag_outlined,
              label: 'مجموع الطلب',
              value: OrderStatusHelper.formatIqd(_controller.totalprice.value),
              color: primary,
            ),
            _costDivider(),
            _costLine(
              icon: Icons.delivery_dining_outlined,
              label: 'رسوم التوصيل',
              value: _controller.islodedQuote.value
                  ? '...'
                  : OrderStatusHelper.formatIqd(
                      _controller.costDelivery.value),
              color: primary,
            ),
            if (showDiscount) ...[
              _costDivider(),
              _costLine(
                icon: Icons.local_offer_outlined,
                label: 'مبلغ الخصم',
                value: OrderStatusHelper.formatIqd(
                    _controller.discountprice.value),
                color: Colors.green.shade700,
                valueColor: Colors.green.shade700,
              ),
            ],
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _controller.islodedQuote.value
                        ? const Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : Text(
                            OrderStatusHelper.formatIqd(
                                _controller.netAmount.value),
                            textAlign: TextAlign.left,
                            style: GoogleFonts.cairo(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                  ),
                  Text(
                    'المبلغ الكلي',
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.payments_outlined, size: 22, color: primary),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _costLine({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: GoogleFonts.cairo(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.grey.shade800,
              ),
            ),
          ),
          Text(
            label,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
        ],
      ),
    );
  }

  Widget _costDivider() => Divider(
        height: 1,
        thickness: 1,
        color: Colors.grey.shade100,
      );

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    return AppBar(
        leading: IconButton(
            onPressed: () {
              navigator?.pop();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "انهاء الطلب",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
