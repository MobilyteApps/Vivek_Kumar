


import 'dart:io';
import 'package:flutter/cupertino.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';



class Chat extends StatefulWidget{
  Chat({Key ?key, required this.title,required this.userid,required this.roomId}) : super(key: key);
  final String title;
  final String userid;
  final String roomId;
  @override
  _ChatState createState(){
    return _ChatState();
  }
}
class _ChatState extends State<Chat> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String ?chat;
  TextEditingController msg= TextEditingController();
  //VideoPlayerController? _videoPlayerController;
  ScrollController scrollController = ScrollController();

  final firestoreInstance = FirebaseFirestore.instance;
  var chatId;
  var listMessage;
  var size, height, width;
  /*final ImagePicker _picker = ImagePicker();*/
   File? _imageFile;

  var imagePicker;
  var type;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = File(pickedFile!.path);
      print(_imageFile!.path);
      type=_imageFile!.path;
      print(type);

    });
  }





    @override
    void initState() {
      super.initState();
      var firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser!.uid.hashCode <= widget.userid.hashCode) {
        chatId = firebaseUser.uid + widget.userid;
      }
      else {
        chatId = widget.userid + firebaseUser.uid;
      }
    }


  @override
  Widget build(BuildContext context) {
    size = MediaQuery
        .of(context)
        .size;
    height = size.height;
    width = size.width;

    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(

            children: [


              Padding(
                  

                  padding: EdgeInsets.only(bottom: 45),
                  child: StreamBuilder(
                          stream: firestoreInstance.collection('chat').doc(chatId)
                              .collection('msg')
                              .orderBy('time', descending: true)

                              .snapshots(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListView.builder(
                                shrinkWrap: true,

                                physics: AlwaysScrollableScrollPhysics(),

                                itemCount: snapshot.data!.docs.length,



                                itemBuilder: (BuildContext context, int index) {


                                  Map<int, dynamic> data = snapshot.data!.docs.asMap();
                                  Map getDocs = data[index].data();

                                  var firebaseUser = FirebaseAuth.instance.currentUser;

                                  return Container(
                                    padding: EdgeInsets.only(left: 14,right:14,top: 7,bottom: 7),
                                    child: Align(

                                        alignment: (firebaseUser!.uid ==
                                            getDocs['sender']
                                            ? Alignment.topRight
                                            : Alignment.topLeft),
                                        child: Container(
                                          height: height/20,
                                          decoration:BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: (firebaseUser.uid ==
                                                getDocs['sender']?Colors.purpleAccent:Colors.lightGreen),

                                          ) ,
                                          padding: EdgeInsets.all(10),
                                              child: Text(
                                                  '${getDocs['msgText']} ',
                                                style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w900),
                                                  ),

                                        ),
                                    ),

                                    // ,

                                  );
                                },
                                controller: scrollController,
                                reverse: true,
                              );

                            }
                          }
                      ),
                ),



             /*Container(
                child: type!=null?Image.file(_imageFile!):Text('')

              ),*/




              Align(
                    alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Spacer(flex: 2,),
                    Container(
                      height: height/16,
                      width: width,

                      decoration: BoxDecoration(
                          color: Colors.white,
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: TextField(
                        controller: msg,
                        cursorColor: Colors.lightGreen,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'type message',

                            border: InputBorder.none,
                             prefixIcon: InkWell(
                               onTap: (){
                                 getImage();
                               },
                               child: Icon(
                                 Icons.add_photo_alternate_rounded
                               ),
                             ),

                          suffixIcon: InkWell(
                            onTap: (){
                              var firebaseUser = FirebaseAuth.instance
                                .currentUser;
                                    if (firebaseUser!.uid.hashCode <=
                                        widget.userid.hashCode) {
                                        chatId = firebaseUser.uid + widget.userid;
                                                 }
                                    else {
                                              chatId = widget.userid + firebaseUser.uid;
                                          }
                                        print(chatId);
                                        firestoreInstance
                                            .collection("chat")
                                            .doc(chatId)

                                            .set({
                                            //"autoid":firebaseUser.uid,
                                            "created": DateTime.now(),
                                              "title": widget.title,
                                              "member": [firebaseUser.uid, widget.userid]
                                             }).then((value) {
                                              print(firebaseUser.uid);

                                            firestoreInstance
                                              .collection('chat')
                                               .doc(chatId)
                                                .collection("msg")
                                                .add({
                                                "msgText": msg.text,
                                                //"receiver":widget.userid,
                                                "sender": firebaseUser.uid,
                                                "time": DateTime.now()
                                                      });
                                                //Get.toNamed("/LogIn");

                                                  });

                                               },

                              child: Icon(Icons.send,color: Colors.black26,size: 16,),
                          )


                        ),
                      ),
                    ),


                  ],
                ),
              )

            ],
          ),




      );




  }

}



