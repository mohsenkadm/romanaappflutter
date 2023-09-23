import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/CategoriesController.dart';
import 'package:romanaappflutter/Controller/MainController.dart';
import 'package:romanaappflutter/Model/CategoriesModel.dart';
import 'package:shimmer/shimmer.dart';

// ignore: camel_case_types
class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
   List _listimageslider=[
    {"id":1,"image":'assets/images/img1.png'},
    {"id":2,"image":'assets/images/img2.png'},
    {"id":3,"image":'assets/images/img3.png'},
  ];
  
  final MainController mainController = Get.put(MainController());
 final CategoriesController categoriesController = Get.put(CategoriesController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlide(),  
        CategorySlide(),
      ]
    );
  }

  Container CategorySlide() {
    return
     Container(
      height: 160,
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
  
  Padding CarouselSlide() {
    return Padding(
    padding: const EdgeInsets.only(top:10.0),
    child: Column(children: [
      Stack(children: [
        InkWell(
          onTap: (){ 
          },
          child: CarouselSlider(items: _listimageslider.
          map(
            (item) => ClipRRect(
              borderRadius:  BorderRadius.circular(15.0),
              child: Image.asset(item['image']
                        ,fit: BoxFit.cover 
                        ),
            )
          ).toList()
          ,options: CarouselOptions(scrollPhysics: const BouncingScrollPhysics(),
          autoPlay: true,
          enlargeCenterPage: true,
           aspectRatio: 2,viewportFraction: 1,
          onPageChanged: (index,reason){
            mainController.onPageChanged(index);
          }
         ),
          ),
        ),
        Obx(
          () =>Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _listimageslider.asMap().entries.map((entry) {
                  return GestureDetector(
                    //onTap: () => controller.animateToPage(entry.key),
                    child: Container(
                      width: mainController.currentIndex.value == entry.key ? 17 : 7,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 3.0,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: mainController.currentIndex.value == entry.key
                              ? Colors.red
                              : Colors.teal),
                    ),
                  );
                }).toList(),
              )),
        )
      ],)
    ],),
  );
  }
}


class FillcategoriesData extends StatelessWidget {
  const FillcategoriesData({
    Key? key,
    required this.items, 
  }) : super(key: key);

  final CategoriesModel items; 
  @override
  Widget build(BuildContext context) {
    return 
    Container( 
      width: 100,height: 50,
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
            ,color: Theme.of(context).backgroundColor),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Column(children: [ 
        ClipRRect(
              borderRadius:  BorderRadius.circular(15.0),
          child: Image.asset(items.CategoriesImages!,
          height:100,width: 100,
          fit: BoxFit.cover,))
          ,SizedBox(height: 10,)
        ,Text(items.CategoriesName!)
      ],),
      );
  }
}


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
      child:  Container( 
      width: 100,height: 50,
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
            ,color: Theme.of(context).backgroundColor),
      margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      child: Column(children: [ 
        ClipRRect(
              borderRadius:  BorderRadius.circular(15.0),
          child: Container(
          height:100,width: 100,))
          ,SizedBox(height: 10,)
        ,Container(width: 100,height: 20,color: Colors.grey[200],)
      ],),
      )
    );

    });
  }
}
