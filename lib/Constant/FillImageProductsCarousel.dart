
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:romanaappflutter/Model/CarouselModel.dart';
import 'package:romanaappflutter/Model/ImagesModel.dart';
import 'package:url_launcher/url_launcher.dart';

class FillImageProductsCarousel extends StatelessWidget {
  const FillImageProductsCarousel({
    Key? key,
    required this.item,
  }) : super(key: key);

  final ImagesModel item;

  @override
  Widget build(BuildContext context) {
    return InkWell( onTap: () async {
      final Uri url = Uri.parse(item.imagePath!);
   if (!await launchUrl(url)) { 
    }
    },
      child: ClipRRect(
       borderRadius:  BorderRadius.circular(15.0),
       child:
       CachedNetworkImage( 
      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
         errorWidget: (context, url, error) => const Icon(Icons.error),
         imageUrl: item.imagePath!
       ),
              ),
    );
  }
}
 