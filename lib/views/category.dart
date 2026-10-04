
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
    return Scaffold(   
        body: Column(children: [ 
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'الأقسام',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: myTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.category_rounded, color: myTheme.primaryColor, size: 24),
              ],
            ),
          ),
          CategorySlide(),
        ],), 
        backgroundColor: Colors.white,
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.92,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),    
              shrinkWrap: true,
              itemCount: categoriesController.itemscategories.length,
              itemBuilder: (context, index) { 
                return FillcategoriesData(items: categoriesController.itemscategories[index], index: index); 
              },
            )
       ),
     );
  }
}
 
  
  