import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Model/RestaurantModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/RestaourantProfile.dart';
import 'package:romanaappflutter/views/StarsView.dart';
import 'package:shimmer/shimmer.dart';

class FillResData extends StatelessWidget {
  const FillResData({
    Key? key,
    required this.items,
  }) : super(key: key);

  final RestaurantModel items;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (items.isClosed!) {
          ErrorMessage.SnackMessage(
              "مغلق الان يمكنك الطلب لاحقا", Colors.red[400]!);
          return;
        }
        Get.to(
          () => const RestaourantProfile(),
          arguments: [items.restaurantId.toString()],
          duration: const Duration(milliseconds: 500),
          transition: Transition.fade,
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).secondaryHeaderColor),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Stack(children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: items.background == null ? '' : items.background!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              items.isClosed == true
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: FractionalOffset.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: myTheme.primaryColor),
                          child: const Text(
                            " مغلق ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ]),
            Padding(
              padding: const EdgeInsets.fromLTRB(5,5,5,5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    
                      onPressed: () {
                        if (items.isClosed!) {
                          ErrorMessage.SnackMessage(
                              "مغلق الان يمكنك الطلب لاحقا", Colors.red[400]!);
                          return;
                        }
                        Get.to(
                          () => const RestaourantProfile(),
                          arguments: [items.restaurantId.toString()],
                          duration: const Duration(milliseconds: 500),
                          transition: Transition.fade,
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                        size: 14,
                      ),
                    
                      style: ElevatedButton.styleFrom( 
                          backgroundColor: myTheme.primaryColor),
                      label: const Text(
                        'اطلب الان',
                        style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white),
                      )),
                  Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(2, 2, 0, 2),
                          child: Text(
                            overflow: TextOverflow.visible,
                            items.name ?? '',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                Text( 
                                  items.address ?? '',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: myTheme.primaryColor),
                                ),
                               const SizedBox(width: 5,),
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: myTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),  
                           Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                Text(items.costDelivery.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: myTheme.primaryColor),
                                ),
                               const SizedBox(width: 5,),
                                Icon(
                                  Icons.delivery_dining,
                                  size: 16,
                                  color: myTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                             onTap: () {
                              items.isStars!?
                              Get.to(
                                () => const StarsView(),
                                arguments: [items.restaurantId],
                                duration: const Duration(milliseconds: 500),
                                transition: Transition.fade,
                              ):
                              ErrorMessage.SnackMessage("لا يمكن التقييم", Colors.green[400]!);
                              
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 3, 0),
                                    child: Text(
                                      items.starCount.toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: myTheme.primaryColor),
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    size: 16,
                                    color: myTheme.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FillResDataForTop extends StatelessWidget {
  const FillResDataForTop({
    Key? key,
    required this.items,
  }) : super(key: key);

  final RestaurantModel items;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (items.isClosed!) {
          ErrorMessage.SnackMessage(
              "مغلق الان يمكنك الطلب لاحقا", Colors.red[400]!);
          return;
        }
        Get.to(
          () => const RestaourantProfile(),
          arguments: [items.restaurantId.toString()],
          duration: const Duration(milliseconds: 500),
          transition: Transition.fade,
        );
      },
      child: Container(
        width: 380,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).secondaryHeaderColor),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            Stack(children: [
              SizedBox(
                width: double.infinity,
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: CachedNetworkImage(
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    imageUrl: items.background == null ? '' : items.background!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              items.isClosed == true
                  ? Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Align(
                        alignment: FractionalOffset.topRight,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: myTheme.primaryColor),
                          child: const Text(
                            " مغلق ",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox()
            ]),
             Padding(
              padding: const EdgeInsets.fromLTRB(5,5,5,5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    
                      onPressed: () {
                        if (items.isClosed!) {
                          ErrorMessage.SnackMessage(
                              "مغلق الان يمكنك الطلب لاحقا", Colors.red[400]!);
                          return;
                        }
                        Get.to(
                          () => const RestaourantProfile(),
                          arguments: [items.restaurantId.toString()],
                          duration: const Duration(milliseconds: 500),
                          transition: Transition.fade,
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_basket,
                        color: Colors.white,
                        size: 14,
                      ),
                    
                      style: ElevatedButton.styleFrom( 
                          backgroundColor: myTheme.primaryColor),
                      label: const Text(
                        'اطلب الان',
                        style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                            color: Colors.white),
                      )),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 0, 2),
                        child: Text(
                          items.name?? '',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                Text(
                                  '${items.address ?? ''},${items.areaname??''}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: myTheme.primaryColor),
                                ),
                               const SizedBox(width: 5,),
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: myTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),  
                           Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                Text(items.costDelivery.toString(),
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: myTheme.primaryColor),
                                ),
                               const SizedBox(width: 5,),
                                Icon(
                                  Icons.delivery_dining,
                                  size: 16,
                                  color: myTheme.primaryColor,
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                             onTap: () {
                              items.isStars!?
                              Get.to(
                                () => const StarsView(),
                                arguments: [items.restaurantId],
                                duration: const Duration(milliseconds: 500),
                                transition: Transition.fade,
                              ):
                              ErrorMessage.SnackMessage("لا يمكن التقييم", Colors.green[400]!);
                              
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 3, 0),
                                    child: Text(
                                      items.starCount.toString(),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: myTheme.primaryColor),
                                    ),
                                  ),
                                  Icon(
                                    Icons.star_sharp,
                                    size: 16,
                                    color: myTheme.primaryColor,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )
           ],
        ),
      ),
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
        itemCount: 10,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(children: [
                Container(
                    width: 200,
                    height: 120,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                        // ignore: deprecated_member_use
                        ,
                        color: Colors.white),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10)),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)
                          // ignore: deprecated_member_use
                          ,
                          color: Colors.white),
                      height: 20,
                      width: 100,
                    ))
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
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Column(children: [
                Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                        // ignore: deprecated_member_use
                        ,
                        color: Colors.white),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10)),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)
                          // ignore: deprecated_member_use
                          ,
                          color: Colors.white),
                      height: 20,
                      width: 100,
                    ))
              ]));
        });
  }
}
