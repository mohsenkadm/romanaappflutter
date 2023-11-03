// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/CategoryFill.dart';
import 'package:romanaappflutter/Constant/RestourentFill.dart';
import 'package:romanaappflutter/Controller/CategoriesController.dart';
import 'package:romanaappflutter/Controller/RestourentController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/searchresandprod.dart';

class AllRestaourent extends StatefulWidget {
  const AllRestaourent({ Key? key }) : super(key: key);

  @override
  _AllRestaourentState createState() => _AllRestaourentState();
}

class _AllRestaourentState extends State<AllRestaourent> {

 final RestourentController  restourentController=Get.put(RestourentController());
 final CategoriesController categoriesController = Get.put(CategoriesController()); 
  @override
   Widget build(BuildContext context) {
     return MaterialApp( 
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: MyAppBar(),
        body:  SingleChildScrollView(
          child: Column(children: [ 
            CategorySlide(),
          const SizedBox(height:10,)
          ,  ResSlide()
          ],),
        ), 
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  } 
   AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(  
      actions: [
         Container(
         margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color: myTheme.secondaryHeaderColor),
          child: IconButton(onPressed: (){ 
                Get.to(const SearchResAndProd(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
          }, 
          icon: Icon(Icons.search,color: myTheme.primaryColor)
          ),
        ),
      ],
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon:  Icon(Icons.arrow_back_ios,color:Theme.of(context).primaryColor)),
          elevation: 0, 
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title:  Text("القسم",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),
            )
          );
  } 
   Container ResSlide() {
    return Container(  
        child:Obx(
        () => restourentController.isloded.value?
        const GetShimmerResAll():ListView.builder(   
              shrinkWrap: true,
              physics:const NeverScrollableScrollPhysics(),
          itemCount: restourentController.itemsres.length,
          itemBuilder: (context, index) {
            return FillResData(items: restourentController.itemsres[index]); 
          },
        ),
      ),
      );
  }
   Container CategorySlide() {
    return 
     Container(
      height: 180,
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