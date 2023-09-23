import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';  

 
class my_order extends StatefulWidget {
  const my_order({Key? key}) : super(key: key);
 
  @override
  State<my_order> createState() => _myorder();
}
class _myorder extends State<my_order> {  
     
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(  
        body: Text("my order"),
        backgroundColor:Theme.of(context).backgroundColor,
      ),
    );
} 
}