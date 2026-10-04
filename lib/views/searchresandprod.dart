import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:romanaappflutter/Constant/FillProduct.dart'; 
import 'package:romanaappflutter/Constant/RestourentFill.dart';
import 'package:romanaappflutter/Controller/SearchController.dart';
import 'package:romanaappflutter/Controller/SearchTabController.dart';  
import 'package:romanaappflutter/main.dart';
import 'package:shimmer/shimmer.dart';

class SearchResAndProd extends StatefulWidget {
  const SearchResAndProd({Key? key}) : super(key: key);

  @override
  State<SearchResAndProd> createState() => _SearchResAndProd();
}

class _SearchResAndProd extends State<SearchResAndProd>
    with SingleTickerProviderStateMixin {
  final SearchTabController _tabx = Get.put(SearchTabController());
   TextEditingController textEditingController=TextEditingController();
   TextEditingController textEditingController2=TextEditingController();
  final Search_Controller searchController = Get.put(Search_Controller());
    

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingController2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: MyTabBarView(),
        backgroundColor: Colors.white,
      );
  }

  // ignore: non_constant_identifier_names
  TabBarView MyTabBarView() {
    return TabBarView(controller: _tabx.controller, children: [
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .secondaryHeaderColor, // Set your desired background color here
              borderRadius:
                  BorderRadius.circular(8.0), // Optional: Add rounded corners
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: double.infinity,
            child:  TextField(
              onChanged: (query) {
                      searchController.fetchDataGetAll(searchprod: query); 
                    },
                    controller: textEditingController,
                decoration:  InputDecoration(
              hintText: 'بحث عن اقرب متجر اليك',
              hintStyle: TextStyle(color: myTheme.primaryColor),
              prefixIcon:  Icon(Icons.search,color: myTheme.primaryColor),
              suffixIcon: IconButton(
                onPressed:() {
                  textEditingController.clear();
                     searchController.fetchDataGetAll(); 
              }
              ,icon:  Icon(Icons.close,color: myTheme.primaryColor)),
              contentPadding: const EdgeInsets.all(15),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            )),
          ),
          const SizedBox(
            height: 10,
          ),
          ResSlide()
        ],
      ),
      Container(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .secondaryHeaderColor, // Set your desired background color here
              borderRadius:
                  BorderRadius.circular(8.0), // Optional: Add rounded corners
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            width: double.infinity,
            child:  TextField( 
              onChanged: (query) {
                    searchController.fetchDataProduct(searchprod: query); 
                  },
                  controller: textEditingController2,
                decoration: InputDecoration(
              hintText: 'ابحث عن المنتجات',
              hintStyle: TextStyle(color: myTheme.primaryColor),
              prefixIcon:  Icon(Icons.search ,color: myTheme.primaryColor),
              suffixIcon: IconButton(
                 onPressed:() {
                textEditingController2.clear(); 
                    searchController.fetchDataProduct(); 
                }
            ,icon:  Icon(Icons.close ,color: myTheme.primaryColor,)),
              contentPadding: const EdgeInsets.all(15),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            )),
          ),
          const SizedBox(
            height: 10,
          ),
          productfill()
        ]),
      ),
    ]);
  }

  Expanded ResSlide() {
    return Expanded(
      child: Obx(
        () => searchController.islodedGetAll.value
            ? const GetShimmerResAll()
            : ListView.builder(
                shrinkWrap: true,
                itemCount: searchController.itemsresAll.length,
                itemBuilder: (context, index) {
                  return FillResData(
                      items: searchController.itemsresAll[index]);
                },
              ),
      ),
    );
  }

  Expanded productfill() {
    return Expanded( 
        child: Obx(
          () => searchController.isloded.value
            ? shimmerprodall()
            :  GroupedListView<dynamic, String>(
                shrinkWrap: true,
                useStickyGroupSeparators: true, 
                  elements:searchController.itemprod,
                  groupBy: (element) => element.RestaurantName, 
                  order: GroupedListOrder.ASC, 
                  groupSeparatorBuilder: (String value) => Container(
                  decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Theme.of(context).secondaryHeaderColor),   child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value,
                        textAlign: TextAlign.center,
                        style:  TextStyle(color: myTheme.primaryColor,
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  itemBuilder: (c, element) {
                    return FillProduct(items: element); 
                  },
                )         
        ));
  }

  SizedBox shimmerprodall() {
    return SizedBox(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
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
                  }),
            );
  }
 
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
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabx.controller,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(
              icon: Icon(Icons.shop_two, size: 25),
              iconMargin: EdgeInsets.all(2),
              child: Text("متاجر"),
            ),
            Tab(
                icon: Icon(
                  Icons.shop,
                  size: 25,
                ),
                iconMargin: EdgeInsets.all(2),
                child: Text("المنتجات"))
          ],
        ),
        title: Text(
          "بحث",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
