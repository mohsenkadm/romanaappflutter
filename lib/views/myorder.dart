 
import 'package:flutter/material.dart';
import 'package:get/get.dart';  
 
// ignore: camel_case_types
class my_order extends StatefulWidget {
  const my_order({Key? key}) : super(key: key);
 
  @override
  State<my_order> createState() => _myorder();
}
// ignore: camel_case_types
class _myorder extends State<my_order> {  
     
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(   
      appBar:MyAppBar(),
        body: const Text("my order"),
        backgroundColor:Theme.of(context).backgroundColor,
      ),
    );
} 
AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(  
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon: const Icon(Icons.arrow_back,color: Colors.teal)),
          elevation: 2, 
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title: const Text("",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal),
            )
          );
  } 
}