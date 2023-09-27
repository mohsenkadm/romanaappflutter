 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';  
  
class AboutApp extends StatefulWidget {
  const AboutApp({ Key? key }) : super(key: key);

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: MyAppBar(),
        body: Container(
          child: Text('data'),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
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
        title: const Text("عن تطبيق رومانة",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal),
            )
          );
  } 
} 