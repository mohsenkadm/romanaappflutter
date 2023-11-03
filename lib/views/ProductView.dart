import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/ProductController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/shoppingcart.dart';
import 'package:shimmer/shimmer.dart';

class ProductView extends StatefulWidget {
  const ProductView({ Key? key }) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final ProductController _controller=Get.put(ProductController());
  @override
  
   Widget build(BuildContext context) {
     return MaterialApp( 
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
                Obx(() => 
             !_controller.isloded.value?
             Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(children: [
                  Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)
                          // ignore: deprecated_member_use
                          ,
                          color: Theme.of(context).backgroundColor),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10)),
                  ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15)
                            // ignore: deprecated_member_use
                            ,
                            color: Theme.of(context).backgroundColor),
                        height: 20,
                        width: 100,
                      ))
                ])
                )
               :   
                Column(
                  children: [
                    CachedNetworkImage(
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      imageUrl: 'https://source.unsplash.com/user/c_v_r/500x200'),
                   Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "اسم المطعم",
                        style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          imageUrl:
                              'https://source.unsplash.com/user/c_v_r/100x100',
                          width: 80,
                          height: 80,
                        )),
                  ],
                ),
              ),
                  Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "الحد الادنى للطلب  " + '500' + " د.ع ",
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 10),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'address',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 10),
                            ),
                            const Icon(
                              Icons.location_on,
                              size: 15,
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text('name', textAlign: TextAlign.right),
                        Text('minm', textAlign: TextAlign.right)
                      ],
                    ),
                  ],
                ),
              ),
               Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "اسم المادة", 
                        style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor),
                      ),
                    ), 

               Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "تفاصيل المادة", 
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColor),
                      ),
                    ), 
              ],
                ),
             
             ),
            
                Center(
                                                          child: Expanded(
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      70),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          20.0),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(35),
                                                                            color: myTheme.secondaryHeaderColor),
                                                                        child: IconButton(
                                                                            onPressed: () {
                                                                              ListItemCard.itemscard[1].count -= 1;
                                                                              ListItemCard.itemscard[1].total = ListItemCard.itemscard[1].count * ListItemCard.itemscard[1].price;
                                                                            // controller.SumPrice();
                                                                             if (ListItemCard.itemscard[1].count == 0) {
                                                                                AwesomeDialog(
                                                                                        buttonsBorderRadius: const BorderRadius.all(Radius.circular(5)),
                                                                                        context: context,
                                                                                        dialogType: DialogType.warning,
                                                                                        headerAnimationLoop: true,
                                                                                        animType: AnimType.bottomSlide,
                                                                                        title: 'حذف المنتج',
                                                                                        reverseBtnOrder: true,
                                                                                        showCloseIcon: true,
                                                                                        btnOkText: 'نعم',
                                                                                        btnCancelText: 'الغاء',
                                                                                        btnOkIcon: Icons.check_circle,
                                                                                        btnCancelIcon: Icons.cancel,
                                                                                        btnOkOnPress: () {
                                                                                          ListItemCard.itemscard.removeAt(1);
                                                                                         // controller.update();
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        btnCancelOnPress: () {
                                                                                         ListItemCard.itemscard[1].count += 1;
                                                                                         // controller.update();
                                                                                        },
                                                                                        desc: 'هل تريد حذف المنتج حقا؟')
                                                                                    .show();
                                                                              } else {
                                                                              //  controller.update();
                                                                              }
                                                                            },
                                                                            tooltip: "نقصان المنتج",
                                                                            icon: Icon(Icons.remove, size: 25, color: myTheme.primaryColor)),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: Container(
                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: myTheme.secondaryHeaderColor),
                                                                        child: Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 15),
                                                                          child:
                                                                              Text('9',
                                                                            textAlign: TextAlign.center,
                                                                            style: const TextStyle(fontSize: 14),
                                                                          ),
                                                                        )),
                                                                  ),
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          20.0),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(35),
                                                                            color: myTheme.secondaryHeaderColor),
                                                                        child: IconButton(
                                                                            onPressed: () {
                                                                               },
                                                                            tooltip: "زيادة المنتج",
                                                                            icon: Icon(Icons.add, size: 25, color: myTheme.primaryColor)),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          ' د.ع ' ,
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                         Align(
                                                              alignment: Alignment.centerRight,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets.symmetric(horizontal: 15.0),
                                                                child: Text(
                                                                  'ملاحظة',
                                                                  textAlign: TextAlign.right,
                                                                  style: TextStyle(
                                                                      fontSize: 20,
                                                                      color: Theme.of(context).primaryColor),
                                                                ),
                                                              ),
                                                            ),
                                                             Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .secondaryHeaderColor, // Set your desired background color here
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Optional: Add rounded corners
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                width: double.infinity,
                                child: TextField( 
                                    decoration: const InputDecoration(
                                      hintTextDirection: TextDirection.rtl,
                                      hintText: 'ملاحظة',
                                      contentPadding: EdgeInsets.all(15),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    )),
                              ),
                                                        const SizedBox(height: 20,),
                                                        ElevatedButton.icon(
                              onPressed: () => {
                                    
                                  },
                              icon: const Icon(Icons.shopping_cart_checkout),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myTheme.primaryColor),
                              label: const Text(
                                'اضافة الي السلة',
                                style: TextStyle(fontSize: 18),
                              )),
                                                     
              ],
          ),
        ),
      ),
    );
   }
    AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(   elevation: 0, 
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title:  Text("تفاصيل المنتج",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),
            ),
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
      ],  
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor)),
    );
  }
}