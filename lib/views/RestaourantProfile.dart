import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Constant/FillProduct.dart';
import 'package:romanaappflutter/Controller/RestaourantProfileController.dart'; 
import 'package:romanaappflutter/main.dart'; 
import 'package:romanaappflutter/views/StarsView.dart';
import 'package:romanaappflutter/views/shoppingcart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaourantProfile extends StatefulWidget {
  const RestaourantProfile({Key? key}) : super(key: key);

  @override
  _RestaourantProfileState createState() => _RestaourantProfileState();
}

class _RestaourantProfileState extends State<RestaourantProfile> {
  final RestaourantProfileController restourentController =
      Get.put(RestaourantProfileController());

   TextEditingController textEditingController=TextEditingController();
  @override
  Widget build(BuildContext context) {

    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
    return MaterialApp(
        theme: myTheme,
        
        debugShowCheckedModeBanner: false,
        home: Scaffold( 
          
          floatingActionButton: ElevatedButton.icon(
                          onPressed: () {    Get.to(const shoppingcard(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
                                      },
                          icon: const Icon(
                            Icons.shopping_cart_checkout,
                            color: Colors.white,
                            size: 16,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: myTheme.primaryColor),
                          label:  const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              'عرض السلة',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          )),
            appBar: MyAppBar(),
            body:  RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () => restourentController.fetchData(),
              child: SingleChildScrollView( 
                    physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [ 
                  Obx(
                    () => restourentController.isloded.value
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
                                      color: Colors.white),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10)),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15)
                                        // ignore: deprecated_member_use
                                        ,
                                        color: Colors.white),
                                    height: 20,
                                    width: 100,
                                  ))
                            ]))
                        : Column(
                            children: [
                              CachedNetworkImage(
                                  height: 200,
                                  width: double.maxFinite,
                                  fit: BoxFit.fill,
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  imageUrl:
                                      restourentController.item.value.background ??
                                          ''),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        restourentController.item.value.name ?? '',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Theme.of(context).primaryColor),
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
                                          imageUrl: restourentController
                                                  .item.value.logo ??
                                              '',
                                          width: 80,
                                          height: 80,
                                        )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    restourentController.item.value.details
                                        .toString(),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                        fontSize: 16, color: myTheme.primaryColor),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20,left: 20),
                                child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                       ElevatedButton.icon(
                          onPressed: () {    restourentController.item.value.isStars!?
                                    Get.to(
                                      () => const StarsView(),
                                      arguments: [restourentController.item.value.restaurantId.toString()],
                                      duration: const Duration(milliseconds: 500),
                                      transition: Transition.fade,
                                    ):
                                    ErrorMessage.SnackMessage("لا يمكن التقييم", Colors.green[400]!); 
                          },
                          icon: const Icon(
                            Icons.star_sharp,
                            color: Colors.white,
                            size: 16,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: myTheme.primaryColor),
                          label: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              'قيم',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          )),
                   
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Icon(
                                          Icons.star_sharp,
                                          size: 18,
                                          color: myTheme.primaryColor,
                                        ),
                                        Icon(
                                          Icons.star_sharp,
                                          size: 18,
                                          color: myTheme.primaryColor,
                                        ),
                                        Icon(
                                          Icons.star_sharp,
                                          size: 18,
                                          color: myTheme.primaryColor,
                                        ),
                                        Icon(
                                          Icons.star_sharp,
                                          size: 18,
                                          color: myTheme.primaryColor,
                                        ),
                                        Icon(
                                          Icons.star_sharp,
                                          size: 18,
                                          color: myTheme.primaryColor,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.fromLTRB(5, 5, 3, 0),
                                          child: Text(
                                            restourentController.item.value.starCount ==
                                                    null
                                                ? "0"
                                                : restourentController
                                                    .item.value.starCount
                                                    .toString(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 26,
                                                color: myTheme.primaryColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                                 Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, right: 20, left: 20),
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        height: 40,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.purple,
                                              Colors.pink,
                                              Colors.orange
                                            ],
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              // ignore: deprecated_member_use
                                              if (await canLaunch(
                                                  restourentController
                                                      .item.value.insta!)) {
                                                // ignore: deprecated_member_use
                                                await launch(
                                                    restourentController
                                                        .item.value.insta!);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.transparent,
                                              shadowColor: Colors.transparent,
                                            ),
                                            child: const Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 5, 0, 0),
                                              child: Text(
                                                'الانستغرام',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                    color: Colors.white),
                                              ),
                                            )),
                                      ),
                                    ),
                                  ),
                              
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                       Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            " كلفة التوصيل ${restourentController
                                                    .item.value.costDelivery} د.ع ",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: myTheme.primaryColor),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.delivery_dining,
                                            size: 18,
                                            color: myTheme.primaryColor,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "الحد الادنى للطلب  ${restourentController
                                                    .item.value.minimumPrice} د.ع ",
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: myTheme.primaryColor),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.currency_exchange,
                                            size: 18,
                                            color: myTheme.primaryColor,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${restourentController.item.value.address},${restourentController
                                                    .item.value.areaname}',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: myTheme.primaryColor),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Icon(
                                            Icons.location_on,
                                            size: 18,
                                            color: myTheme.primaryColor,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              restourentController.item.value.phone
                                                  .toString(),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: myTheme.primaryColor),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              Icons.phone,
                                              size: 18,
                                              color: myTheme.primaryColor,
                                            ),
                                          ])
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                    child:  TextField(
                    controller: textEditingController,
                       onChanged: (query) {
                        restourentController.fetchDataProductByRestaurantId(SubId:0,searchprod: query); 
                      },
                        decoration:  InputDecoration(
                      hintTextDirection: TextDirection.rtl,
                      hintText: 'ابحث عن المنتجات',
                       hintStyle: TextStyle(color: myTheme.primaryColor),
              prefixIcon:  Icon(Icons.search,color: myTheme.primaryColor),
              suffixIcon: IconButton(
                onPressed:() { 
                  textEditingController.clear();
                        restourentController.fetchDataProductByRestaurantId(SubId:0); 
              }
              ,icon:  Icon(Icons.close,color: myTheme.primaryColor)),
                      contentPadding: const EdgeInsets.all(15),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    )),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SubcategoryFill(context),
                 productfill()
                ]),
              ),
            )));
  }

  SizedBox productfill() {
    return SizedBox( 
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: SizedBox(
            width: double.infinity,
            child: Obx(() => restourentController.islodedprod.value
                ? ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: 20,
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
                    })
                : ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    itemCount: restourentController.itemprod.length,
                    itemBuilder: (context, index) {
                      return FillProduct(
                          items: restourentController.itemprod[index]);
                    },
                  ))),
      ),
    );
  }

  SizedBox SubcategoryFill(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: 50,
        child: Obx(() => restourentController.islodedsub.value
            ? ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
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
                })
            : ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: restourentController.itemSubCategory.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Obx(
                      () => OutlinedButton(
                        child: Text(restourentController
                            .itemSubCategory[index].SubCategoriesName),
                        onPressed: () => {
                          restourentController.ChooseSubCategory(
                              restourentController
                                  .itemSubCategory[index].SubCategoriesId)
                        },
                        style: restourentController.SubIdActive.value ==
                                restourentController
                                    .itemSubCategory[index].SubCategoriesId
                            ? OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: myTheme.primaryColor,
                                side: BorderSide(
                                    width: 1, color: myTheme.primaryColor),
                              )
                            : OutlinedButton.styleFrom(
                                foregroundColor: myTheme.primaryColor,
                                side: BorderSide(
                                    width: 1, color: myTheme.primaryColor),
                              ),
                      ),
                    ),
                  );
                },
              )));
  }

  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: myTheme.secondaryHeaderColor),
          child: IconButton(
              onPressed: () {
                Get.to(const shoppingcard(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
              },
              icon: Icon(Icons.shopping_cart_outlined,
                  color: myTheme.primaryColor)),
        ),
      ],
      elevation: 2,
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            restourentController.OnClose();
          },
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor)),
    );
  }
}
