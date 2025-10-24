import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:romanaappflutter/main.dart';
import 'package:shimmer/shimmer.dart';

import '../Controller/OrderDetailsController.dart';

// ignore: camel_case_types
class orderdeitals extends StatefulWidget {
  const orderdeitals({Key? key}) : super(key: key);
  @override
  State<orderdeitals> createState() => _Orderdeitals();
}
 
class _Orderdeitals extends State<orderdeitals> {
  final OrderDetailsController _controller = Get.put(OrderDetailsController());
  @override
  Widget build(BuildContext context) {
    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyAppBar(),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () => _controller.fetchData(),
          child: GetBuilder<OrderDetailsController>(
            init: OrderDetailsController(),
            builder: (controller) => 
            controller.isloded.value?
            SizedBox(
              child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                                width: 100,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10)));
                      }),
            ):
            controller.itemscurrent.isEmpty
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
                            'لا توجد منتجات  ',
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
                          itemCount: controller.itemscurrent.length,
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
                                     controller.itemscurrent[index].productsName,
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
                                           ' د.ع ${(controller.itemscurrent[index]
                                                           .price??0 *
                                                       controller.itemscurrent[index]
                                                           .count??0).toString().replaceAll(regex, '')}',
                                           textAlign: TextAlign.right,
                                           style: TextStyle(
                                               color: Theme.of(context)
                                                   .primaryColor,
                                               fontSize: 14),
                                         ),
                                         Container(
                                           padding: const EdgeInsets.all(4),
                                           decoration: BoxDecoration(
                                               borderRadius:
                                                   BorderRadius.circular(5),
                                               color: myTheme
                                                   .secondaryHeaderColor),
                                           child: Text(
                                             "${controller.itemscurrent[index].count} الكمية ",
                                             textAlign: TextAlign.right,
                                             style: TextStyle(
                                                 color: Theme.of(context)
                                                     .primaryColor,
                                                 fontSize: 14),
                                           ),
                                         )
                                       ],
                                     ),
                                   ),
                                   trailing: ClipRRect( 
                                     borderRadius: const BorderRadius.all(
                                         Radius.circular(15)),
                                     child: SizedBox(width: 90,height: 100,
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
                                           imageUrl: controller.itemscurrent[index].productsImage),
                                     ),
                                   ),
                                  ));
                          },
                        ),
                      ),
                      Container(
                        height: 200,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            ListTile(
                                        trailing: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: myTheme
                                                    .secondaryHeaderColor),
                                            child: Icon(Icons.attach_money,
                                                size: 30,
                                                color: myTheme.primaryColor)),
                                        title: Text(
                                          'مجموع الطلب',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        leading: Text(
                                          ' د.ع ${_controller.totalprice.toString().replaceAll(regex, '')}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                        ListTile(
                                        trailing: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: myTheme
                                                    .secondaryHeaderColor),
                                            child: Icon(Icons.attach_money,
                                                size: 30,
                                                color: myTheme.primaryColor)),
                                        title: Text(
                                          'مبلغ الخصم',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        leading: Text(
                                          ' د.ع ${_controller.discountprice.toString().replaceAll(regex, '')}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    
                                      ListTile(
                                        trailing: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                color: myTheme
                                                    .secondaryHeaderColor),
                                            child: Icon(Icons.currency_exchange,
                                                size: 30,
                                                color: myTheme.primaryColor)),
                                        title: Text(
                                          'المبلغ الكلي',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                        leading: Text(
                                          ' د.ع ${_controller.netAmount.toString().replaceAll(regex, '')}',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                  
                            ],
                        ),
                      )
                    ],
                  ),
          ),
        ),
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    return AppBar(
        
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "تفاصيل الطلب",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
