import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/LoginController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/RegisterUser.dart';
import 'package:romanaappflutter/views/forgatepass.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final LoginController _controller = Get.put(LoginController());
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
                    borderRadius: const BorderRadius.all(Radius.circular(100)),
                    child:  Image.asset('assets/images/icon.png')
                  ),
                ),
                const SizedBox(height: 30,),
                SizedBox(
                  child: Center(
                    child: Container(
                       width: 350,
                      decoration: BoxDecoration(
                            color: Theme.of(context)
                                .secondaryHeaderColor, // Set your desired background color here
                            borderRadius:
                                BorderRadius.circular(15.0), // Optional: Add rounded corners
                          ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [ 
                           const SizedBox(
                          height: 30,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .secondaryHeaderColor, // Set your desired background color here
                            borderRadius:
                                BorderRadius.circular(8.0), // Optional: Add rounded corners
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          width: double.infinity,
                          child: TextFormField(  
                              controller: _controller.phoneController,
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
                            borderRadius:
                                BorderRadius.circular(8.0), // Optional: Add rounded corners
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          width: double.infinity,
                          child: TextFormField(  
                              controller: _controller.passController,
                              decoration: const InputDecoration(
                                hintTextDirection: TextDirection.rtl,
                                hintText: 'كلمة المرور',
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
                                      {_controller.loginbtn()}
                                  },
                              icon: const Icon(
                                Icons.login,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myTheme.primaryColor),
                              label: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: _controller.islodedbtn.value
                                    ? const Center(child: CircularProgressIndicator())
                                    : const Text(
                                        'تسجيل الدخول',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                              )),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                        ,ElevatedButton.icon(
                              onPressed: () => {
                                     Get.to(
                                        () => const RegisterUser(),
                                        arguments: [0],
                                        duration: const Duration(milliseconds: 500),
                                        transition: Transition.fade,
                                      )
                                  },
                              icon: const Icon(
                                Icons.restaurant,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myTheme.primaryColor),
                              label: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: _controller.islodedbtn.value
                                    ? const Center(child: CircularProgressIndicator())
                                    : const Text(
                                        'تسجيل حساب جديد',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      ),
                              )),
                      
                         TextButton(
                          onPressed: () => {
                             Get.to(
                                        () => const forgatepass(),
                                        arguments: [0],
                                        duration: const Duration(milliseconds: 500),
                                        transition: Transition.fade,
                                      )
                          },
                           child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('هل نسيت كلمة المرور؟'
                            ,textAlign: TextAlign.center,style: TextStyle(
                                               color: Theme.of(context).primaryColor,
                                               fontSize: 14,
                                               fontWeight: FontWeight.normal),),
                                                   ),
                         ),
                        const SizedBox(
                          height: 30,
                        )
                      ]),
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
        elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "تسجيل دخول لحسابك",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
