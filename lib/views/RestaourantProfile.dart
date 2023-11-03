import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/RestaourantProfileController.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/Model/SubCategoriesModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/ProductView.dart';
import 'package:romanaappflutter/views/shoppingcart.dart';
import 'package:shimmer/shimmer.dart';

class RestaourantProfile extends StatefulWidget {
  const RestaourantProfile({Key? key}) : super(key: key);

  @override
  _RestaourantProfileState createState() => _RestaourantProfileState();
}

class _RestaourantProfileState extends State<RestaourantProfile> {
  @override
  final RestaourantProfileController restourentController =
      Get.put(RestaourantProfileController());
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: MyAppBar(),
          body:  Column(children: [
               Obx(() => 
               restourentController.isloded.value?
               Shimmer.fromColors(
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
                            color: Theme.of(context).backgroundColor),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10)),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)
                              // ignore: deprecated_member_use
                              ,
                              color: Theme.of(context).backgroundColor),
                          height: 20,
                          width: 100,
                        ))
                  ])
                  )
                 :   
                  Column(
                    children: [
                      CachedNetworkImage(
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        imageUrl: 'https://source.unsplash.com/user/c_v_r/500x200'),
                     Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          "اسم المطعم",
                          style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageUrl:
                                'https://source.unsplash.com/user/c_v_r/100x100',
                            width: 80,
                            height: 80,
                          )),
                    ],
                  ),
                ),
                    Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "الحد الادنى للطلب  " + '500' + " د.ع ",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 10),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'address',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 10),
                              ),
                              const Icon(
                                Icons.location_on,
                                size: 15,
                              ),
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text('name', textAlign: TextAlign.right),
                          Text('minm', textAlign: TextAlign.right)
                        ],
                      ),
                    ],
                  ),
                ), ],
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
                  child: const TextField(
                      decoration: InputDecoration(
                    hintTextDirection: TextDirection.rtl,
                    hintText: 'ابحث عن الاكلات',
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: Icon(Icons.close),
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  )),
                ),
                const SizedBox(height: 15,),
                SubcategoryFill(context),
               productfill()
              ])
    ));
  }

  Expanded productfill() {
    return Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(5.0),
                 child: SizedBox(
                    width: double.infinity, 
                                         child: FutureBuilder<List<ProductsModel>>(
                        future: restourentController
                            .fetchDataProduct(), //NOT Recommended
                        builder: (c, s) {
                          if (s.data!=null) {
                             final data =s.data;
                              return   ListView.builder(
                          itemCount: data!.length,
                          itemBuilder: (context, index) {
                            final item=data[index];
                            return InkWell(
                              onTap: () =>  Get.to(const ProductView(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      isThreeLine: false,
                                      title: Text(
                                        item.ProductsName,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                   subtitle: Padding(
                                     padding: const EdgeInsets.symmetric(vertical: 7),
                                     child: Text(
                                          item.ProductsDetails!,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Theme.of(context).primaryColor,
                                              fontSize: 14, ),
                                        ),
                                   ),
                                    
                                    leading: Column(
                                      children: [
                                        Text(
                                          item.ProductsPrice
                                                  .toString() +
                                              " د.ع ", 
                                              textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16),
                                        ),
                                       ],
                                    ),
                                      trailing: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        child: CachedNetworkImage(
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child: CircularProgressIndicator()),
                                            errorWidget: (context, url, error) =>
                                                const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                            imageUrl:item.ProductsImage! ,),
                                      ),
                                     ),
                                      const Divider(
                                        color: Colors.black
                                      ) ,const SizedBox(height: 10,)
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                     
                          }
                          if (s.hasError) print(s.error.toString());
                          return ListView.builder(
                              shrinkWrap: true, 
                              physics:const ScrollPhysics(),
                              itemCount: 20,
                              itemBuilder: (context, index) {
                                return Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                        width: 100,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Theme.of(context)
                                                .backgroundColor),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10)));
                              });
                        },
                                         )),
               ),
             );
  }

  SizedBox SubcategoryFill(BuildContext context) {
    return SizedBox(
                  width: double.infinity,
                  height: 35,
                  child: FutureBuilder<List<SubCategoriesModel>>(
                    future: restourentController
                        .fetchDataSubCategory(), //NOT Recommended
                    builder: (c, s) {
                      if (s.hasData) {
                        List<Tab> tabs = [];
                        for (int i = 0; i < s.data!.length; i++) {
                          tabs.add(Tab(
                            child: Text(
                              s.data![i].SubCategoriesName,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ));
                        }
                        return DefaultTabController(
                          length: s.data!.length, 
                          child: TabBar(
                            indicatorPadding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            indicatorColor: Theme.of(context).primaryColor,
                            labelColor: Theme.of(context).primaryColor,
                            isScrollable: true,
                            tabs: tabs,
                          ),
                        );
                      }
                      if (s.hasError) print(s.error.toString());
                      return ListView.builder(
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
                                        borderRadius:
                                            BorderRadius.circular(15),
                                        color: Theme.of(context)
                                            .backgroundColor),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10)));
                          });
                    },
                  ));
  }

  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
      actions: [
         Container(
         margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color: myTheme.secondaryHeaderColor),
          child: IconButton(onPressed: (){ 
                Get.to(const shoppingcard(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
          }, 
          icon: Icon(Icons.shopping_cart_outlined,color: myTheme.primaryColor)
          ),
        ),
      ],
      elevation: 2,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor)),
    );
  }
}
