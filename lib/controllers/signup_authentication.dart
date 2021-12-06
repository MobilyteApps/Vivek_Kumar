

import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  //final GoogleSignIn googleSignIn = GoogleSignIn();


  get user => _auth.currentUser;

//SIGN UP
  Future<dynamic> signup(String email, String password,String name,BuildContext context, ) async {

    try {

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,

      ).whenComplete(()  {

        print("result");
      });

      return null;
    } on FirebaseAuthException catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'UnScuccesful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return e.message;
    }
  }

  //SIGN IN
  Future<User?> signIn(String email, String password, BuildContext context) async {
    try {
     // AuthCredential credential=EmailAuthProvider.credential(email: email, password: password);

      UserCredential result =
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      storeTokenAndData(result.user!.uid);
      //print('Result=================$result');
      print("Credential========$result");
      final User user = result.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(

        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM, msg: '${e.message}',
      );
    }

  }
  //SIGN OUT METHOD
  Future<void> signOut( ) async {
   //clearTokenAndData();
    clearTokenAndData();
   await _auth.signOut();


    print('signout');
  }

  Future<void> storeTokenAndData(result) async{
   // print("Credential========$credential");
    print("++++++++++++++++++++++++++++++++++++++++++++"+result);
    await storage.write(key:'token', value: result.toString());
    print("Resulttt======================");
    //await storage.write(key:'result', value: result.toString());
  }
  Future <String?> getToken() async{

    return await storage.read(key: 'token');
  }
Future<String?> clearTokenAndData() async{
   // print('result====================${result}');
    await storage.delete(key: 'token');
}

}