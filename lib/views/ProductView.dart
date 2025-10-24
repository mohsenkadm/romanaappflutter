import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/socket_notifier.dart';
import 'package:get/state_manager.dart';
import 'package:romanaappflutter/Constant/FillImageProductsCarousel.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/ProductController.dart';
import 'package:romanaappflutter/Controller/ShoppingCardController.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/shoppingcart.dart';
import 'package:shimmer/shimmer.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  void initState() {
    super.initState();
    _controller.noteController.clear();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _controller.fetchData());
  }

  final ProductController _controller = Get.put(ProductController());
  final ShoppingCardController _controllershop =
      Get.find<ShoppingCardController>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(),
        body: RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () => _controller.fetchData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(
             ()=>Column(
                children: [
                  CarouselSlide(),
                  _controller.isloded.value
                        ? Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Column(children: [
                              Container(
                                  width: double.infinity,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)
                                      // ignore: deprecated_member_use
                                      ,
                                      color: Theme.of(context).scaffoldBackgroundColor),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10)),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15)
                                        // ignore: deprecated_member_use
                                        ,
                                        color: Theme.of(context).scaffoldBackgroundColor),
                                    height: 20,
                                    width: 100,
                                  ))
                            ]))
                        : Column( 
                            children: [
                              
                                Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        _controller.item.value.RestaurantName ==
                                                null
                                            ? ""
                                            : _controller
                                                .item.value.RestaurantName!,
                                        style: TextStyle(
                                            fontSize: 24,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          imageUrl: _controller.item.value
                                                      .productsImageFirst ==
                                                  null
                                              ? ""
                                              : _controller
                                                  .item.value.productsImageFirst!,
                                          width: 80,
                                          height: 80,
                                        )),
                                  ],
                                ),
                              ),
                              
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  _controller.item.value.ProductsName == null
                                      ? ""
                                      : _controller.item.value.ProductsName!,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ],
                          ), 
                  Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: myTheme.secondaryHeaderColor),
                                child: IconButton(
                                    onPressed: () {
                                      if (_controller.count.value == 0) return;
                                      _controller.count.value -= 1;
                                      _controller.update();
                                    },
                                    tooltip: "نقصان المنتج",
                                    icon: Icon(Icons.remove,
                                        size: 25, color: myTheme.primaryColor)),
                              ),
                            ),
                            Container(
                                height: 50,
                                width: 70,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: myTheme.secondaryHeaderColor),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text(
                                    _controller.count == null
                                        ? "0"
                                        : _controller.count.value.toString(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: myTheme.secondaryHeaderColor),
                                child: IconButton(
                                    onPressed: () {
                                      _controller.count.value += 1;
                                    },
                                    tooltip: "زيادة المنتج",
                                    icon: Icon(Icons.add,
                                        size: 25, color: myTheme.primaryColor)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ), 
                  Column(
                        children: [
                          Text(
                            _controller.item.value.ProductsPrice == null
                                ? "0"
                                : "${_controller.item.value.ProductsPrice} د.ع ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            _controller.item.value.ProductsPrice == null
                                ? "0"
                                : "${_controller.item.value.ProductsPrice! * _controller.count.value} د.ع ",
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'ملاحظة',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            fontSize: 20, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .secondaryHeaderColor, // Set your desired background color here
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Add rounded corners
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    child: TextField(
                        controller: _controller.noteController,
                        decoration: const InputDecoration(
                          hintTextDirection: TextDirection.rtl,
                          hintText: 'ملاحظة',
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        )),
                  ),

                   Padding(
                                  padding: const EdgeInsets.only(top: 5,right: 20),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      textAlign: TextAlign.right,
                                      _controller.item.value.ProductsDetails == null
                                          ? ""
                                          : _controller.item.value.ProductsDetails!,
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context).primaryColor),
                                    ),
                                  ),
                                ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      onPressed: () =>
                          {_controller.AddToListCard(_controller.item.value)},
                      icon: const Icon(
                        Icons.shopping_cart_checkout,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: myTheme.primaryColor),
                      label: const Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          'اضافة الي السلة',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    
  }

Padding CarouselSlide() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Stack(
            children: [
              Obx(
                () => _controller.isloded.value
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15)
                                  // ignore: deprecated_member_use
                                  ,
                                  color: Theme.of(context).scaffoldBackgroundColor),
                              height: 200,
                              width: double.infinity,
                            )),
                      )
                    : _controller.itemsCarousel.isEmpty
                        ? Center(
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error,
                                    size: 60,
                                    color: Colors.red[400],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'لا توجد بيانات',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          )
                        : CarouselSlider.builder(
                            itemCount: _controller.itemsCarousel.length,
                            itemBuilder: (context, index, realIndex) {
                              return FillImageProductsCarousel(
                                  item: _controller.itemsCarousel[index]);
                            },
                            
                            options: CarouselOptions(
                                scrollPhysics: const BouncingScrollPhysics(),
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 2,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  _controller.onPageChanged(index);
                                }),
                          ),
              ),
              Obx(
                () => Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _controller.itemsCarousel
                          .asMap()
                          .entries
                          .map((entry) {
                        return GestureDetector(
                          //onTap: () => controller.animateToPage(entry.key),
                          child: Container(
                            width:
                                _controller.currentIndex.value == entry.key
                                    ? 17
                                    : 7,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _controller.currentIndex.value ==
                                        entry.key
                                    ? Colors.red
                                    : Colors.teal),
                          ),
                        );
                      }).toList(),
                    )),
              )
            ],
          )
        ],
      ));
}
  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      centerTitle: true,
      title: Text(
        "تفاصيل المنتج",
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: myTheme.secondaryHeaderColor),
          child: IconButton(
              onPressed: () {
                _controllershop.SumPrice();
                Get.to(const shoppingcard(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
              },
              icon: Icon(Icons.shopping_cart_outlined,
                  color: myTheme.primaryColor)),
        ),
      ],
      leading: IconButton(
          onPressed: () {
            _controller.backToRestourantprofile();
          },
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor)),
    );
  }
}
