import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';
import 'package:url_launcher/url_launcher.dart';

class Accounts extends StatefulWidget {
  const Accounts({ Key? key }) : super(key: key);

  @override
  _AccountsState createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  @override
  Widget build(BuildContext context) {
     return MaterialApp( 
      theme: myTheme,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
       appBar: MyAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: SingleChildScrollView(
            child: Expanded(child:  Column(
              children: [
                 TextButton(
                   onPressed: () async { 
                     await OpenUrl('https://flutter.dev');
                    },
                   child: Container( 
                    margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                              decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).secondaryHeaderColor)
                             ,child: ListTile( 
                             trailing: Container(
                    padding: const EdgeInsets.all(10),
                             decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(35)
                             ,color:Theme.of(context).secondaryHeaderColor),
                           child: Icon(Icons.public,color: Theme.of(context).primaryColor
                           ),
                         ),
                             title: const Text('الانستغرام',textAlign: TextAlign.right,)
                         )
                             ,),
                 ),
                  TextButton(
                   onPressed: () async { 
                     await OpenUrl('https://flutter.dev');
                    },
                   child: Container( 
                    margin: const EdgeInsets.symmetric(horizontal: 0,vertical: 0), 
                              decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Theme.of(context).secondaryHeaderColor)
                             ,child: ListTile( 
                             trailing: Container(
                    padding: const EdgeInsets.all(10),
                             decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(35)
                             ,color:Theme.of(context).secondaryHeaderColor),
                           child: Icon(Icons.facebook,color: Theme.of(context).primaryColor
                           ),
                         ),
                             title: const Text('فيسبوك',textAlign: TextAlign.right,)
                         )
                             ,),
                 )
              ],
            )
            ),
          ),
        ),
      ),
    );
  }

  Future<void> OpenUrl(String UrlS) async {
    final Uri url = Uri.parse(UrlS);
     if (!await launchUrl(url)) {
           throw Exception('Could not launch $url');
       }
  }
   AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(  
      leading: IconButton(onPressed: (){
           Get.back();
      },
      icon:  Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColor)),
          elevation: 2, 
        backgroundColor:Theme.of(context).backgroundColor,
        centerTitle: true, 
        title:  Text("حساباتنا",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
            )
          );
  } 
}