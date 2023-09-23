import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';  


class category extends StatefulWidget {
  const category({Key? key}) : super(key: key);

  @override
  State<category> createState() => _category();
}
class _category extends State<category> {  
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(   
        body: Text("الاصناف"),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
}
}
  
 