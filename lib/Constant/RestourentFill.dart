
import 'package:flutter/material.dart';
import 'package:romanaappflutter/Model/CategoriesModel.dart';
import 'package:shimmer/shimmer.dart';

class FillResData extends StatelessWidget {
  const FillResData({
    Key? key,
    required this.items, 
  }) : super(key: key);

  final CategoriesModel items; 
  @override
  Widget build(BuildContext context) {
    return 
   Container(
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
            ,color: Theme.of(context).secondaryHeaderColor),
      margin: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
      padding: const EdgeInsets.all(0), 
      child: Column(children: [
        ClipRRect(
              borderRadius:  const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(items.CategoriesImages
                        ,fit: BoxFit.cover  ),
            )
        ,
        ListTile(trailing: const Text(''),
          title: Text(items.CategoriesName,textAlign: TextAlign.right,style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold),)
        ,subtitle:Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const SizedBox(height: 5),
            Text(items.CategoriesName,textAlign: TextAlign.right),
            const SizedBox(height: 5), 
          ],
        ),
        leading:  Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color:Theme.of(context).secondaryHeaderColor),
          child: Icon(Icons.notifications_active,color: Theme.of(context).primaryColor
          ),
        ),
        )
      ],),
      );
  }
}

  
 
 // shimmer category

class GetShimmerRes extends StatelessWidget {
  const GetShimmerRes({
    Key? key, 
  }) : super(key: key);
 
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder( 
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (context,index){
     return Shimmer.fromColors(  
      baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
      child:  
      Column(
children: [
          Container( 
          width: 200,height: 120,
          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15)
                // ignore: deprecated_member_use
                ,color: Theme.of(context).backgroundColor),
          margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10)
          ), 
        ClipRRect(
              borderRadius:  BorderRadius.circular(15.0),
          child: Container( 
          decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15)
                // ignore: deprecated_member_use
                ,color: Theme.of(context).backgroundColor),
          height:20,width: 100,)) 
        ]));
    });
  }
}