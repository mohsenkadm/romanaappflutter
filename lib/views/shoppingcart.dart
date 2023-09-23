import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';  


class shoppingcard extends StatefulWidget {
  @override
  State<shoppingcard> createState() => _shoppingcard();
}
class _shoppingcard extends State<shoppingcard> {  
    
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(  
        appBar: MyAppBar(),
        body: Text('card'),
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
        title: const Text("سلة الطلب",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal),
            )
          );
  }
}

  