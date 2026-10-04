import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/forgatepassController.dart';
import 'package:romanaappflutter/main.dart';
import 'package:romanaappflutter/views/login.dart';

class forgatepass extends StatefulWidget {
  const forgatepass({Key? key}) : super(key: key);

  @override
  _forgatepassState createState() => _forgatepassState();
}

class _forgatepassState extends State<forgatepass> {
  final _formKey = GlobalKey<FormState>();
  final forgatepassController _controller = Get.put(forgatepassController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          Obx(
                          () => ElevatedButton.icon(
                              onPressed: () => {
                                    // Validate returns true if the form is valid, or false otherwise.
                                    if (_formKey.currentState!.validate())
                                      {_controller.forgatepassbtn()}
                                  },
                              icon: const Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: myTheme.primaryColor),
                              label: _controller.islodedbtn.value
                                    ? const Center(child: CircularProgressIndicator())
                                    : const Text(
                                        'ارسال كود التحقق',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      )),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                        ,ElevatedButton.icon(
                              onPressed: () => {
                                     Get.to(
                                        () => const Login(),
                                        arguments: [0],
                                        duration: const Duration(milliseconds: 500),
                                        transition: Transition.fade,
                                      )
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
                                        'تسجيل  دخول',
                                        style: TextStyle(fontSize: 18, color: Colors.white),
                                      )),
                      
                         
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
      );
  }

  AppBar MyAppBar() {
    return AppBar(
        elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
        "نسيان كلمة المرور",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        )
         , actions: [
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
