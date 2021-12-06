import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_firebase/views/chat_screen.dart';
import 'package:flutter_firebase/views/home_page_screen.dart';
import 'package:flutter_firebase/image_video_view/image_preview.dart';
import 'package:flutter_firebase/views/login_screen.dart';
import 'package:flutter_firebase/views/signup_screen.dart';
import 'package:flutter_firebase/views/user_information.dart';
import 'package:flutter_firebase/image_video_view/video_view_grid.dart';
import 'package:flutter_firebase/views/view_path_screen.dart';
import 'package:get/get.dart';

import 'image_video_view/file_pick.dart';

Future<void>  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());


}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      getPages: [

        GetPage(name: '/LogIn', page: () => LogIn()),
        GetPage(name: '/SignUp', page: () => SignUp()),
        GetPage(name:'/UserInf',page: ()=>UserInf(uid: '',)),
        GetPage(name:'/Chat',page: ()=>Chat(roomId: '', userid: '', title: '',)),
        GetPage(name: '/ImagePreview',page: ()=>ImagePreview()),
        GetPage(name: '/VideoPreview ', page:()=>VideoPreview ()),
        GetPage(name: '/Video', page:()=>Video()),
       GetPage(name: '/ViewScreen', page: ()=>ViewScreen(uid: '',)),
        GetPage(name: '/FilePickk', page: ()=>FilePickk())



      ],

    );
  }
}



