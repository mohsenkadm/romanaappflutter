//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/CategoryFill.dart';
import 'package:romanaappflutter/Constant/RestourentFill.dart';
import 'package:romanaappflutter/Controller/CategoriesController.dart';
import 'package:romanaappflutter/Controller/MainController.dart';
import 'package:romanaappflutter/Controller/RestourentController.dart';
import 'package:romanaappflutter/Model/CarouselModel.dart';
import 'package:shimmer/shimmer.dart'; 

// ignore: camel_case_types
class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

// ignore: camel_case_types
class _homepageState extends State<homepage> {
   
  
  final MainController mainController = Get.put(MainController());
 final CategoriesController categoriesController = Get.put(CategoriesController());
 final RestourentController  restourentController=Get.put(RestourentController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlide(),  
        CategorySlide(), 
        ResSlide()
      ]
    );
  }

  // ignore: non_constant_identifier_names
  Container ResSlide() {
    return Container( 
      height: 180, 
        child:Obx(
        () => !restourentController.isloded.value?
        const GetShimmerRes():ListView.builder(  
      scrollDirection: Axis.horizontal,
              shrinkWrap: true,
          itemCount: restourentController.itemscategories.length,
          itemBuilder: (context, index) {
            return FillResData(items: restourentController.itemscategories[index]); 
          },
        ),
      ),
      );
  }

  // ignore: non_constant_identifier_names
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
  
  // ignore: non_constant_identifier_names
  Padding CarouselSlide() {
    return Padding(
    padding: const EdgeInsets.only(top:10.0),
    child: Column(children: [
      Stack(children: [
        InkWell(
          onTap: (){ 
          },
          child: 
       Obx(()=> mainController.isloded.value?
        Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
          child: ClipRRect(
             borderRadius:  BorderRadius.circular(15.0),
             child: Container( margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15)
                  // ignore: deprecated_member_use
                  ,color: Theme.of(context).backgroundColor),
                  height: 200,width: double.infinity,
              )
              ),
        ):
        CarouselSlider.builder( 
            itemCount: mainController.itemsCarousel.length,
             itemBuilder: (context, index,realIndex) { 
             return FillImageCarousel(item:mainController.itemsCarousel[index]);
        }
          ,options: CarouselOptions(scrollPhysics: const BouncingScrollPhysics(),
          autoPlay: true,
          enlargeCenterPage: true,
           aspectRatio: 2,viewportFraction: 1,
          onPageChanged: (index,reason){
            mainController.onPageChanged(index);
          }
         ),
          ),
        )),
        Obx(
          () =>Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: mainController.itemsCarousel.asMap().entries.map((entry) {
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

class FillImageCarousel extends StatelessWidget {
  const FillImageCarousel({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CarouselModel item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
     borderRadius:  BorderRadius.circular(15.0),
     child:const Text('data')
     //CachedNetworkImage( 
   // placeholder: (context, url) => const CircularProgressIndicator(),
    //   errorWidget: (context, url, error) => const Icon(Icons.error),
    //   imageUrl: item.image
    // ),
            );
  }
}
 