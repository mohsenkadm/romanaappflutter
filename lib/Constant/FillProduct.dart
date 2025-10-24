
  import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/ErrorMessage.dart';
import 'package:romanaappflutter/Model/ProductsModel.dart';
import 'package:romanaappflutter/views/ProductView.dart';

class FillProduct extends StatelessWidget {
const FillProduct({
    Key? key,
    required this.items, 
  }) : super(key: key);

  final ProductsModel items; 
  @override
  Widget build(BuildContext context){
       return InkWell(
        
      onTap: () { 
        if (!items.IsFree!) {
          ErrorMessage.SnackMessage(
              "غير متوفر حاليا الان يمكنك الطلب لاحقا", Colors.red[400]!);
          return;
        }
        Get.to(()=>const ProductView(),arguments:[items.ProductsId.toString()],
          duration: const Duration(milliseconds: 500),
          transition: Transition.fade);
          },
      child: Container(
        margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: items.IsFree!? Colors.white: Theme.of(context).secondaryHeaderColor),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [ 
              ListTile(
                isThreeLine: false,
                title: Text(
                  items.ProductsName??'',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
               
                leading: Column(
                  children: [
                    Text(
                      "${items.ProductsPrice} د.ع ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 16),
                    ),
                   
                  ],
                ),
                trailing: SizedBox(
                  width: 60,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5)),
                    child: CachedNetworkImage(
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                      imageUrl:items.productsImageFirst==null?'': items.productsImageFirst! ,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(
                height: 10,
              )
              
            ],
          ),
        ),
      ),
    );
  
  }
}
 
