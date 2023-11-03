 
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';  
  
class AboutApp extends StatefulWidget {
  const AboutApp({ Key? key }) : super(key: key);

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
         body: Column(
           children:[
             Container( 
            margin: EdgeInsets.symmetric(vertical: 20,horizontal: 25),
            width: double.infinity,
            padding:  const EdgeInsets.all(15),
                decoration: BoxDecoration( 
                   borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).secondaryHeaderColor),
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(' عن رمانـــــة -',textAlign: TextAlign.right,style:  TextStyle(fontSize: 20,
                 color: Theme.of(context).primaryColor))
               ,const SizedBox(height: 10,),
               const Divider(
              color: Colors.black
            ) ,const SizedBox(height: 10,)
                ,const Text('تطبيق "رمانـــــة" هو حلاً مثاليًا لتجربة التسوق الإلكتروني واختيار أشهى المأكولات من أفضل المطاعم والاسواق . تميز بمزايا فريدة تشمل ',textAlign: TextAlign.right,style: TextStyle(fontSize: 16),)
              ,const SizedBox(height: 15,)
               ,const Text('تسوق إلكتروني متميز : اكتشف مجموعة متنوعة من الأطعمة والمأكولات من مطاعم واســواق مميزة بسهولة عبر التطبيق.',textAlign: TextAlign.right,style: TextStyle(fontSize: 16),)
              ,const SizedBox(height: 10,) 
               ,const Text('توصيل مجاني وسريع : تمتع بخدمة توصيل سريعة ومجانية للطلبات مباشرة إلى باب منزلك.',textAlign: TextAlign.right,style: TextStyle(fontSize: 16),)
              ,const SizedBox(height: 10,) 
               ,const Text(' اختيار دقيق : قم باختيار طلباتك بدقة واستمتع بتجربة تسوق سلسة وسهلة.',textAlign: TextAlign.right,style: TextStyle(fontSize: 16),)
              ,const SizedBox(height: 10,) 
               ,const Text(' رمانـــــة : هو التطبيق الذي يجمع بين التنوع والسهولة والراحة لتجربة تسوق مأكولات فريدة. احصل على أشهى الأطعمة مع تطبيق "رمــــانة" اليوم ',textAlign: TextAlign.right,style: TextStyle(fontSize: 16),)
              ,const SizedBox(height: 10,) 
              
              ],
           ),
           )],
         )
      ),
    );
  }

  // ignore: non_constant_identifier_names
  AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(  
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon:  Icon(Icons.arrow_back_ios,color:Theme.of(context).primaryColor)),
          elevation: 2, 
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title:  Text("عن تطبيق رمانة",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),
            )
          );
  } 
} 