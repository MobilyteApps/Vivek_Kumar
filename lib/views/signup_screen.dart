import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/controllers/signup_authentication.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget{
  SignUp({Key? key, }) : super(key: key);
  @override
  _SignUpState createState(){
    return _SignUpState();
  }
}
class _SignUpState extends State<SignUp>{
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final firestoreInstance = FirebaseFirestore.instance;
  String ?fstName,lstName, email, userid;


  String ?password;

  bool agree = false;

  TextEditingController pass = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();

  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('SignUp_Page'),
      ),
      body:SingleChildScrollView(
              child: Form(
                key: _formkey,
                       child: Column(
                             children: [
                                     Container(
                                       margin: EdgeInsets.only(top: 25),
                                       padding: EdgeInsets.only(
                                         left: 31,
                                         right: 30,
                                       ),
                                       child: TextFormField(
                                         keyboardType: TextInputType.text,
                                         decoration: buildInputDecoration(Icons.person, "First Name"),
                                         validator: (String ?value) {
                                           if (value!.isEmpty) {
                                             return 'Please first Enter Name';
                                           }
                                           return null;
                                         },
                                         onSaved: (String ?value) {
                                           fstName = value!;
                                         },
                                       ),
                                          ),
                               Container(
                                 margin: EdgeInsets.only(top: 20),
                                 padding: EdgeInsets.only(
                                   left: 31,
                                   right: 30,
                                 ),
                                 child: TextFormField(
                                   keyboardType: TextInputType.text,
                                   decoration: buildInputDecoration(Icons.person, "Last Name"),
                                   validator: (String ?value) {
                                     if (value!.isEmpty) {
                                       return 'Please first Enter Name';
                                     }
                                     return null;
                                   },
                                   onSaved: (String ?value) {
                                     lstName = value!;
                                   },
                                 ),
                               ),
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
                                     onPressed: () {

                                       if (_formkey.currentState!.validate()) {

                                         _formkey.currentState!.save();
                                         AuthenticationHelper()
                                             .signup(email!, password!, fstName!, context)
                                             .then((result) {
                                           if (result == null) {
                                             var firebaseUser =  FirebaseAuth.instance.currentUser;

                                             firestoreInstance.collection("users").doc(firebaseUser!.uid).set({
                                               "uid" :firebaseUser.uid,
                                               "fstName": fstName,
                                               "email": email,
                                               "lstName":lstName

                                             }).then((value) {
                                               print(firebaseUser.uid);
                                              /* firestoreInstance
                                                   .collection("users")
                                                   .doc(firebaseUser.uid)
                                                   .collection("chat")
                                                   .doc(firebaseUser.uid).set({
                                                 "autoid":firebaseUser.uid,
                                                 "created": DateTime.now(),
                                                 "title": "Hello",
                                                 "member": ['rahul','shyam','vijay']
                                                   }).then((value) {
                                                 print(firebaseUser.uid);
                                                 firestoreInstance
                                                     .collection("chat")
                                                     .doc(firebaseUser.uid)
                                                     .collection("auto")
                                                     .doc(firebaseUser.uid).set({
                                                   "msgText": "hii",
                                                   "sender": firebaseUser.uid,
                                                   "time": DateTime.now()
                                                 });
                                               });;*/
                                             });
                                             print('success');

                                           } else {

                                             Get.toNamed("/LogIn");
                                           }
                                         });
                                         //Get.toNamed("/LogIn");





                                       }

                                     },




                                     child: Text(
                                       'SignUp',
                                       style: TextStyle(color: Colors.white),
                                     )),
                               )
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