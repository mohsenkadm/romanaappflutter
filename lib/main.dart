import 'package:flutter/material.dart'; 
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_time_ago/get_time_ago.dart'; 
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:romanaappflutter/Constant/dependencyinjection.dart';
import 'package:romanaappflutter/Constant/determine_position_location.dart';
import 'package:romanaappflutter/views/MainApp.dart';
import 'package:romanaappflutter/views/OnBourding.dart'; 
int? initScreen;
void main() async { 
  GetTimeAgo.setDefaultLocale('ar'); 
  await GetStorage.init();    
  
  //Remove this method to stop OneSignal Debugging 
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("c8dfb903-9803-44d7-b6d5-b7660fa2e527");

  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  // get iit screen
  final box= GetStorage(); 
   initScreen =  box.read("initScreen");
   await box.write("initScreen", 1);
   await OneSignal.login(box.read("userId").toString()); 
  runApp(_MyApp());
  
  dependencyinjection.onInit();
}

class _MyApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {

// Initialize the location service
     Get.put(determinePositionLocation(), permanent: true);
    return GetMaterialApp( 
        theme:myTheme,
      debugShowCheckedModeBanner: false,
      home:initScreen == 0|| initScreen==null ? const OnBoarding() : const MainApp()
    );
  } 
}

ThemeData myTheme = ThemeData(
  fontFamily: "Tajawal",
  primaryColor: const Color.fromARGB(255,219,40,31),          // Change this to your primary color
  secondaryHeaderColor: const Color.fromARGB(50, 219,40,31),// Change this to your accent color
  // Add more color properties as needed
);

 