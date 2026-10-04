import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/RegisteruserController.dart';
import 'package:romanaappflutter/main.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.nameController.clear(); 
    _controller.addressController.clear();
    _controller.phoneController.clear(); 
    _controller.functionPointController.clear(); 
    _controller.passController.clear();
     }

  final RegisteruserController _controller = Get.put(RegisteruserController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(),
        body: Obx(
          ()=>_controller.islodedbtn.value?
          const Center(
                child: CircularProgressIndicator(),
              ): SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .secondaryHeaderColor, // Set your desired background color here
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Add rounded corners
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    child: TextFormField(
                        controller: _controller.nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'اكتب اسمك الكامل';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintTextDirection: TextDirection.rtl,
                          hintText: 'اسمك الكامل',
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .secondaryHeaderColor, // Set your desired background color here
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Add rounded corners
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    child: TextFormField(
                        controller: _controller.addressController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'اكتب العنوان';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintTextDirection: TextDirection.rtl,
                          hintText: 'العنوان ',
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .secondaryHeaderColor, // Set your desired background color here
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Add rounded corners
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    child: TextFormField(
                        controller: _controller.phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'اكتب  رقم الهاتف';
                          }
                           if (value.length !=11  ) {
                            return 'اكتب  رقم الهاتف 11 رقما';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintTextDirection: TextDirection.rtl,
                          hintText: 'رقم الهاتف',
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        )),
                  ),
                   Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .secondaryHeaderColor, // Set your desired background color here
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Add rounded corners
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    child: TextFormField(
                        controller: _controller.functionPointController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'اكتب اقرب نقطة دالة';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintTextDirection: TextDirection.rtl,
                          hintText: 'اقرب نقطة دالة ',
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        )),
                  ),
                 
                   Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .secondaryHeaderColor, // Set your desired background color here
                      borderRadius: BorderRadius.circular(
                          8.0), // Optional: Add rounded corners
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    width: double.infinity,
                    child: TextFormField(
                        controller: _controller.passController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'اكتب  كلمة المرور';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintTextDirection: TextDirection.rtl,
                          hintText: 'كلمة المرور ',
                          contentPadding: EdgeInsets.all(15),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        )),
                  ),
                
                  
                    Obx(
                          () => ElevatedButton.icon(
                              onPressed: () => {
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate())
                                      {_controller.saveuser()}
                                  },
                              icon: const Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myTheme.primaryColor),
                              label: _controller.islodedbtn.value
                                    ? const Center(child: CircularProgressIndicator())
                                    : const Text(
                                        'تسجيل حساب جديد',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      )),
                        ),
                        const SizedBox(
                          height: 50,
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
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        "تسجيل حساب جديد",
        style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: myTheme.secondaryHeaderColor),
          child: IconButton(
              onPressed: () {
                  Navigator.pop(context); 
              },
              icon: Icon(Icons.login, color: myTheme.primaryColor)),
        ),
      ],
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context); 
          },
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor)),
    );
  }
}
