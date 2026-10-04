
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';
import 'package:url_launcher/url_launcher.dart';

class AddRes extends StatefulWidget {
  const AddRes({Key? key}) : super(key: key);

  @override
  _AddResState createState() => _AddResState();
}

class _AddResState extends State<AddRes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 300,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).secondaryHeaderColor),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "سعيدون جداً بأضافة متجركم على تطبيقنا ، حيث يقدم تطبيقنا خدمات مميزة منها عرض منتجاتكم في التطبيق والتحكم فيها وكذلك توفير خدمة توصيل لكافة محافظات العراق . "+

"يمكنكم التواصل عبر الظغط هنا ." ,
                    textAlign: TextAlign.center,
                  ),
                 const SizedBox(height: 15,),
                  Center(
                    child: ElevatedButton.icon(
                        onPressed: () async {
                          Uri url = Uri();
                          // if (Platform.isAndroid) {
                          //   url = Uri.parse(
                          //       "https://play.google.com/store/apps/details?id=com.alaman.rummanaflutterforres");
                          // } else {
                          //   url = Uri.parse(
                          //     "https://apps.apple.com/jo/app/رمانة-مطاعم/id6475269008",
                          //   );
                          // }
                             url = Uri.parse("https://wa.me/9647850047002");
                         
                          if (!await launchUrl(url)) {}
                        },
                        icon: const Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 16,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: myTheme.primaryColor),
                        label: const Text(
                            'تواصل معنا',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.white),
                          )),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
          ),
        ),
      );
  }

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
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "اضافة متجر",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
