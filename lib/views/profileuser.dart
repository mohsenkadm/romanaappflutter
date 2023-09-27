 
import 'package:flutter/material.dart';
import 'package:get/get.dart';  
 class Profileuser extends StatefulWidget {
   const Profileuser({ Key? key }) : super(key: key);
 
   @override
   _ProfileuserState createState() => _ProfileuserState();
 }
 
 class _ProfileuserState extends State<Profileuser> {
   @override
   Widget build(BuildContext context) {
     return Column(children: [
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
            title: const Text('محسن كاظم',textAlign: TextAlign.right,),
            subtitle:  const Text('07505496065',textAlign: TextAlign.right)
        , )
            ,)
            ,
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
                Get.toNamed('/AboutApp');
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
                         title: const Text('عن رومانة',textAlign: TextAlign.right,)
                     )
                         ,),
             )
        ],);
   }
 }
  
 