 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/views/Accounts.dart';
import 'package:romanaappflutter/views/AddRes.dart';

import 'AboutApp.dart';  
 class Profileuser extends StatefulWidget {
   const Profileuser({ Key? key }) : super(key: key);
 
   @override
   _ProfileuserState createState() => _ProfileuserState();
 }
 
 class _ProfileuserState extends State<Profileuser> {
  final ProfileuserController _controller=Get.put(ProfileuserController());
   @override
   Widget build(BuildContext context) {
     return Column(children: [
         Obx(
              ()=>_controller.user.value==null?
                Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).secondaryHeaderColor)
            ,child: ListTile( 
            trailing: Container(
              padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color:Theme.of(context).secondaryHeaderColor),
          child: Icon(Icons.person,color: Theme.of(context).primaryColor
          ),
        ),
            
        )
            ,):
                Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).secondaryHeaderColor)
            ,child: ListTile( 
              trailing: Container(
                padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35)
              ,color:Theme.of(context).secondaryHeaderColor),
                      child: Icon(Icons.person,color: Theme.of(context).primaryColor
                      ),
                    ),
              title:  Text(_controller.user.value!.Name,textAlign: TextAlign.right,),
              subtitle:   Text(_controller.user.value!.Phone,textAlign: TextAlign.right)
                    , ),
            )
            ,),
             Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).secondaryHeaderColor)
            ,child: ListTile( 
            trailing: Container(
              padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color:Theme.of(context).secondaryHeaderColor),
          child: Icon(Icons.notifications_active,color: Theme.of(context).primaryColor
          ),
        ),
            title: const Text('الاشعارات',textAlign: TextAlign.right,),
            subtitle:  const Text('تفعيل الاشعارات',textAlign: TextAlign.right)
        ,leading: Switch( onChanged: (bool value) {   }, value: false,), 
        )
            ,),
             TextButton(  
               onPressed: () {  },
               child: Container( 
                margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).secondaryHeaderColor)
                         ,child: ListTile( 
                         trailing: Container(
                padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(35)
                         ,color:Theme.of(context).secondaryHeaderColor),
                       child: Icon(Icons.message,color: Theme.of(context).primaryColor
                       ),
                     ),
                         title: const Text('تواصل معنا',textAlign: TextAlign.right,)
                     )
                         ,),
             ),
             TextButton(
               onPressed: () { 
                //if (Platform.isAndroid || Platform.isIOS) {
                  //  final appId = Platform.isAndroid ? 'YOUR_ANDROID_PACKAGE_ID' : 'YOUR_IOS_APP_ID';
                    //final url = Uri.parse(
                 //     Platform.isAndroid
                   //       ? "market://details?id=$appId"
                   //       : "https://apps.apple.com/app/id$appId",
                  //  );
                  //  launchUrl(
                  //    url,
                  //    mode: LaunchMode.externalApplication,
                  //  );
               //   }
                },
               child: Container( 
                margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).secondaryHeaderColor)
                         ,child: ListTile( 
                         trailing: Container(
                padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(35)
                         ,color:Theme.of(context).secondaryHeaderColor),
                       child: Icon(Icons.share,color: Theme.of(context).primaryColor
                       ),
                     ),
                         title: const Text('مشاركة التطبيق',textAlign: TextAlign.right,)
                     )
                         ,),
             ), 
             TextButton(
               onPressed: () {  
                Get.to(const AboutApp(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
                },
               child: Container( 
                margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).secondaryHeaderColor)
                         ,child: ListTile( 
                         trailing: Container(
                padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(35)
                         ,color:Theme.of(context).secondaryHeaderColor),
                       child: Icon(Icons.info,color: Theme.of(context).primaryColor
                       ),
                     ),
                         title: const Text('عن تطبيق رمانة',textAlign: TextAlign.right,)
                     )
                         ,),
             ), 
             TextButton(
               onPressed: () { 
                Get.to(const Accounts(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
                },
               child: Container( 
                margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).secondaryHeaderColor)
                         ,child: ListTile( 
                         trailing: Container(
                padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(35)
                         ,color:Theme.of(context).secondaryHeaderColor),
                       child: Icon(Icons.public,color: Theme.of(context).primaryColor
                       ),
                     ),
                         title: const Text('حساباتنا',textAlign: TextAlign.right,)
                     )
                         ,),
             ) ,
             TextButton(
               onPressed: () {  
                Get.to(const AddRes(),
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade);
                },
               child: Container( 
                margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).secondaryHeaderColor)
                         ,child: ListTile( 
                         trailing: Container(
                padding: const EdgeInsets.all(10),
                         decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(35)
                         ,color:Theme.of(context).secondaryHeaderColor),
                       child: Icon(Icons.restaurant,color: Theme.of(context).primaryColor
                       ),
                     ),
                         title: const Text('اضافة مطعم',textAlign: TextAlign.right,)
                     )
                         ,),
             )
        ],);
   }
 }
  
 