import 'package:flutter/material.dart';
import 'package:flutter_firebase/views/login_screen.dart';
import 'package:flutter_firebase/views/signup_screen.dart';

import 'package:get/get.dart';

class MyHomePage extends StatefulWidget {
MyHomePage({Key ?key, required this.title}) : super(key: key);


final String title;

@override
_MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('HomePage'),
      ),
      body:Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: (){
                  Get.to(()=>SignUp());
                },
                child:Text('Signup Page',
                   style :TextStyle(color: Colors.brown)
                )

            ),
            ElevatedButton(
                onPressed: (){
                  Get.to(()=>LogIn());
                },
                child: Text('Login Page',

                style :TextStyle(color: Colors.brown)

              )
            ),

          ],
        ),
      )
      ,
    );
  }

}
