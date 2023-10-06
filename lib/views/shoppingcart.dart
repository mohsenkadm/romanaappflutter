 import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';  
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ListItemCard.dart';
import 'package:romanaappflutter/Controller/ShoppingCardController.dart';
import 'package:romanaappflutter/Model/OrderDetailModel.dart';
import 'package:romanaappflutter/main.dart'; 
import 'package:awesome_dialog/awesome_dialog.dart';
// ignore: camel_case_types
class shoppingcard extends StatefulWidget {
  const shoppingcard({Key? key}) : super(key: key);

  @override
  State<shoppingcard> createState() => _shoppingcard();
}
// ignore: camel_case_types
class _shoppingcard extends State<shoppingcard> {  
    final ShoppingCardController _controller=Get.put(ShoppingCardController());
   @override
  Widget build(BuildContext context) {
    return MaterialApp( 
        theme:myTheme,
      debugShowCheckedModeBanner: false,
      home:  Scaffold( 
        appBar: MyAppBar(),
            body:  Obx(() => 
          ListItemCard.itemscard.isEmpty?
               Center(
                 child: Container(
                  height: 150,width: 150,
                  padding:const EdgeInsets.all(10),
                   child: Column(children: [
                    Icon(Icons.production_quantity_limits,size: 100,color: myTheme.primaryColor,),
                   const Text('لا توجد منتجات في السلة')
                   ],
                   ),
                 ),
               ): 
                    Column(
              children: [  
                Expanded( 
                  child: ListView.builder(
                      itemCount: ListItemCard.itemscard.length,
                      itemBuilder: (context, index) {
                         return FillShoppingCardData(items: ListItemCard.itemscard[index]); 
                      },
                    ), 
                ), 
                 Container(  
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(10),
                   decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15) ),
                child: Column(
                  children: [ 
                    ListTile(
                      trailing:Container( 
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35)
                              ,color: myTheme.secondaryHeaderColor),
                            child: Icon(Icons.attach_money,size: 30,color: myTheme.primaryColor) 
                           ),
                      title: Text('مجموع الطلب',textAlign: TextAlign.right,style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 16,),),
                          leading: Text(' د.ع '+_controller.totalprice.toString() ,textAlign: TextAlign.right,style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 16,),),
                    ),
                     ListTile(
                      trailing:Container( 
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35)
                              ,color: myTheme.secondaryHeaderColor),
                            child: Icon(Icons.attach_money,size: 30,color: myTheme.primaryColor) 
                           ),
                      title: Text('الخصم',textAlign: TextAlign.right,style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 16,),),
                          leading: Text(' د.ع '+_controller.discount.toString() ,textAlign: TextAlign.right,style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 16,),),
                    ),
                     ListTile(
                      trailing:Container( 
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35)
                              ,color: myTheme.secondaryHeaderColor),
                            child: Icon(Icons.currency_exchange,size: 30,color: myTheme.primaryColor) 
                           ),
                      title: Text('المبلغ الكلي',textAlign: TextAlign.right,style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 16,),),
                          leading: Text(' د.ع '+_controller.netAmount.toString() ,textAlign: TextAlign.right,style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 16,),),
                    ),
                    ElevatedButton.icon(onPressed: ()=>{
                    }, icon:const Icon(Icons.shopping_cart_checkout), 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myTheme.primaryColor
                    ),
                    label:const Text('انهاء الطلب',style: TextStyle(fontSize: 18),
                    )
                    ),
                  ],
                ),
                )
              ],
             ),
            ),
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
}
 
  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    return AppBar(  
      actions:  <Widget>[
         Container(
         margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 4),
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color: myTheme.secondaryHeaderColor),
          child: IconButton(onPressed: (){
            AwesomeDialog(
              buttonsBorderRadius:BorderRadius.all(Radius.circular(5)) ,
                      context: context,
                      dialogType: DialogType.warning,
                      headerAnimationLoop: true,
                      animType: AnimType.bottomSlide,
                      title: 'حذف السلة',
                      reverseBtnOrder: true,
                      showCloseIcon: true,
                      btnOkText: 'نعم',
                      btnCancelText: 'الغاء',
                      btnOkIcon: Icons.check_circle,
                      btnCancelIcon: Icons.cancel,
                      btnOkOnPress: () { 
                      _controller.ClearCard();
                      },
                      btnCancelOnPress: () {},
                      desc:'هل تريد حذف السلة حقا؟'
                    ).show();
          },
          tooltip: "حذف السلة",
          icon: Icon(Icons.remove_shopping_cart,size: 30,color: myTheme.primaryColor)
          ),
        ),
      ],
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon:  Icon(Icons.arrow_back_ios,color: myTheme.primaryColor)),
          elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title: const Text("سلة الطلب",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.teal),
            )
          );
  }
}

  

class FillShoppingCardData extends StatelessWidget {
   FillShoppingCardData({
    Key? key,
    required this.items, 
  }) :  super(key: key);

  final OrderDetailModel items; 
  final RxInt count=0.obs;
 
  @override
  Widget build(BuildContext context) {
    return 
    Container( 
      decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15)
            ,color: Theme.of(context).secondaryHeaderColor),
      margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
      padding: const EdgeInsets.all(0), 
      child: ListTile(
       title:  Text(items.productsName,textAlign: TextAlign.right,style: TextStyle(
                        color: Theme.of(context).primaryColor,fontSize: 16,
                        fontWeight: FontWeight.bold),),
      
      subtitle: 
      Padding(
        padding: const EdgeInsets.fromLTRB(3, 4, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(items.price.toString()+" د.ع ",textAlign: TextAlign.right,style: TextStyle(
                          color: Theme.of(context).primaryColor,fontSize: 14),),
            TextButton(onPressed: () => {
              showBottomSheet(context: context, builder: (context) 
              => Container(
                 decoration: BoxDecoration(
                   boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Colors.black54,
                                blurRadius: 15.0,
                                offset: Offset(0.0, 0.75)
                            )
                          ],
                  borderRadius: BorderRadius.circular(35)
                  ,color: Colors.white),
                height: 400,
                child: Column(children: [
                 const SizedBox(height: 20,),
                 Align( alignment: Alignment.topRight,
                   child: Padding(
                     padding: const EdgeInsets.all(10.0),
                     child: Text(items.productsName,style: TextStyle(
                            color: Theme.of(context).primaryColor,fontSize: 16,
                            fontWeight: FontWeight.bold),),
                   ),
                 ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding( 
                    padding:const EdgeInsets.all(10),
                    child: Text(items.productsDetails,style: TextStyle(
                        color: Theme.of(context).primaryColor,fontSize: 16),),
                  ),
                ),
                Center(
                  child: Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [ 
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container( 
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35)
                              ,color: myTheme.secondaryHeaderColor),
                            child: IconButton(onPressed: (){  
                             count.value-=1;
                            }, 
                            tooltip: "نقصان المنتج",
                            icon: Icon(Icons.remove,size: 25,color: myTheme.primaryColor)
                            ),
                                              ),
                          ),
                        )
,                       Expanded( flex: 1,
                         child: Container(   
                             decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35)
                            ,color: myTheme.secondaryHeaderColor), 
                              child:  Padding(
                                padding:const EdgeInsets.symmetric(vertical: 15),
                                child: Text(items.count.toString(),textAlign: TextAlign.center,style: TextStyle(fontSize: 14),),
                              )
                            ),
                       ),
                       Expanded( flex: 1,
                         child: Padding(
                           padding: const EdgeInsets.all(20.0),
                           child: Container(  
                             decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35)
                            ,color: myTheme.secondaryHeaderColor),
                                             child: IconButton(onPressed: (){  
                                               count.value+=1;
                                             }, 
                                             tooltip: "زيادة المنتج",
                                             icon: Icon(Icons.add,size: 25,color: myTheme.primaryColor)
                                             ),
                                           ),
                         ),
                       )
                      ],),
                    ),
                  ),
                ),
                Text(' د.ع '+'1',textAlign: TextAlign.right,style: TextStyle(
                            color: Theme.of(context).primaryColor,fontSize: 18,
                            fontWeight: FontWeight.bold),
                            ),
                ElevatedButton.icon(onPressed: ()=>{
                      items.count=count.value
                    }, icon:const Icon(Icons.edit), 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myTheme.primaryColor
                    ),
                    label:const Text('تحديث الكمية',style: TextStyle(fontSize: 18),
                    )
                    )
              ],),) )
            },
              child: Container(
                padding:const EdgeInsets.all(4),
                 decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5)
            ,color: myTheme.secondaryHeaderColor),
                child: Text(items.count.toString()+" الكمية ",textAlign: TextAlign.right,style: TextStyle(
                              color: Theme.of(context).primaryColor,fontSize: 14),),
              ),
            ),
          ],
        ),
      ),
      trailing:  ClipRRect(
                  borderRadius:  const BorderRadius.all(Radius.circular(15)),
            child: CachedNetworkImage( 
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
         errorWidget: (context, url, error) => const Icon(Icons.error,color: Colors.red,),
         imageUrl: items.productsImage
       ),
              ),   
        leading: Container( 
           decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35)
            ,color: myTheme.secondaryHeaderColor),
          child: IconButton(onPressed: (){  
          }, 
          tooltip: "حذف المنتج",
          icon: Icon(Icons.clear,size: 25,color: myTheme.primaryColor)
          ),
        ) ,
      )
      
      );
  }
}


// class GetShimmer extends StatelessWidget {
//   const GetShimmer({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: 10,
//       itemBuilder: (context,index){
//       return Shimmer.fromColors(  
//       baseColor: Colors.grey[300]!,
//      highlightColor: Colors.grey[100]!,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//                Column(
//                   children: [
//                      Container( 
//         margin:const EdgeInsets.all(5),
//         height: 20,width: 200,decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15)
//                 // ignore: deprecated_member_use
//                 ,color: Theme.of(context).backgroundColor),),
//                      Container( 
//         margin:const EdgeInsets.all(5),
//         height: 20,width: 200,decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15)
//                 // ignore: deprecated_member_use
//                 ,color: Theme.of(context).backgroundColor),), 
//                      Container( 
//         margin:const EdgeInsets.all(5),
//         height: 20,width: 200,decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15)
//                 // ignore: deprecated_member_use
//                 ,color: Theme.of(context).backgroundColor),)
//                   ],
//                 ),
//                  Container( 
//         margin:const EdgeInsets.all(5),
//         height: 100,width: 100,decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15)
//                 // ignore: deprecated_member_use
//                 ,color: Theme.of(context).backgroundColor),),
           
//         ],
//       )
                      
      
//     );

//     });
//   }
// }
 