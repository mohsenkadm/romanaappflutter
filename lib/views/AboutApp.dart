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
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
                      Text(' عن رمانـــــة -',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).primaryColor)),
                      const SizedBox(
                        height: 10,
                      ),
                      const Divider(color: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'تطبيق "رمانـــة " هو متجر إلكتروني شامل يوفر للمستخدم تجربة تسوق سهلة وممتعة. يتضمن التطبيق أقسام متنوعة تشمل الإلكترونيات، الأجهزة الكهربائية، الهواتف المحمولة، الاكسسوارات، الأزياء، العطور، المكياج، المنتجات الصحية، القرطاسية، الهدايا، أدوات المطبخ، والألعاب ، الخ .. بفضل تشكيلته الواسعة والمتنوعة، يمكن للمستخدمين العثور على كل ما يحتاجونه بسهولة وبضغطة زر واحدة .',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        'يتميز تطبيق "رمانـــة " أيضًا بخدمة التوصيل السريعة حيث يقدم خدمة توصيل الطلبات في أقل من 24 ساعة، مما يسهل على المستخدمين الحصول على مشترياتهم بسرعة وفعالية، مما يجعل عملية التسوق أكثر سهولة وراحة.',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'تطبيق "رمانـــة " يوفر أيضًا خدمة الإشعارات التفاعلية، حيث يمكن للمستخدمين الاطلاع على آخر العروض والتخفيضات والمنتجات الجديدة عبر الإشعارات المباشرة. هذه الخدمة تساعد المستخدمين على البقاء متصلين بآخر التحديثات والأخبار حول منتجاتهم المفضلة دون الحاجة إلى البحث عنها بشكل دائم . ',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'يعمل تطبيق "رمانــــة " كمنصة شاملة تتيح لأصحاب المتاجر إضافة متاجرهم بسهولة والتحكم فيها من خلال لوحة تحكم مميزة. يمكنهم أيضًا الاستفادة من خدمة التوصيل لمتاجرهم، مما يجعل تجربة التسوق للعملاء أكثر يسرًا ويسهولة، وبالتالي زيادة عمليات الشراء لديهم. هذه الميزة تعزز التواجد الرقمي لأصحاب المتاجر وتعمل على تعزيز نجاح أعمالهم في عالم التجارة الإلكترونية.',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16),
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
          )),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
        elevation: 2,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          "عن تطبيق رمانة",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
