import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/controllers/signup_authentication.dart';

import 'package:flutter_firebase/views/view_path_screen.dart';

import 'package:get/get.dart';

class LogIn extends StatefulWidget{
  LogIn({Key ?key, }) : super(key: key);
  @override
  _LogInState createState(){
    return _LogInState();
  }
}
class _LogInState extends State<LogIn>{
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  AuthenticationHelper _authenticationHelper=AuthenticationHelper();
  @override
void initState(){
    super.initState();
    //onRefresh(FirebaseAuth.instance.currentUser);
    chekLogin();
  }
void chekLogin() async{
    String token= (await _authenticationHelper.getToken())!;
    print('Token====${token}');
    if(token!=null){

      setState(() {
        //print('email====================================='+email);
        //Get.to(()=>UserInf(uid: token,));
        Get.to(()=>ViewScreen(uid: token,));
      });
    }
}
  String  ?email;

  String ?password;

  bool agree = false;
  bool isObscure = true;

  TextEditingController pass = TextEditingController();
  TextEditingController emaill = TextEditingController();


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Login_Page'),
      ),
      body:SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Column(
            children: [

              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 31, right: 30),
                child: TextFormField(

                  keyboardType: TextInputType.text,
                  decoration: buildInputDecoration(Icons.email, "Email"),
                  validator: (String ?value) {
                    if (value!.isEmpty) {
                      return 'Please a Enter';
                    }
                    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                        .hasMatch(value)) {
                      return 'Please a valid Email';
                    }
                    return null;
                  },
                  onSaved: (String ?value) {
                    email = value!;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 31, right: 30),
                child: TextFormField(
                  controller: pass,
                  keyboardType: TextInputType.text,
                  obscureText: isObscure,
                  decoration: buildInputDecoration(
                    Icons.lock,
                    "Password",
                  ),
                  validator: (String ?value) {
                    if (value!.isEmpty) {
                      return 'Please a Enter Password';
                    }
                    return null;
                  },
                  onSaved: (String ?value) {
                    password = value!;
                  },

                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.only(left: 31, right: 30),
                child: ElevatedButton(
                    onPressed: () async {

                      if (_formkey.currentState!.validate()) {

                        _formkey.currentState!.save();
                        //Get.toNamed("/LogIn");
                        await AuthenticationHelper()
                            .signIn(email!, password!, context).then((user) {
                                                FirebaseAuth.instance
                                                  .authStateChanges()
                                                     .listen((User ?user) {
                                                        if (user == null) {
                                               print('User is currently signed out!');
                                               Get.to(()=>LogIn());
                                                         } else {
                                                print('User is signed in!');
                                                //print(user.email);
                                               //Get.to(()=>UserInf(uid:user.uid ,));
                                                Get.to(()=>ViewScreen(uid:user.uid ,));
                                                             }
                                                         });

                            // Get.toNamed("/LoginSignUp");
                          }
                        );





                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              Container(

              ),

            ],
          ),
        ),
      ),
    );
  }
}
InputDecoration buildInputDecoration(IconData icons, String hinttext) {
  return InputDecoration(
    hintText: hinttext,
    prefixIcon: Icon(icons),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(width: 1.5),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        width: 1.5,
      ),
    ),
  );
}