import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  _AboutAppState createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: MyAppBar(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).secondaryHeaderColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('عن رمانــة',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(color: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'تطبيق رمانة يقدم لك تجربة تسوق وتوصيل فريدة، حيث يمكنك اكتشاف مطاعم ومتاجر جديدة والاستمتاع بوجبات لذيذة والحصول على مستلزماتك اليومية بسهولة، كل ذلك من خلال خطوات بسيطة على هاتفك. مع رمانة، يمكنك الاستفادة من العروض والخصومات الحصرية على مختلف المطاعم والمتاجر، والاستمتاع بخيارات متنوعة وخدمة توصيل موثوقة وسريعة. كما يتيح لك التطبيق تقييم المطاعم وخدمات التوصيل ومشاركة تجربتك، مما يساعد على تحسين جودة الخدمة وتقديم تجربة أفضل للمستخدمين في جميع أنحاء العراق. اكتشف تجربة التسوق والتوصيل بطريقة أسهل وأكثر راحة مع رمانة.',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16, height: 1.6),
                      ),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ));
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
        leading: IconButton(
            onPressed: () {
              navigator?.pop();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "عن رمانــة",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
