import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart'; 
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';  
import 'package:get_time_ago/get_time_ago.dart';
import 'package:romanaappflutter/Controller/notificationController.dart';
import 'package:romanaappflutter/Model/NotifModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:shimmer/shimmer.dart';

class notification extends StatefulWidget {
  
   notification({Key? key}) : super(key: key);
  @override
  State<notification> createState() => _notification();
}
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
          () => _controller.isloded.value?
          const GetShimmer():ListView.builder(
            itemCount: _controller.items.length,
            itemBuilder: (context, index) {
              var _convertedTimestamp =GetTimeAgo.parse(DateTime.parse(_controller.items[index].datetime),locale: 'ar');
              return FillNotificationData(items: _controller.items[index], convertedTimestamp: _convertedTimestamp); 
            },
          ),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
}
 
  AppBar MyAppBar() {
    return AppBar(  
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon: Icon(Icons.arrow_back,color: Colors.teal)),
          elevation: 2,
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title: const Text("الاشعارات",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal),
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
      margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      padding: EdgeInsets.all(0), 
      child: Column(children: [
        ClipRRect(
              borderRadius:  BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(items.imagePath
                        ,fit: BoxFit.cover  ),
            )
        ,
        ListTile(trailing: Text(''),
          title: Text(items.title,textAlign: TextAlign.right,style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold),)
        ,subtitle:Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 5),
            Text(items.description,textAlign: TextAlign.right),
            SizedBox(height: 5),
            Text(_convertedTimestamp,textAlign: TextAlign.right)
            , SizedBox(height: 5),
          ],
        ),
        leading:  Container(
            padding: EdgeInsets.all(10),
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
        margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
        padding: EdgeInsets.all(0), 
        child: Column(children: [
          ClipRRect(
                borderRadius:  BorderRadius.vertical(top: Radius.circular(15)),
                child: Container(width: double.infinity, height: 100,color: Colors.white,),
              )
          ,
          ListTile(
          leading:  Container(
              padding: EdgeInsets.all(10),
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
 
 