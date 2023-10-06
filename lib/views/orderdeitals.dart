import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:romanaappflutter/main.dart';

class Orderdeitals extends StatefulWidget {
  const Orderdeitals({ Key? key }) : super(key: key);

  @override
  _OrderdeitalsState createState() => _OrderdeitalsState();
}

class _OrderdeitalsState extends State<Orderdeitals> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(    
        body: Text('data'),
        backgroundColor:Theme.of(context).backgroundColor,
      ),
    );
  }
}