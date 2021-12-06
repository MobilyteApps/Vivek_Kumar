import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/controllers/signup_authentication.dart';

import 'package:flutter_firebase/views/chat_screen.dart';
import 'package:get/get.dart';

class UserInf extends StatefulWidget{
  UserInf({Key ?key, required this.uid }) : super(key: key);
  final String uid;
  @override
  _UserInfoState createState(){
    return _UserInfoState();
  }
}
class _UserInfoState extends State<UserInf> {
  final db = FirebaseFirestore.instance;
  AuthenticationHelper _authenticationHelper=AuthenticationHelper();
  var size,height,width;
  String? mystring;
  var roomId;

  void chekLogin() async{
    String token= (await _authenticationHelper.clearTokenAndData())!;
    print('Token====${token}');
    if(token==null){
      setState(() {
        Get.toNamed('/LogIn');
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;



    return Scaffold(
      backgroundColor:Colors.white,
      appBar: AppBar(
        title: ElevatedButton(onPressed: (){ AuthenticationHelper()
            .signOut()
        ;}, child: Text('LogOut',)) ,
        centerTitle: true,
      ),
      body:
         StreamBuilder<QuerySnapshot>(
          stream: db.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData ) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else
            return ListView(

                children: snapshot.data!.docs.map((doc) {
                  var count=snapshot.data!.docs.length;
             //    print('count================${count}');
                  if(doc.get('uid') != widget.uid )
                    return SingleChildScrollView(
                      child: Container(
                        height: height/10,
                           width: width/8,


                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(15),
                             boxShadow: [
                               BoxShadow(
                                 color: Colors.black12,
                                 offset: const Offset(
                                   2.0,
                                   2.0,
                                 ),
                                 blurRadius: 2.0,
                                 spreadRadius: 2.0,
                               ),

                             ],


                           ),

                           margin: EdgeInsets.all(8),
                      child:Padding(
                        padding: const EdgeInsets.all(0),
                        
                        child: Row(
                         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(

                              alignment: Alignment.center,
                               height: height/8,
                               width:width/8,
                           margin: EdgeInsets.only(left: 6),

                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.deepPurpleAccent,
                                ),
                                child:  Text('${doc.get('fstName')[0]}'.toUpperCase(),
                                style:TextStyle(fontWeight: FontWeight.bold ,color: Colors.white,fontSize: 25)
                                ),



                            ),


                            Container(

                              height: height/4,
                              width: width/1.5,
                              padding: EdgeInsets.only(
                                top: 19,
                                left: 16
                              ),

                              child: Column(


                               crossAxisAlignment: CrossAxisAlignment.start,


                                children:[

                                  Container(

                                    padding: EdgeInsets.only(left: 4),
                                  child:  Text('${doc.get('fstName')} ${doc.get('lstName')}'.capitalize!
                                      ,
                                      style:TextStyle(fontWeight: FontWeight.bold, color: Colors.black54, fontSize: 18))
                                  ),

                                  Container(

                                      child:  Text(' ${doc.get('email')} '.toLowerCase(),

                                          style:TextStyle( color: Colors.black45, fontSize: 18))
                                  ),
                                ],
                              ),
                            ),
                  Container(
                      height:height/10,
                      width: width/10,
                      alignment: Alignment.topRight,
                      margin: EdgeInsets.all(8),

                      child: IconButton(
                        icon: Icon(
                          Icons.message,
                          color: Colors.black38,
                          size: 24.0,
                        ),
                        onPressed:(){
                          if(widget.uid.hashCode<= doc.get('uid').hashCode)
                          {
                            roomId=widget.uid+doc.get('uid');
                          }
                          else{
                            roomId=doc.get('uid')+widget.uid;
                          }
                         Get.to(()=>Chat(title: '${doc.get('fstName')}',userid:'${doc.get('uid')}',roomId:roomId));
                        } ,
                      ),
                  ),

                              ],
                        ),
                      ),

                  ),
                    );
                  else{
                    return Container();
                  }
                }).toList(),
             );

          },
        ),






    );
  }
}




