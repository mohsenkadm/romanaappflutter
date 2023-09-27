 import 'package:flutter/material.dart';  
import 'package:get/get.dart';  


// ignore: camel_case_types
class shoppingcard extends StatefulWidget {
  const shoppingcard({Key? key}) : super(key: key);

  @override
  State<shoppingcard> createState() => _shoppingcard();
}
// ignore: camel_case_types
class _shoppingcard extends State<shoppingcard> {  
    
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(  
        appBar: MyAppBar(),
        body: const Text('card'),
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
}
 
  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    return AppBar( 
      
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon: const Icon(Icons.arrow_back,color: Colors.teal)),
          elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title: const Text("سلة الطلب",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal),
            )
          );
  }
}

  