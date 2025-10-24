import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/LoginController.dart';
import 'package:romanaappflutter/Controller/confirmaccountwithchangpassController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/RegisterUser.dart';

class confirmaccountwithchangpass extends StatefulWidget {
  const confirmaccountwithchangpass({Key? key}) : super(key: key);

  @override
  _confirmaccountwithchangpassState createState() =>
      _confirmaccountwithchangpassState();
}

class _confirmaccountwithchangpassState
    extends State<confirmaccountwithchangpass> {
      bool _onEditing=true;
  final _formKey = GlobalKey<FormState>();
  final confirmaccountwithchangpassController _controller = Get.put(confirmaccountwithchangpassController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: MyAppBar(),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 130,
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      child: Image.asset('assets/images/icon.png')),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  child: Center(
                    child: Container(
                      width: 350,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .secondaryHeaderColor, // Set your desired background color here
                        borderRadius: BorderRadius.circular(
                            15.0), // Optional: Add rounded corners
                      ),
                      child: Obx(
                        ()=> Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                                child: Text(
                                  'اهلا وسهلا بك رجاءا ادخال رمز التفعيل الذي سيصلك في رسالة نصية على رقمك مع ادخال كلمة المرور الجديدة',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                               SizedBox(
                                    child: VerificationCode(
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                            color: Theme.of(context).primaryColor),
                                    keyboardType: TextInputType.number,
                                    underlineColor: Colors
                                        .amber, // If this is null it will use primaryColor: Colors.red from Theme
                                    length: 4,
                                    cursorColor: Colors
                                        .blue, // If this is null it will default to the ambient
                                    // clearAll is NOT required, you can delete it
                                    // takes any widget, so you can implement your design
                                    clearAll: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'حذف الكود',
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            decoration: TextDecoration.underline,
                                            color: Colors.blue[700]),
                                      ),
                                    ),
                                    margin: const EdgeInsets.all(12),
                                    onCompleted: (String value) {
                                      _controller.numb1Controller.text=value;
                                    },
                                    onEditing: (bool value) {
                                     _controller.onEditing.value=value;
                                      if (!_controller.onEditing.value)
                                        FocusScope.of(context).unfocus();
                                    },
                                                      
                                                                ),
                                  ), 
                              
                             
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .secondaryHeaderColor, // Set your desired background color here
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Optional: Add rounded corners
                                ),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                width: double.infinity,
                                child: TextFormField(
                                    controller: _controller.passController,
                                    decoration: const InputDecoration(
                                      hintTextDirection: TextDirection.rtl,
                                      hintText: 'كلمة المرور الجديدة',
                                      contentPadding: EdgeInsets.all(15),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton.icon(
                                    onPressed: () => {
                                          // Validate returns true if the form is valid, or false otherwise.
                                          if (_formKey.currentState!.validate())
                                            {_controller.confirmaccount()}
                                        },
                                    icon: const Icon(
                                      Icons.send,
                                      color: Colors.white,
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: myTheme.primaryColor),
                                    label: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                      child: _controller.islodedbtn.value
                                          ? const Center(
                                              child: CircularProgressIndicator())
                                          : const Text(
                                              'ارسال',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                    )),
                              const SizedBox(
                                height: 10,
                              ),
                             Obx(()=>
                              _controller.isTimerRunning.value?
                              Text(
                                      'يمكنك اعادة ارسال الرمز بعد ${_controller.Counter.value}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    )
              :
                                 TextButton(
                                  onPressed: () => {
                                    _controller.restartTimer()
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'اعادة ارسال الرمز',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              )
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar MyAppBar() {
    return AppBar(
       leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios,
                color: Theme.of(context).primaryColor)),
       
        elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "تغيير كلمة المرور",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
