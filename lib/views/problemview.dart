import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:romanaappflutter/main.dart';

class Problemview extends StatefulWidget {
  const Problemview({ Key? key }) : super(key: key);

  @override
  _ProblemviewState createState() => _ProblemviewState();
}

class _ProblemviewState extends State<Problemview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: MyAppBar(),
        body: const Text('data'),
      );
  }
   AppBar MyAppBar() {
    // ignore: duplicate_ignore
    return AppBar(  
      leading: IconButton(onPressed: (){
           navigator?.pop();
      },
      icon:  Icon(Icons.arrow_back,color:Theme.of(context).primaryColor)),
          elevation: 2, 
        backgroundColor:Colors.white,
        centerTitle: true, 
        title:  Text("",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Theme.of(context).primaryColor),
            )
          );
  } 
}
