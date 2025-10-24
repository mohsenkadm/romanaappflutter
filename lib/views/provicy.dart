import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';

class proficy extends StatefulWidget {
  const proficy({Key? key}) : super(key: key);

  @override
  _proficyState createState() => _proficyState();
}

class _proficyState extends State<proficy> {
  String proficy = "سياسة الخصوصية لتطبيق رمانـــة:\n جمع المعلومات:\n نقوم بجمع بياناتك الشخصية بشكل محدود وضروري، مثل معلومات الحساب وعناوين التوصيل، لتحسين تجربتك وضمان توفير الخدمة بشكل فعّال.\n حماية البيانات:\n نلتزم بحماية بياناتك الشخصية من الوصول غير المصرح به، ونتخذ التدابير الأمنية اللازمة للحفاظ على سرية المعلومات.\n استخدام المعلومات:\n نستخدم المعلومات لتخصيص خدماتنا وتحسين تجربتك، ولا نقوم بمشاركة أو بيع معلوماتك لأي طرف رابع دون موافقتك ( ادارة التطبيق - ادراة المتاجر - انت ) . \n التحديثات والتغييرات:\n يتم تحديث سياسة الخصوصية بشكل دوري، وسيتم إعلامك بأي تغييرات تأخذ مكانًا.\nسياسة الاستخدام:\n استخدام التطبيق:\n يجب استخدام تطبيق رمانـــة وفقًا للقوانين والأنظمة المحلية، ونحتفظ بالحق في حظر أو إيقاف حساب المستخدم في حالة مخالفة السياسة.\n تحديثات التطبيق:\n   ننصح بتحديث التطبيق بانتظام للاستمتاع بأحدث الميزات والتحسينات، ونحتفظ بحق تغيير الخدمات أو إيقافها حسب الحاجة.\n التصرف بمسؤولية : \n يجب على المستخدمين التصرف بمسؤولية أثناء استخدام التطبيق، وعدم تقديم معلومات زائفة أو إلحاق الضرر للآخرين.\nللمساعدة والدعم :\nفي حالة وجود أسئلة أو استفسارات حول سياسة الخصوصية أو سياسة الاستخدام، يرجى التواصل مع خدمة العملاء عبر التطبيق.";
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
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                  width: double.infinity,
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).secondaryHeaderColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(' سياسة الخصوصية -',
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
                       Text(
                        proficy,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 16),
                      )
                    ],
                  ),
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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "سياسة الخصوصية",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
