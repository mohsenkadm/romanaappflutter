import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:romanaappflutter/Constant/FillImageCarousel.dart';
import 'package:romanaappflutter/Constant/RestourentFill.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/Controller/CategoriesController.dart';
import 'package:romanaappflutter/Controller/MainController.dart';
import 'package:romanaappflutter/Controller/RestourentController.dart';
import 'package:romanaappflutter/views/LastOrderView.dart';
import 'package:shimmer/shimmer.dart'; 

// ignore: camel_case_types
class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);
  @override
  State<homepage> createState() => _homepageState();
}

// ignore: camel_case_types
class _homepageState extends State<homepage> with SingleTickerProviderStateMixin {
  var position;
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Widget _buildAnimatedSection(int index, Widget child) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.15),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: _animController,
        curve: Interval(
          (index * 0.12).clamp(0.0, 0.7),
          ((index * 0.12) + 0.4).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic,
        ),
      )),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
          parent: _animController,
          curve: Interval(
            (index * 0.12).clamp(0.0, 0.7),
            ((index * 0.12) + 0.4).clamp(0.0, 1.0),
            curve: Curves.easeOut,
          ),
        )),
        child: child,
      ),
    );
  }

  final MainController mainController = Get.put(MainController());
  final CategoriesController categoriesController =
      Get.put(CategoriesController());
  final RestourentController restourentController =
      Get.put(RestourentController());
  final determinePositionLocation locationService = Get.find();
  @override
  Widget build(BuildContext context) {
    return 
     RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async{
        await  mainController.fetchDataCarousel();
          await categoriesController.fetchData();
         await restourentController.fetchDataTop();
         await restourentController.fetchDataGetAll(); 
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            _buildAnimatedSection(0, CarouselSlide()),
            _buildAnimatedSection(1, _buildLastOrdersButton(context)),
            _buildAnimatedSection(2, Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: _sectionHeader(context, 'home.favorite_stores'.tr, Icons.favorite_rounded),
            )),
            _buildAnimatedSection(3, ResSlide()),
            _buildAnimatedSection(4, Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: _sectionHeader(context, 'home.all_stores'.tr, Icons.store_rounded),
            )),
            ResSlideAll(),
            const SizedBox(height: 20),
          ]),
        ),
      );
    
  }

  Widget _sectionHeader(BuildContext context, String title, IconData icon) {
    final primary = Theme.of(context).primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(title,
            textAlign: TextAlign.right,
            style: GoogleFonts.cairo(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Colors.grey[850])),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: primary, size: 18),
        ),
      ],
    );
  }

  // "آخر طلباتي" button (replaces removed Categories section)
  Widget _buildLastOrdersButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Get.to(const LastOrderView(),
              duration: const Duration(milliseconds: 500),
              transition: Transition.rightToLeftWithFade);
        },
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withOpacity(0.78),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).primaryColor.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.receipt_long_rounded,
                    color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'home.last_orders'.tr,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: "Tajawal",
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.chevron_left_rounded,
                  color: Colors.white, size: 26),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox ResSlide() {
    return SizedBox(
      height: 314,
      child: Obx(
        () => restourentController.isloded.value
            ? const GetShimmerRes()
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: restourentController.itemsres.length,
                itemBuilder: (context, index) {
                  return FillResDataForTop(
                      items: restourentController.itemsres[index],
                      index: index);
                },
              ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  SizedBox ResSlideAll() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Obx(
          () => restourentController.islodedGetAll.value
              ? const GetShimmerResAll()
              : restourentController.itemsresAll.isEmpty
                  ? SizedBox(
                      child: Container(
                        height: 200,
                        width: 150,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Icon(
                              Icons.error,
                              size: 60,
                              color: Colors.red[400],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Text(
                              'لا توجد بيانات',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        final cols =
                            MediaQuery.of(context).size.width < 600 ? 2 : 3;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                restourentController.itemsresAll.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: cols,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.88,
                            ),
                            itemBuilder: (context, index) {
                              return FillResData(
                                  items: restourentController
                                      .itemsresAll[index],
                                  index: index);
                            },
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
    
  }

  // ignore: non_constant_identifier_names
  Padding CarouselSlide() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          Stack(
            children: [
              Obx(
                () => mainController.isloded.value
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(18.0),
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white),
                              height: 180,
                              width: double.infinity,
                            )),
                      )
                    : mainController.itemsCarousel.isEmpty
                        ? Center(
                            child: Container(
                              width: 150,
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.error,
                                    size: 60,
                                    color: Colors.red[400],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    'لا توجد بيانات',
                                    style: TextStyle(fontSize: 18),
                                  )
                                ],
                              ),
                            ),
                          )
                        : CarouselSlider.builder(
                            itemCount: mainController.itemsCarousel.length,
                            itemBuilder: (context, index, realIndex) {
                              return FillImageCarousel(
                                  item: mainController.itemsCarousel[index]);
                            },
                            options: CarouselOptions(
                                scrollPhysics: const BouncingScrollPhysics(),
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 2,
                                viewportFraction: 1,
                                onPageChanged: (index, reason) {
                                  mainController.onPageChanged(index);
                                }),
                          ),
              ),
              Obx(
                () => Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: mainController.itemsCarousel
                          .asMap()
                          .entries
                          .map((entry) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                            width:
                                mainController.currentIndex.value == entry.key
                                    ? 20
                                    : 7,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: mainController.currentIndex.value ==
                                        entry.key
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[400]),
                        );
                      }).toList(),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
