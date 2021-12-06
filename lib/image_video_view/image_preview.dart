import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget{
  ImagePreview({Key ?key, }) : super(key: key);
  @override
  _ImagePreview createState(){
    return _ImagePreview();
}
}
class _ImagePreview extends State<ImagePreview>{
  final firestoreInstance = FirebaseFirestore.instance;
  var size, height, width;
  String image='';
  List<String> image_view= [];
  var i=0;



void initState(){
  super.initState();
  getFirebaseImageFolder();
}

  void getFirebaseImageFolder() {
    image_view.clear();
     Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('uploads');
    firebaseStorageRef.listAll().then((result) {
      result.items.forEach(( ref) async {
        await firebaseStorageRef.child('${ref.fullPath.split('/')[1]}').getDownloadURL().then((value) {
        print('url>>>> $value');
        i++;
        image_view.add(value);
        setState(() {
          i;
        });


        });


      });


        print('Found file: ${result.items[0].fullPath.split('/')[1]}');
      print("result is $result");
    });
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
        title: Text("Image Gallery"),
      ),
      body:
      GridView.builder(
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: image_view.length,
          itemBuilder: (BuildContext context, int index) {
            if(i!=image_view.length){
            return Text('$i');
          }
            else return Container(
              height: height/4,
              width:width /4,

              margin: EdgeInsets.all(10),

              decoration: BoxDecoration(
                color: Colors.purpleAccent,

              ),
              child: Image.network(

                image_view[index],
                fit: BoxFit.cover ),
            );}
      )







    );
  }

  }