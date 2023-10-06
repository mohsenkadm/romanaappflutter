
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart'; 
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:shimmer/shimmer.dart';

class FillResData extends StatelessWidget {
  const FillResData({
    Key? key,
    required this.items, 
  }) : super(key: key);

  final RestaurantModel items; 
  @override
  Widget build(BuildContext context) {
    return 
   Container(
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
            ,color: Theme.of(context).secondaryHeaderColor),
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      padding: const EdgeInsets.all(0), 
      child: Column(children: [
       ClipRRect(
                borderRadius:  BorderRadius.circular(15.0),
            child:  CachedNetworkImage( 
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
         errorWidget: (context, url, error) => const Icon(Icons.error),
         imageUrl: items.background
       ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
              Text("الحد الادنى للطلب  "+items.minimumPrice.toInt().toString()+" د.ع ",
              textAlign: TextAlign.right ,style:  TextStyle(fontSize: 10),),
            const SizedBox(height: 10,),
              Row(
                children: [
                  Text(items.address.toString(),
                  textAlign: TextAlign.right ,style:  TextStyle(fontSize: 10),), 
                  const Icon(Icons.location_on,size: 15,),
                ],
              )
                    ],
                  ),
                   Column(
                    children: [
                      Text(items.name,textAlign: TextAlign.right),
              Text(items.minimumPrice.toString(),textAlign: TextAlign.right)
                    ],
                  ),
                   Column(
                    children: [
                      Text(items.name,textAlign: TextAlign.right,style: TextStyle(
              color: Theme.of(context).primaryColor,fontSize: 20,
              fontWeight: FontWeight.bold),),
               const SizedBox(height: 10,),
              Text(items.minimumPrice.toString(),textAlign: TextAlign.right)
                    ],
                  ),
                ],
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
 // shimmer category

class GetShimmerResAll extends StatelessWidget {
  const GetShimmerResAll({
    Key? key, 
  }) : super(key: key);
 
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder( 
      shrinkWrap: true, 
      itemCount: 7,
      itemBuilder: (context,index){
     return Shimmer.fromColors(  
      baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
      child:  
      Column(
        children: [
          Container( 
          width: double.infinity,height: 150,
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