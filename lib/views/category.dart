
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
        body:  Column(children: [ 
          CategorySlide(),
        ],), 
        backgroundColor: Colors.white,
      ),
    );

    
}
 
  Expanded CategorySlide() {
    return 
     Expanded(
       child: 
       Obx(()=> categoriesController.isloded.value?
       const GetShimmercategories():
       categoriesController.itemscategories.isEmpty?
         Center(
                    child: Container(
                      height: 250,
                      width: 300,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Icon(
                            Icons.restaurant_menu,
                            size: 100,
                            color: myTheme.primaryColor,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            'لا توجد اقسام ',
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                  )
                :
       GridView.builder( 
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),    
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
 
  
  