import 'dart:isolate';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';

class AddRes extends StatefulWidget {
  const AddRes({ Key? key }) : super(key: key);

  @override
  _AddResState createState() => _AddResState();
}

class _AddResState extends State<AddRes> {
  @override
  Widget build(BuildContext context) {
     return MaterialApp( 
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: MyAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 180,
              margin: const EdgeInsets.symmetric(horizontal: 30),
             width: double.infinity,
                 decoration: BoxDecoration( 
                    borderRadius: BorderRadius.circular(10),
                   color: Theme.of(context).secondaryHeaderColor),
              child: Column( 
                mainAxisAlignment: MainAxisAlignment.center,
               children: [
                 const Text('سعيدون جداً برغبة انضمامك لنا ، يمنح تطبيقنا مميزات عديدة لزبائنك .',textAlign: TextAlign.right,)
                ,const SizedBox(height: 10,)
                 ,const Text('سعيدون جداً برغبة انضمامك لنا ، يمنح تطبيقنا مميزات عديدة لزبائنك .',textAlign: TextAlign.right,)
               ,const SizedBox(height: 10,)
               ,ElevatedButton.icon(onPressed: ()=>{ 
               }, style: ElevatedButton.styleFrom(
                      backgroundColor: myTheme.primaryColor
                    ), icon: const Icon(Icons.send), label: const Text('تواصل')
               ),
             const SizedBox(height: 10,)
               ],
                        ),
            ),
          ),
        ),
      ),
    );
  }
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
        title:  Text("اضافة مطعم",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
            )
          );
  } 
}