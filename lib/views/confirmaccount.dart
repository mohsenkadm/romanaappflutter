import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/Controller/confirmaccountController.dart';
import 'package:romanaappflutter/Constant/otp_policy.dart';
import 'package:romanaappflutter/main.dart';

class confirmaccount extends StatefulWidget {
  const confirmaccount({Key? key}) : super(key: key);

  @override
  _confirmaccountState createState() => _confirmaccountState();
}

class _confirmaccountState extends State<confirmaccount> {
  final _formKey = GlobalKey<FormState>();
  final confirmaccountController _controller =
      Get.put(confirmaccountController());
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
                        ()=>Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                                child: Text(
                                  'أدخل كود التحقق المكون من ${OtpPolicy.codeLength} أرقام المرسل إلى رقمك',
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
                                          .bodySmall!
                                          .copyWith(
                                              color: Theme.of(context).primaryColor),
                                      keyboardType: TextInputType.number,
                                      underlineColor: Colors
                                          .amber, // If this is null it will use primaryColor: Colors.red from Theme
                                      length: OtpPolicy.codeLength,
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
                                    label: _controller.islodedbtn.value
                                          ? const Center(
                                              child: CircularProgressIndicator())
                                          : const Text(
                                              'ارسال',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white),
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
      );
  }

  AppBar MyAppBar() {
    return AppBar(
        elevation: 2,
        // ignore: deprecated_member_use
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "تاكيد الحساب",
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
        ));
  }
}
