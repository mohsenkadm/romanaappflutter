import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:get_time_ago/get_time_ago.dart';
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/MyTabController.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/AllRestaourent.dart'; 
import 'package:romanaappflutter/views/orderdeitals.dart';
import 'package:shimmer/shimmer.dart';

// ignore: camel_case_types
class my_order extends StatefulWidget {
  const my_order({Key? key}) : super(key: key);

  @override
  State<my_order> createState() => _myorder();
}

// ignore: camel_case_types
class _myorder extends State<my_order> {
  final MyTabController _tabx = Get.put(MyTabController());
  final MyOrderController _controller = Get.find<MyOrderController>();
  final ProfileuserController _profileuserController =
      Get.find<ProfileuserController>();

   TextEditingController textEditingController=TextEditingController();
   TextEditingController textEditingController2=TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    textEditingController2.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Obx(() => _profileuserController.user.value == null
            ? Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'اطلب الان ليتم عرض الطلبات السابقة',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                        onPressed: () => {
                              Get.to(
                                () => const AllRestaourent(),
                                arguments: "",
                                duration: const Duration(milliseconds: 500),
                                transition: Transition.fade,
                              )
                            },
                        icon: const Icon(
                          Icons.shopping_basket,
                          color: Colors.white,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: myTheme.primaryColor),
                        label: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: Text(
                              'اطلب الان',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ))),
                  ],
                ),
              )
            : MyTabBarView()),
        appBar: appbar(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
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
            child: TextField(
                controller: textEditingController2,
                onChanged: (query) {
                  _controller.fetchData(searchprod: query); 
                },
                decoration: InputDecoration(
                  hintText: 'بحث عن رقم الطلب  ',
                 hintStyle: TextStyle(color: myTheme.primaryColor),
              prefixIcon:  Icon(Icons.search,color: myTheme.primaryColor),
              suffixIcon: IconButton(
                onPressed:() {
                  textEditingController2.clear();
                 _controller.fetchData();  
              }
              ,icon:  Icon(Icons.close,color: myTheme.primaryColor)),
                  contentPadding: const EdgeInsets.all(15),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                )),
          ),
          Expanded(
            child: Obx(
              () => _controller.isloded.value
                  ? const GetShimmer()
                  : _controller.itemsdone.isEmpty
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
                      : ListView.builder(
                          itemCount: _controller.itemsdone.length,
                          itemBuilder: (context, index) {
                            var _convertedTimestamp = GetTimeAgo.parse(
                                _controller.itemsdone[index].orderDate,
                                locale: 'ar');
                            return FillOrderaData(
                                items: _controller.itemsdone[index],
                                convertedTimestamp: _convertedTimestamp);
                          },
                        ),
            ),
          ),
        ],
      ),
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
                  _controller.fetchData(searchprod: query); 
                },
                controller:textEditingController ,
                decoration: InputDecoration(
              hintText: 'ابحث عن رقم الطلب', 
               hintStyle: TextStyle(color: myTheme.primaryColor),
              prefixIcon:  Icon(Icons.search,color: myTheme.primaryColor),
              suffixIcon: IconButton(
                onPressed:() {
                  textEditingController.clear();
                     _controller.fetchData(); 
              }
              ,icon:  Icon(Icons.close,color: myTheme.primaryColor)),
              contentPadding: const EdgeInsets.all(15),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            )),
          ),
          SizedBox(
            child: Obx(
              () => _controller.isloded.value
                  ? const GetShimmer()
                  : _controller.itemscancel.isEmpty
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
                      : ListView.builder(
                          itemCount: _controller.itemscancel.length,
                          itemBuilder: (context, index) {
                            var _convertedTimestamp = GetTimeAgo.parse(
                                _controller.itemscancel[index].orderDate,
                                locale: 'ar');
                            return FillOrderaData(
                                items: _controller.itemscancel[index],
                                convertedTimestamp: _convertedTimestamp);
                          },
                        ),
            ),
          ),
        ],
      ),
      Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _controller.fetchData(),
              color: myTheme.primaryColor,
              child: Obx(
                () => _controller.isloded.value
                    ? const GetShimmer()
                    : _controller.itemscurrent.isEmpty
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
                        : ListView.builder(
                            itemCount: _controller.itemscurrent.length,
                            itemBuilder: (context, index) {
                              var _convertedTimestamp = GetTimeAgo.parse(
                                  _controller.itemscurrent[index].orderDate,
                                  locale: 'ar');
                              return FillOrderaData(
                                  items: _controller.itemscurrent[index],
                                  convertedTimestamp: _convertedTimestamp);
                            },
                          ),
              ),
            ),
          ),
        ],
      ),
    ]);
  }

  AppBar appbar() {
    return AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 75.0,
        title: TabBar(
          controller: _tabx.controller,
          indicatorColor: Theme.of(context).primaryColor,
          labelColor: Theme.of(context).primaryColor,
          tabs: const [
            Tab(
              icon: Icon(Icons.schedule, size: 25),
              iconMargin: EdgeInsets.all(7),
              child: Center(child: Text("السابقة")),
            ),
            Tab(
                icon: Icon(
                  Icons.cancel_sharp,
                  size: 25,
                ),
                iconMargin: EdgeInsets.all(7),
                child: Center(child: Text("الملغية"))),
            Tab(
              icon: Icon(Icons.list_alt, size: 25),
              iconMargin: EdgeInsets.all(7),
              child: Center(child: Text("الحالية")),
            ),
          ],
        ));
  }
}

class FillOrderaData extends StatelessWidget {
   FillOrderaData({
    Key? key,
    required this.items,
    required String convertedTimestamp,
  })  : _convertedTimestamp = convertedTimestamp,
        super(key: key);

    RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  final OrdersModel items;
  final String _convertedTimestamp;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).secondaryHeaderColor),
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Get.to(
                () => const orderdeitals(),
                arguments: [items.orderId.toString()],
                duration: const Duration(milliseconds: 500),
                transition: Transition.fade,
              );
            },
            child: ListTile(
              trailing: items.logo != null && items.logo != ""
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(35)),
                      child: CachedNetworkImage(
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageUrl: items.logo ?? ""),
                    )
                  : null,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    items.restaurantName.toString(),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        fontSize: 18, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "رقم الطلب : " + items.orderNo.toString(),
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    _convertedTimestamp,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(" د.ع ${items.netAmount.toString().replaceAll(regex, '')}",
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(height: 3),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: items.isCancel == true
                            ? Colors.red
                            : (items.isCancel == false &&
                                    items.isApporve == false &&
                                    items.isDone == false)
                                ? const Color.fromARGB(255, 192, 192, 2)
                                : items.isDone == true
                                    ? Colors.greenAccent
                                    : Colors.green),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(
                        items.isCancel == true
                            ? 'مرفوض'
                            : (items.isCancel == false &&
                                    items.isApporve == false &&
                                    items.isDone == false)
                                ? 'انتظار'
                                : items.isDone == true
                                    ? 'منتهي'
                                    : 'مقبول',
                        style: const TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 3),
                ],
              ),
              leading: (items.isCancel == false &&
                          items.isApporve == false &&
                          items.isDone == false) ||
                      items.isCancel == true ||
                      (items.isApporve == true && items.isDone == false)
                  ? null
                  : Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context).secondaryHeaderColor),
                      child: Icon(Icons.published_with_changes,
                          color: Theme.of(context).primaryColor),
                    ),
            ),
          )
        ],
      ),
    );
  }
}

class GetShimmer extends StatelessWidget {
  const GetShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).secondaryHeaderColor),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    padding: const EdgeInsets.all(0),
                  ),
                ],
              ));
        });
  }
}
