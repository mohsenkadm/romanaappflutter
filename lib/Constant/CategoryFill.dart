
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Model/CategoriesModel.dart';
import 'package:romanaappflutter/views/AllRestaourent.dart';
import 'package:shimmer/shimmer.dart';

class FillcategoriesData extends StatelessWidget {
  const FillcategoriesData({
    Key? key,
    required this.items, 
  }) : super(key: key);

  final CategoriesModel items; 
  @override
  Widget build(BuildContext context) {
    return 
    InkWell(onTap: () {
      Get.to(()=>const AllRestaourent(),arguments:"",
                duration:const Duration(milliseconds:500 )
                ,transition: Transition.fade,);
    },
      child: Container( 
        width: 130,height: 90,
        decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15)
              ,color: Theme.of(context).backgroundColor),
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Column(children: [ 
          ClipRRect(
                borderRadius:  BorderRadius.circular(15.0),
            child:  CachedNetworkImage( 
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
         errorWidget: (context, url, error) => const Icon(Icons.error),
         imageUrl: items.CategoriesImages
       ),
            )
            ,const SizedBox(height: 10,)
          ,Text(items.CategoriesName,style:const TextStyle(fontFamily: "Tajawal",fontSize: 16))
        ],),
        ),
    );
  }
}

  
 
 // shimmer category

class GetShimmercategories extends StatelessWidget {
  const GetShimmercategories({
    Key? key, 
  }) : super(key: key);
 
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      
      scrollDirection: Axis.horizontal,
      itemCount: 10,
      itemBuilder: (context,index){
      return Shimmer.fromColors(  
      baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
      child:  Column(
        children: [
          Container( 
          width: 100,height: 100,
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
          height:20,width: 100,)
          ) 
        ],
      ),
      );
    });
  }
}