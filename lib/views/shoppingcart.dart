import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/ShoppingCardController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:romanaappflutter/views/SendOrder.dart';

// ignore: camel_case_types
class shoppingcard extends StatefulWidget {
  const shoppingcard({Key? key}) : super(key: key);
  @override
  State<shoppingcard> createState() => _shoppingcard();
}

// ignore: camel_case_types
class _shoppingcard extends State<shoppingcard> {
  final ShoppingCardController _controller = Get.put(ShoppingCardController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyAppBar(),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () => _controller.fetchData(),
          child: GetBuilder<ShoppingCardController>(
            init: ShoppingCardController(),
            builder: (controller) => ListItemCard.itemscard.isEmpty
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
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
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
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 4, 0, 0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          ListItemCard.itemscard[index].total
                                                  .toString() +
                                              " د.ع ",
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 14),
                                        ),
                                        TextButton(
                                          onPressed: () => {
                                             _controller.update(),
                                            showBottomSheet(
                                                context: context,
                                                builder: (context) => Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: const <BoxShadow>[
                                                            BoxShadow(
                                                                color: Colors
                                                                    .black54,
                                                                blurRadius:
                                                                    15.0,
                                                                offset: Offset(
                                                                    0.0, 0.75))
                                                          ],
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(35),
                                                          color: Colors.white),
                                                      height: 400,
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        5,
                                                                    vertical:
                                                                        4),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            35),
                                                                    color: myTheme
                                                                        .secondaryHeaderColor),
                                                                child:
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon: Icon(
                                                                            Icons
                                                                                .close,
                                                                            color:
                                                                                myTheme.primaryColor)),
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10.0),
                                                                  child: Text(
                                                                    ListItemCard
                                                                        .itemscard[
                                                                            index]
                                                                        .productsName,
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
                                                                            .primaryColor,
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topRight,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(10),
                                                              child: Text(
                                                                ListItemCard
                                                                    .itemscard[
                                                                        index]
                                                                    .productsDetails,
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        16),
                                                              ),
                                                            ),
                                                          ),
                                                          Center(
                                                            child: Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        70),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            20.0),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(35),
                                                                              color: myTheme.secondaryHeaderColor),
                                                                          child: IconButton(
                                                                              onPressed: () {
                                                                               _controller.DeIncrement(index, context);
                                                                              },
                                                                              tooltip: "نقصان المنتج",
                                                                              icon: Icon(Icons.remove, size: 25, color: myTheme.primaryColor)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child: Container(
                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: myTheme.secondaryHeaderColor),
                                                                          child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 15),
                                                                            child:
                                                                                GetBuilder<ShoppingCardController>(
                                                                                  builder: (_controller) {
                                                                                    return Text(
                                                                             ListItemCard.itemscard[index].count.toString(),
                                                                              textAlign: TextAlign.center,
                                                                              style: const TextStyle(fontSize: 14),
                                                                            );
                                                                                  }
                                                                                ),
                                                                          )),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            20.0),
                                                                        child:
                                                                            Container(
                                                                          decoration: BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(35),
                                                                              color: myTheme.secondaryHeaderColor),
                                                                          child: IconButton(
                                                                              onPressed: () {
                                                                                 _controller.Increment(index, context);
                                                                              },
                                                                              tooltip: "زيادة المنتج",
                                                                              icon: Icon(Icons.add, size: 25, color: myTheme.primaryColor)),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                         GetBuilder<ShoppingCardController>(
                                                           builder: (_controller){
                                                              return Text(
                                                                ' د.ع ' +
                                                                    ListItemCard
                                                                        .itemscard[index]
                                                                        .total
                                                                        .toString(),
                                                                textAlign:
                                                                    TextAlign.right,
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              );
                                                            }
                                                          )
                                                        ],
                                                      ),
                                                    ))
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: myTheme
                                                    .secondaryHeaderColor),
                                            child: Text(
                                              ListItemCard
                                                      .itemscard[index].count
                                                      .toString() +
                                                  " الكمية ",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  trailing: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(15)),
                                    child: CachedNetworkImage(
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            ),
                                        imageUrl: ListItemCard
                                            .itemscard[index].productsImage),
                                  ),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(35),
                                        color: myTheme.secondaryHeaderColor),
                                    child: IconButton(
                                        onPressed: () {
                                          AwesomeDialog(
                                                  buttonsBorderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(5)),
                                                  context: context,
                                                  dialogType:
                                                      DialogType.warning,
                                                  headerAnimationLoop: true,
                                                  animType:
                                                      AnimType.bottomSlide,
                                                  title: 'حذف المنتج',
                                                  reverseBtnOrder: true,
                                                  showCloseIcon: true,
                                                  btnOkText: 'نعم',
                                                  btnCancelText: 'الغاء',
                                                  btnOkIcon: Icons.check_circle,
                                                  btnCancelIcon: Icons.cancel,
                                                  btnOkOnPress: () {
                                                    ListItemCard.itemscard
                                                        .removeAt(index);
                                                    controller.SumPrice();
                                                    controller.update();
                                                  },
                                                  btnCancelOnPress: () {},
                                                  desc:
                                                      'هل تريد حذف المنتج حقا؟')
                                              .show();
                                        },
                                        tooltip: "حذف المنتج",
                                        icon: Icon(Icons.clear,
                                            size: 25,
                                            color: myTheme.primaryColor)),
                                  ),
                                ));
                          },
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            ListTile(
                              trailing: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      color: myTheme.secondaryHeaderColor),
                                  child: Icon(Icons.currency_exchange,
                                      size: 30, color: myTheme.primaryColor)),
                              title: Text(
                                'المبلغ الكلي',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              leading: Text(
                                ' د.ع ' + _controller.totalprice.toString(),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            ElevatedButton.icon(
                                onPressed: () => {
                                      Get.to(
                                        () => const SendOrder(),
                                        arguments: "",
                                        duration:
                                            const Duration(milliseconds: 500),
                                        transition: Transition.fade,
                                      )
                                    },
                                icon: const Icon(Icons.shopping_cart_checkout),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: myTheme.primaryColor),
                                label: const Text(
                                  'اتمام الطلب',
                                  style: TextStyle(fontSize: 18),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    return AppBar(
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: myTheme.secondaryHeaderColor),
            child: IconButton(
                onPressed: () {
                  AwesomeDialog(
                          buttonsBorderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          context: context,
                          dialogType: DialogType.warning,
                          headerAnimationLoop: true,
                          animType: AnimType.bottomSlide,
                          title: 'حذف السلة',
                          reverseBtnOrder: true,
                          showCloseIcon: true,
                          btnOkText: 'نعم',
                          btnCancelText: 'الغاء',
                          btnOkIcon: Icons.check_circle,
                          btnCancelIcon: Icons.cancel,
                          btnOkOnPress: () {
                            _controller.ClearCard();
                          },
                          btnCancelOnPress: () {},
                          desc: 'هل تريد حذف السلة حقا؟')
                      .show();
                },
                tooltip: "حذف السلة",
                icon: Icon(Icons.remove_shopping_cart,
                    size: 30, color: Theme.of(context).primaryColor)),
          ),
        ],
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        title: Text(
          "سلة الطلب",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
