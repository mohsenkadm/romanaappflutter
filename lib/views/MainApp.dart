import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/ChooseLocation.dart';
import 'package:romanaappflutter/views/category.dart';
import 'package:romanaappflutter/views/homepage.dart';
import 'package:romanaappflutter/views/myorder.dart';
import 'package:romanaappflutter/views/notification.dart';
import 'package:romanaappflutter/views/profileuser.dart';
import 'package:romanaappflutter/views/searchresandprod.dart';
import 'package:romanaappflutter/views/shoppingcart.dart';

class MainApp extends StatefulWidget {
  const MainApp({ Key? key }) : super(key: key);

  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final RxInt currentIndex = 0.obs;
  
  final List<Widget> tabs = [
    const homepage(),
    const category(),
    const my_order(),
    const Profileuser()
  ];  
   
  @override
  Widget build(BuildContext context) {

   return Scaffold( 
      bottomNavigationBar: my_bottom_bar(),
        appBar: my_app_bar(),
        body:  Obx(
            () => tabs[currentIndex.value],
        ),
        backgroundColor: Colors.white,
      );
  }
  // ignore: non_constant_identifier_names
  Container my_bottom_bar() {
    return Container(
      color: Colors.white,
      child: Padding(
   padding: const EdgeInsets.symmetric(horizontal: 15.0 ,vertical: 20),
   child:  GNav(
    selectedIndex: currentIndex.value,
    onTabChange: (index)=> currentIndex.value=index,
       gap: 4,
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
        color: myTheme.primaryColor,
// ignore: deprecated_member_use
activeColor: Colors.white,
        tabBackgroundColor: myTheme.primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16 ,vertical: 10),
        tabs: const [
          GButton(icon: Icons.home,text: "الرئيسية",),
          GButton(icon: Icons.category,text: "الاقسام",),
          GButton(icon: Icons.list_alt,text: "الطلبات",),
          GButton(icon: Icons.person,text: "حسابي",),
        ],
      ),
      ),
      );
  }

  // ignore: non_constant_identifier_names
   AppBar my_app_bar() {
    return AppBar(  
      actions: [
        Container(
         margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color: myTheme.secondaryHeaderColor),
          child: IconButton(onPressed: (){ 
                Get.to(const shoppingcard(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
          }, 
          icon: Icon(Icons.shopping_cart_outlined,color: myTheme.primaryColor)
          ),
        ), 
        Container(
         margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color: myTheme.secondaryHeaderColor),
          child: IconButton(onPressed: (){ 
                Get.to(const ChooseLocation(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
          }, 
          icon: Icon(Icons.location_on,color: myTheme.primaryColor)
          ),
        ),
        Container(
         margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color: myTheme.secondaryHeaderColor),
          child: IconButton(onPressed: (){ 
                Get.to(const notification(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
          }, icon: Icon(Icons.notifications_active_outlined,color: myTheme.primaryColor)
          ),
        ),
      ],
          elevation: 0,
        backgroundColor: Colors.white, 
       title: Container(
         decoration: BoxDecoration(
                  color: myTheme.secondaryHeaderColor, // Set your desired background color here
                  borderRadius: BorderRadius.circular(8.0), // Optional: Add rounded corners
                ),
        width: double.infinity, 
        margin:const EdgeInsets.symmetric(vertical: 20,horizontal: 0),
        child: TextButton(   
           onPressed: (){ 
                Get.to(const SearchResAndProd(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
                },
        child:Row( 
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.search,color: myTheme.primaryColor),
               const SizedBox(width: 20,),
                Text(
                  'بحث',textAlign: TextAlign.right,
                  style: TextStyle(fontFamily:"Tajawal",fontSize: 18.0,color: myTheme.primaryColor
                  ,),
                ) ,
                const SizedBox(width: 5,),
              ],
              )
              )
       )
      );
  }

}