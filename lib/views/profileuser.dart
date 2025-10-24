import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/ProfileuserController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/Accounts.dart';
import 'package:romanaappflutter/views/AddRes.dart';
import 'package:romanaappflutter/views/RegisterUser.dart';
import 'package:romanaappflutter/views/login.dart';
import 'package:romanaappflutter/views/provicy.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AboutApp.dart';

class Profileuser extends StatefulWidget {
  const Profileuser({Key? key}) : super(key: key);

  @override
  _ProfileuserState createState() => _ProfileuserState();
}

class _ProfileuserState extends State<Profileuser> {
  final ProfileuserController _controller = Get.put(ProfileuserController());
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => _controller.fetchData(),
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Obx(
              () => _controller.user.value == null
                  ? Column(
                    children: [
                      TextButton(
                        onPressed: () => {
                            Get.to(const Login(),
                        duration: const Duration(milliseconds: 500),
                        transition: Transition.fade)
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(5,10,5,0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).secondaryHeaderColor),
                            child: ListTile(
                               title: const Text(
                                'تسجيل دخول',
                                textAlign: TextAlign.right,
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: Theme.of(context).secondaryHeaderColor),
                                child: Icon(Icons.login,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                      ),
                      TextButton(
                        onPressed: () => {
                            Get.to(const RegisterUser(),
                        duration: const Duration(milliseconds: 500),
                        transition: Transition.fade)
                        },
                        child: Container(
                            margin: const EdgeInsets.fromLTRB(5,0,5,0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Theme.of(context).secondaryHeaderColor),
                            child: ListTile(
                               title: const Text(
                                'تسجيل حساب جديد',
                                textAlign: TextAlign.right,
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(35),
                                    color: Theme.of(context).secondaryHeaderColor),
                                child: Icon(Icons.person,
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                      ),
                    ],
                  )
                  : Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Theme.of(context).secondaryHeaderColor),
                      child: ListTile(
                        trailing: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Theme.of(context).secondaryHeaderColor),
                          child: Icon(Icons.person,
                              color: Theme.of(context).primaryColor),
                        ),
                        title: Text(
                          _controller.user.value!.Name,
                          textAlign: TextAlign.right,
                        ),
                        subtitle: Text(_controller.user.value!.Phone,
                            textAlign: TextAlign.right),
                      leading:  SizedBox(
                        height: 50,
                  width: 100,
                        child: Row(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 4),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: myTheme.primaryColor),
                              child: IconButton(
                                  onPressed: () async {
                                    Get.to(() => const RegisterUser(),
                                        arguments: [_controller.user.value!.userId],
                                        duration: const Duration(milliseconds: 500),
                                        transition: Transition.fade);
                                  },
                                  icon: const Icon(Icons.edit,
                                      size: 18, color: Colors.white)),
                            ),
                               Container(
                          height: 35,
                          width: 35,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: myTheme.primaryColor),
                          child: IconButton(
                              onPressed: () async {
                                AwesomeDialog(
                                        buttonsBorderRadius: const BorderRadius.all(
                                            Radius.circular(5)),
                                        context: context,
                                        dialogType: DialogType.warning,
                                        headerAnimationLoop: true,
                                        animType: AnimType.bottomSlide,
                                        title: 'تسجيل خروج ',
                                        reverseBtnOrder: true,
                                        showCloseIcon: true,
                                        btnOkText: 'نعم',
                                        btnCancelText: 'الغاء',
                                        btnOkIcon: Icons.check_circle,
                                        btnCancelIcon: Icons.cancel,
                                        btnOkOnPress: () { 
                                       _controller.deleteuser(id: _controller.user.value!.userId);
                                        },
                                        btnCancelOnPress: () {},
                                        desc: 'هل تريد الخروج من الحساب حقا؟')
                                    .show();
                              },
                              icon: const Icon(Icons.logout,
                                  size: 18, color: Colors.white)),
                        ),
                                           
                          ],
                        ),
                      ),
                      ),
                    ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).secondaryHeaderColor),
              child: ListTile(
                trailing: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Theme.of(context).secondaryHeaderColor),
                  child: Icon(Icons.notifications_active,
                      color: Theme.of(context).primaryColor),
                ),
                title: const Text(
                  'الاشعارات',
                  textAlign: TextAlign.right,
                ),
                subtitle:
                    const Text('تفعيل الاشعارات', textAlign: TextAlign.right),
                leading: Obx(
                  () => Switch(
                    onChanged: (value) {
                      _controller.toggle();
                    },
                    value: _controller.togglenotification.value,
                  ),
                ),
              ),
            ),
            //  TextButton(
            //    onPressed: () {  },
            //    child: Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0),
            //               decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(15),
            //     color: Theme.of(context).secondaryHeaderColor)
            //              ,child: ListTile(
            //              trailing: Container(
            //     padding: const EdgeInsets.all(10),
            //              decoration: BoxDecoration(
            //              borderRadius: BorderRadius.circular(35)
            //              ,color:Theme.of(context).secondaryHeaderColor),
            //            child: Icon(Icons.message,color: Theme.of(context).primaryColor
            //            ),
            //          ),
            //              title: const Text('تواصل معنا',textAlign: TextAlign.right,)
            //          )
            //              ,),
            //  ),
            TextButton(
              onPressed: () {
                if (Platform.isAndroid || Platform.isIOS) {
                  final url = Uri.parse(
                      "https://play.google.com/store/apps/details?id=com.alaman.romanaappflutter");
                  final urlapple = Uri.parse(
                    "https://apps.apple.com/us/app/rummana-%D8%B1%D9%85%D8%A7%D9%86%D8%A9/id6471382620",
                  );
                  Share.share(
                      'حمل التطبيق الان على اب ستور: \n $urlapple \n حمل التطبيق الان على كوكل بلي \n $url');
                }
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).secondaryHeaderColor),
                child: ListTile(
                    trailing: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context).secondaryHeaderColor),
                      child: Icon(Icons.share,
                          color: Theme.of(context).primaryColor),
                    ),
                    title: const Text(
                      'مشاركة التطبيق',
                      textAlign: TextAlign.right,
                    )),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(const AboutApp(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).secondaryHeaderColor),
                child: ListTile(
                    trailing: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context).secondaryHeaderColor),
                      child: Icon(Icons.info,
                          color: Theme.of(context).primaryColor),
                    ),
                    title: const Text(
                      'عن تطبيق رمانة',
                      textAlign: TextAlign.right,
                    )),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.to(const Accounts(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).secondaryHeaderColor),
                child: ListTile(
                    trailing: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context).secondaryHeaderColor),
                      child: Icon(Icons.public,
                          color: Theme.of(context).primaryColor),
                    ),
                    title: const Text(
                      'حساباتنا',
                      textAlign: TextAlign.right,
                    )),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     Get.to(const AddRes(),
            //         duration: const Duration(milliseconds: 500),
            //         transition: Transition.fade);
            //   },
            //   child: Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(15),
            //         color: Theme.of(context).secondaryHeaderColor),
            //     child: ListTile(
            //         trailing: Container(
            //           padding: const EdgeInsets.all(10),
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(35),
            //               color: Theme.of(context).secondaryHeaderColor),
            //           child: Icon(Icons.add,
            //               color: Theme.of(context).primaryColor),
            //         ),
            //         title: const Text(
            //           'اضافة متجر',
            //           textAlign: TextAlign.right,
            //         )),
            //   ),
            // ),
            TextButton(
              onPressed: () {
                Get.to(const proficy(),
                    duration: const Duration(milliseconds: 500),
                    transition: Transition.fade);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).secondaryHeaderColor),
                child: ListTile(
                    trailing: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context).secondaryHeaderColor),
                      child: Icon(Icons.security,
                          color: Theme.of(context).primaryColor),
                    ),
                    title: const Text(
                      'سياسة الخصوصية',
                      textAlign: TextAlign.right,
                    )),
              ),
            ),
           TextButton(
              onPressed: () { 
                 final urltele = Uri.parse(
                    "https://t.me/rummana_app",
                  );
                   launchUrl(urltele); 
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).secondaryHeaderColor),
                child: ListTile(
                    trailing: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          color: Theme.of(context).secondaryHeaderColor),
                      child: Icon(Icons.help,
                          color: Theme.of(context).primaryColor),
                    ),
                    subtitle:const Text('يمكنك الاطلاع على تعليمات استخدام التطبيق عبر الضغط على الزر ',textAlign: TextAlign.right,) ,
                    title: const Text(
                      'تعليمات التطبيق',
                      textAlign: TextAlign.right,
                    )),
              ),
            ),
         
          ],
        ),
      ),
    );
  }
}
