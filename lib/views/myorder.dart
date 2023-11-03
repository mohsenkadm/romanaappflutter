 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_time_ago/get_time_ago.dart'; 
import 'package:romanaappflutter/Controller/MyOrderController.dart';
import 'package:romanaappflutter/Controller/MyTabController.dart';
import 'package:romanaappflutter/Model/OrdersModel.dart';
import 'package:romanaappflutter/main.dart';
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
   final MyOrderController _controller=Get.put(MyOrderController());
   @override
  Widget build(BuildContext context) {
    return MaterialApp( 
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(    
        body: MyTabBarView(),
          appBar:appbar(), 
        backgroundColor:Theme.of(context).backgroundColor,
      ),
    );
}


   // ignore: non_constant_identifier_names
   TabBarView MyTabBarView() {
     return TabBarView(
      controller: _tabx.controller
        , children: [
        Column( 
          children: [ 
            Container( 
               decoration: BoxDecoration(
                  color:Theme.of(context).secondaryHeaderColor, // Set your desired background color here
                  borderRadius: BorderRadius.circular(8.0), // Optional: Add rounded corners
                ),
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              width: double.infinity,
              child: const TextField( 
              decoration: InputDecoration(
                  hintText: 'بحث عن رقم الطلب  ',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.close),
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder( 
                    borderSide: BorderSide.none,  
                  ),
              )
          ),
            ) ,
             Expanded(
               child: Obx(
                  () => _controller.isloded.value?
                  const GetShimmer():
                   _controller.items.isEmpty?
          Center( 
                   child: Container( 
                    width: 150,
                    padding:const EdgeInsets.all(10),
                     child: Column(children: [
                      Icon(Icons.error,size: 60,color: Colors.red[400],),
                   const SizedBox(height: 20,),
                   const Text('لا توجد بيانات',style:  TextStyle(fontSize: 18),)
                     ],
                     ),
                   ),
                 ):ListView.builder(
                         itemCount: _controller.items.length,
                         itemBuilder: (context, index) { 
                return FillOrderaData(items: _controller.items[index]); 
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
                  color: Theme.of(context).secondaryHeaderColor, // Set your desired background color here
                  borderRadius: BorderRadius.circular(8.0), // Optional: Add rounded corners
                ),
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              width: double.infinity,
              child: const TextField( 
              decoration: InputDecoration(
                  hintText: 'ابحث عن رقم الطلب',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.close),
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder( 
                    borderSide: BorderSide.none,  
                  ),
              )
          ),
            )
           , Expanded(
             child: Obx(
                  () => _controller.isloded.value?
                  const GetShimmer():
                   _controller.items.isEmpty?
          Center( 
                   child: Container( 
                    width: 150,
                    padding:const EdgeInsets.all(10),
                     child: Column(children: [
                      Icon(Icons.error,size: 60,color: Colors.red[400],),
                   const SizedBox(height: 20,),
                   const Text('لا توجد بيانات',style:  TextStyle(fontSize: 18),)
                     ],
                     ),
                   ),
                 ):ListView.builder(
              itemCount: _controller.items.length,
              itemBuilder: (context, index) { 
                return FillOrderaData(items: _controller.items[index]); 
              },
                      ),
                    ),
           ),
          ],
        ),
          Column( 
          children: [ 
            Expanded(
              child: Obx(
                  () => _controller.isloded.value?
                  const GetShimmer():
                   _controller.items.isEmpty?
          Center( 
                   child: Container( 
                    width: 150,
                    padding:const EdgeInsets.all(10),
                     child: Column(children: [
                      Icon(Icons.error,size: 60,color: Colors.red[400],),
                   const SizedBox(height: 20,),
                   const Text('لا توجد بيانات',style:  TextStyle(fontSize: 18),)
                     ],
                     ),
                   ),
                 ):ListView.builder(
              itemCount: _controller.items.length,
              itemBuilder: (context, index) { 
                return FillOrderaData(items: _controller.items[index]); 
              },
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
        labelColor: Theme.of(context).primaryColor
        ,tabs: const [
       Tab(child: Text("الطلبات السابقة"),icon: Icon(Icons.schedule,size:25),iconMargin: EdgeInsets.all(2),),
      Tab(child: Text("الطلبات الملغية"),icon: Icon(Icons.cancel_sharp,size: 25,),iconMargin: EdgeInsets.all(2)),
       Tab(child: Text("الطلبات الحالية"),icon: Icon(Icons.list_alt,size:25),iconMargin: EdgeInsets.all(2),),
       ],
      ));
   }  
}


class FillOrderaData extends StatelessWidget {
  const FillOrderaData({Key? key,  
    required this.items
  }) : super(key: key);

  final OrdersModel items; 

  @override
  Widget build(BuildContext context) {
    return 
    Container(
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
            ,color: Theme.of(context).secondaryHeaderColor),
      margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      padding: const EdgeInsets.all(0), 
      child: Column(children: [ 
        ListTile(trailing: ClipRRect(
                borderRadius:  const BorderRadius.all(Radius.circular(35)),
          child: Image.network(items.logo),
        ), 
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(items.restaurantName.toString(),textAlign: TextAlign.right,style:  TextStyle(
              fontSize: 18,  color: Theme.of(context).primaryColor),),
                const SizedBox(height: 10),
              Text("رقم الطلب : "+items.orderNo.toString(),textAlign: TextAlign.right,style: const TextStyle(
                color: Colors.black),),
                const SizedBox(height: 7),
              Text(items.orderDate.toString(),textAlign: TextAlign.right,style: const TextStyle(
                color: Colors.black),),
            ],
            )
        ,subtitle:
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(" IQD "+items.total.toString() ,textAlign: TextAlign.right,style: const TextStyle(
                    color: Colors.black)),
                ),
                const SizedBox(height: 3),
               Container(
                child: Text(items.isCancel==true? 'مرفوض':
                 (items.isCancel==false && items.isApporve==false && items.isDone==false)? 'انتظار': items.isDone==true?'منتهي':'مقبول',style:const TextStyle(
                    color: Colors.white)), 
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5)
                  ,color:items.isCancel==true?  Colors.red :
                  (items.isCancel==false && items.isApporve==false && items.isDone==false)?Color.fromARGB(255, 192, 192, 2) : items.isDone==true? Colors.greenAccent: Colors.green), 
            padding: const EdgeInsets.symmetric(vertical: 5 ,horizontal: 10),  
            ), 
            const SizedBox(height: 3),
              ],
            ),
        leading: (items.isCancel==false && items.isApporve==false && items.isDone==false)
        ||items.isCancel==true || (items.isApporve==true && items.isDone==false)?  null: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35)
              ,color:Theme.of(context).secondaryHeaderColor),
            child: Icon(Icons.published_with_changes,color: Theme.of(context).primaryColor
            ),
          ),
        )
      ],),
      );
  }
}


class GetShimmer extends StatelessWidget {
  const GetShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded( 
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context,index){
       return Shimmer.fromColors(  
      baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15)
                  ,color: Theme.of(context).secondaryHeaderColor),
            margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
            padding: const EdgeInsets.all(0),  
            ), 
        ],
      ) );
        
      }
      ),
    );
  }
}
 