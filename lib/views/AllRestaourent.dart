// ignore_for_file: non_constant_identifier_names

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Constant/CategoryFill.dart';
import 'package:romanaappflutter/Constant/RestourentFill.dart';
import 'package:romanaappflutter/Controller/AllRestourentController.dart';
import 'package:romanaappflutter/Controller/CategoriesController.dart';
import 'package:romanaappflutter/Model/CategoriesModel.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/searchresandprod.dart';

class AllRestaourent extends StatefulWidget {
  const AllRestaourent({Key? key}) : super(key: key);

  @override
  _AllRestaourentState createState() => _AllRestaourentState();
}

class _AllRestaourentState extends State<AllRestaourent> {
  final AllRestourentController restourentController =
      Get.put(AllRestourentController());
  final CategoriesController categoriesController =
      Get.put(CategoriesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CategorySlide(),
              const SizedBox(
                height: 10,
              ),
              ResSlide()
            ],
          ),
        ),
        backgroundColor: Colors.white,
      );
  }

  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                color: myTheme.secondaryHeaderColor),
            child: IconButton(
                onPressed: () {
                  Get.to(const SearchResAndProd(),
                      duration: const Duration(milliseconds: 500),
                      transition: Transition.fade);
                },
                icon: Icon(Icons.search, color: myTheme.primaryColor)),
          ),
        ],
        leading: IconButton(
            onPressed: () {
              navigator?.pop();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "القسم",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }

  Container ResSlide() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Obx(
        () => restourentController.islodedGetAll.value
            ? const GetShimmerResAll()
            : Builder(
                builder: (context) {
                  final cols =
                      MediaQuery.of(context).size.width < 600 ? 2 : 3;
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: restourentController.itemsresAll.length,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.88,
                    ),
                    itemBuilder: (context, index) {
                      return FillResData(
                          items:
                              restourentController.itemsresAll[index]);
                    },
                  );
                },
              ),
      ),
    );
  }

  Container CategorySlide() {
    return Container(
      height: 100,
      child: Obx(() => categoriesController.isloded.value
          ? const GetShimmercategories()
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: categoriesController.itemscategories.length,
              itemBuilder: (context, index) {
                return FillCategoryAll(categoriesController: categoriesController, restourentController: restourentController,items: categoriesController.itemscategories[index]);
              },
            )),
    );
  }
}

class FillCategoryAll extends StatelessWidget {
  const FillCategoryAll({
    Key? key,
    required this.categoriesController,
    required this.restourentController,
    required this.items, 
  }) : super(key: key);

  final CategoriesController categoriesController;
  final AllRestourentController restourentController;
  
  final CategoriesModel items; 
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var id =
            items.CategoriesId;
             restourentController.ChooseCategory(id);
            },
      child: Container(
        width: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
        ),
        margin: const EdgeInsets.symmetric(
            horizontal: 5, vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: CachedNetworkImage(height: 48, width: 48,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                  imageUrl: items.CategoriesImages),
            ),
            const SizedBox(height: 4),
            Text(
                items.CategoriesName,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontFamily: "Tajawal", fontSize: 11, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
