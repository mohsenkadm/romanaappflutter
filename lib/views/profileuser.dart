import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; 
import 'package:flutter/widgets.dart'; 


class profileuser extends StatefulWidget {
  const profileuser({Key? key}) : super(key: key);

  @override
  State<profileuser> createState() => _profileuser();
}
class _profileuser extends State<profileuser> {  
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  Scaffold(   
        body: Column(children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Theme.of(context).secondaryHeaderColor)
            ,child: ListTile( 
            trailing: Container(
              padding: EdgeInsets.all(10),
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
              padding: EdgeInsets.all(10),
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
                padding: EdgeInsets.all(10),
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
               onPressed: () {  },
               child: Container( 
                margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).secondaryHeaderColor)
                         ,child: ListTile( 
                         trailing: Container(
                padding: EdgeInsets.all(10),
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
               onPressed: () {  },
               child: Container( 
                margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Theme.of(context).secondaryHeaderColor)
                         ,child: ListTile( 
                         trailing: Container(
                padding: EdgeInsets.all(10),
                         decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(35)
                         ,color:Theme.of(context).secondaryHeaderColor),
                       child: Icon(Icons.info,color: Theme.of(context).primaryColor
                       ),
                     ),
                         title: const Text('عن رومانا',textAlign: TextAlign.right,)
                     )
                         ,),
             )
        ],),
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
}
}
  
 