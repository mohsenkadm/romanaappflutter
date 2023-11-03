
 // ignore_for_file: deprecated_member_use
 
import 'dart:ffi';

import 'package:flutter/material.dart'; 
import 'package:get/get.dart';  
import 'package:get_time_ago/get_time_ago.dart';
import 'package:romanaappflutter/Controller/notificationController.dart';
import 'package:romanaappflutter/Model/NotifModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:shimmer/shimmer.dart';

// ignore: camel_case_types
class notification extends StatefulWidget {
  
   const notification({Key? key}) : super(key: key);
  @override
  State<notification> createState() => _notification();
}
// ignore: camel_case_types
class _notification extends State<notification> {  
    
 final notificationController _controller=Get.put(notificationController());

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
       theme:myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(  
        appBar: MyAppBar(),
        body: Obx(
          () => RefreshIndicator( 
           color:  Theme.of(context).primaryColor,
      onRefresh:() => _controller.fetchData(),
            child: _controller.isloded.value?
            const GetShimmer():
            _controller.items.isEmpty? 
             Center( 
                   child: Container( 
                    height: 200,width: 150,
                    padding:const EdgeInsets.all(10),
                     child: Column(children: [
                      Icon(Icons.notifications_off,size: 100,color: myTheme.primaryColor,),
                   const SizedBox(height: 20,),
                   const Text('لا توجد بيانات',style:  TextStyle(fontSize: 18),)
                     ],
                     ),
                   ),
                 )
            : ListView.builder(
              itemCount: _controller.items.length,
              itemBuilder: (context, index) {
                var _convertedTimestamp =GetTimeAgo.parse(DateTime.parse(_controller.items[index].datetime),locale: 'ar');
                return FillNotificationData(items: _controller.items[index], convertedTimestamp: _convertedTimestamp); 
              },
            ),
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
}
 
  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(  
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon:  Icon(Icons.arrow_back_ios,color:Theme.of(context).primaryColor)),
          elevation: 2, 
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title:  Text("الاشعارات",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
            )
          );
  } 
}

class FillNotificationData extends StatelessWidget {
  const FillNotificationData({
    Key? key,
    required this.items,
    required String convertedTimestamp,
  }) : _convertedTimestamp = convertedTimestamp, super(key: key);

  final NotifModel items;
  final String _convertedTimestamp;

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
        ClipRRect(
              borderRadius:  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(items.images
                        ,fit: BoxFit.cover  ),
            )
        ,ListTile(trailing: const Text(''),
          title: Text(items.title,textAlign: TextAlign.right,style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold),)
        ,subtitle:Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 5),
            Text(items.details,textAlign: TextAlign.right),
            const SizedBox(height: 5),
            Text(_convertedTimestamp,textAlign: TextAlign.right)
            , const SizedBox(height: 5),
          ],
        ),
        leading:  Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color:Theme.of(context).secondaryHeaderColor),
          child: Icon(Icons.notifications_active,color: Theme.of(context).primaryColor
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
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context,index){
      return Shimmer.fromColors(  
      baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15)
              ,color: Theme.of(context).secondaryHeaderColor),
        margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        padding: const EdgeInsets.all(0), 
        child: Column(children: [
          ClipRRect(
                borderRadius:  const BorderRadius.vertical(top: Radius.circular(15)),
                child: Container(width: double.infinity, height: 100,color: Colors.white,),
              )
          ,
          ListTile(
          leading:  Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35)
              ,color:Theme.of(context).secondaryHeaderColor),
            child: Icon(Icons.notifications_active,color: Theme.of(context).primaryColor
            ),
          ),
          )
        ],),
        ),
    );

    });
  }
}
 
 