import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/widgets.dart';
import 'package:get/get.dart'; 
import 'package:romanaappflutter/Controller/MyTabController.dart';


class SearchResAndProd extends StatefulWidget {
  @override
  State<SearchResAndProd> createState() => _SearchResAndProd();
}
class _SearchResAndProd extends State<SearchResAndProd> with SingleTickerProviderStateMixin{ 
   final MyTabController _tabx = Get.put(MyTabController());
   

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(  
        appBar: MyAppBar(),
        body: MyTabBarView(),
        backgroundColor: Colors.white,
      ),
    );
}

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
              margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              width: double.infinity,
              child: TextField( 
              decoration: InputDecoration(
                  hintText: 'بحث عن اقرب مطعم اليك',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.close),
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder( 
                    borderSide: BorderSide.none,  
                  ),
              )
          ),
            )
          ],
        ),
        Column( 
          children: [ 
            Container( 
               decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor, // Set your desired background color here
                  borderRadius: BorderRadius.circular(8.0), // Optional: Add rounded corners
                ),
              margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
              width: double.infinity,
              child: TextField( 
              decoration: InputDecoration(
                  hintText: 'ابحث عن الاكلات',
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.close),
                  contentPadding: EdgeInsets.all(15),
                  border: OutlineInputBorder( 
                    borderSide: BorderSide.none,  
                  ),
              )
          ),
            )
          ],
        ),
        
      ]);
   }

  AppBar MyAppBar() {
    return AppBar( 
      
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon: Icon(Icons.arrow_back,color: Colors.teal)),
          elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        bottom: TabBar(
        controller: _tabx.controller,
          indicatorColor: Colors.teal,
          labelColor: Colors.teal
          ,tabs: [
         Tab(child: Text("مطاعم"),icon: Icon(Icons.restaurant,size:25),iconMargin: EdgeInsets.all(2),),
         Tab(child: Text("الاكلات"),icon: Icon(Icons.food_bank_outlined,size: 25,),iconMargin: EdgeInsets.all(2))
        ],
        ),
        title: const Text("بحث",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal),
            )
          );
  }
}

 