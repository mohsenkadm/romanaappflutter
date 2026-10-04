import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onboarding/onboarding.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/MainApp.dart'; 

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  late ElevatedButton materialButton;
  late int index;
  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Image.asset('assets/images/onbourding1.JPG'
              ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Image.asset('assets/images/onbourding2.JPG',
                 ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Image.asset('assets/images/onbourding3.JPG',
                ),
            ],
          ),
        ),
      ),
    ),
  PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Image.asset('assets/images/onbourding4.JPG',
                ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  ElevatedButton _skipButton({void Function(int)? setIndex}) {
    return   ElevatedButton( child: const Text('تخطي',style:TextStyle(fontSize: 18, color: Colors.white)
    ,),onPressed: ()=>{ 
          if (setIndex != null) {
          index = 3,
          setIndex(3)
        }
         }, style: ElevatedButton.styleFrom(
                backgroundColor: myTheme.primaryColor
              ),  
         );
  }

  void _completeOnboarding() {
    GetStorage().write('initScreen', 1);
    Get.offAll(() => const MainApp());
  }

  ElevatedButton get _signupButton {
    return ElevatedButton(onPressed: _completeOnboarding, style: ElevatedButton.styleFrom(
                backgroundColor: myTheme.primaryColor
              ),  child: const Text('دخول',style:TextStyle(fontSize: 18, color: Colors.white))
         );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: const Color.fromRGBO(194, 53, 51, 1),
          child: SafeArea( 
            child: Onboarding(
              pages: onboardingPagesList,
              onPageChange: (int pageIndex) {
                index = pageIndex;
              },
              startPageIndex: 0,
              footerBuilder: (context, dragDistance, pagesLength, setIndex) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      width: 0.0,
                      color: Colors.transparent,
                    ),
                  ),
                  child: ColoredBox(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 45,vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomIndicator(
                            netDragPercent: dragDistance,
                            pagesLength: pagesLength,
                           indicator: Indicator(
                              indicatorDesign: IndicatorDesign.polygon(
                                polygonDesign: PolygonDesign(
                                  polygon: DesignType.polygon_diamond,
                                ),
                              ),
                            ),
                          ),
                          index == pagesLength - 1
                              ? _signupButton
                              : _skipButton(setIndex: setIndex)
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      
    );
  }
}