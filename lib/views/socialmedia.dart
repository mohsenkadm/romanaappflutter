// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';

class Socialmedia extends StatefulWidget {
  const Socialmedia({ Key? key }) : super(key: key);

  @override
  _SocialmediaState createState() => _SocialmediaState();
}

class _SocialmediaState extends State<Socialmedia> {
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: MyAppBar(),
        body: const Text('data'),
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