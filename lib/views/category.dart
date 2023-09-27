
 // ignore_for_file: deprecated_member_use
 
import 'package:flutter/material.dart';  
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/CategoryFill.dart';
import 'package:romanaappflutter/Controller/CategoriesController.dart'; 
import 'package:romanaappflutter/main.dart';  
// ignore: camel_case_types
class category extends StatefulWidget {
  const category({Key? key}) : super(key: key);

  @override
  State<category> createState() => _category();
}
// ignore: camel_case_types
class _category extends State<category> { 
  
 final CategoriesController categoriesController = Get.put(CategoriesController()); 
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(   
        body:  Column(children: [ CategorySlide(),
        ],), 
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );

    
}
 
  Container CategorySlide() {
    return 
     Container(
      height: 160,
       child: 
       Obx(()=> categoriesController.isloded.value?
       const GetShimmercategories():
       ListView.builder(   
              reverse: true,
      scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: categoriesController.itemscategories.length,
              itemBuilder: (context, index) { 
                return FillcategoriesData(items: categoriesController.itemscategories[index]); 
              },
            )
       ),
     );
  }
}
 
  
  