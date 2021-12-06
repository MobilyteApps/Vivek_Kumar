
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/image_video_view/file_pick.dart';
import 'package:flutter_firebase/views/user_information.dart';
import 'package:flutter_firebase/image_video_view/video_view_grid.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart';

import '../image_video_view/image_preview.dart';

class ViewScreen extends StatefulWidget{
  ViewScreen({Key ?key,required this.uid }) : super(key: key);
  final String uid;
  @override
  _ViewScreen createState(){
    return _ViewScreen();
  }
}
class _ViewScreen extends State<ViewScreen>{
  File? _imageFile,_videoFile;
  VideoPlayerController? _videoPlayerController;
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
  Future getVideo() async {
    final videoFile = await picker.pickVideo(source: ImageSource.gallery);

    _videoFile = File(videoFile!.path);
    _videoPlayerController = VideoPlayerController.file(_videoFile!)..initialize().then((_) {
      setState(() { });
      _videoPlayerController!.play();
    });
  }
  Future uploadImageToFirebase(BuildContext context) async {

    String fileName = basename(_imageFile!.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('uploads/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile!);
    uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
  }
  Future uploadVideoToFirebase(BuildContext context) async {

    String fileName = basename(_videoFile!.path);
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('video/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(_videoFile!);
    uploadTask.then((res) {
      res.ref.getDownloadURL();
    });
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('List_Of_Screen'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Spacer(flex: 2,),
              InkWell(onTap: (){
                Get.to(()=>UserInf(uid:widget.uid ,));
              },
              child: Container(
                
                height: 50,
                width: 150,

                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Center(child: Text('UserImfoScreen',
                style: TextStyle(color: Colors.white,letterSpacing: 1,fontWeight: FontWeight.w900),
                )
                ),
              ),
              )
              ,
              Spacer(),
              InkWell(onTap: (){
                uploadImageToFirebase(context);

                },


              child: Column(
                children: [
                  Container(height: 50,
                    width: 150,

                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(10),


                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(Icons.upload_file,
                          color: Colors.white,
                        ),
                        Text('UploadImage',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,letterSpacing: 0.85),
                        )
                      ],
                    ),

                  ),


                ],
              ),
              ),
              Spacer(),
              InkWell(
                onTap: (){
                  getImage();
                },
                child:
                Column(
                  children: [
                    Container(height: 50,
                      width: 150,

                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(10),


                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Icon(Icons.add_photo_alternate_rounded,
                            color: Colors.white,
                          ),
                          Text('Pick_Image',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,letterSpacing: 0.85),
                          )
                        ],
                      ),

                    ),

                  ],
                ),

              ),
              Spacer(),
              InkWell(onTap: (){
                uploadVideoToFirebase(context);

              }

                ,child: Column(
                  children: [
                    Container(height: 50,
                      width: 150,

                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.circular(10),


                      ),
                      padding: EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Icon(Icons.upload_file,
                            color: Colors.white,
                          ),
                          Text('UploadVideo',
                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,letterSpacing: 0.85),
                          )
                        ],
                      ),

                    ),

                  ],
                ),

              ),
              Spacer(),
                 Container(
                          child: Column(
                               children: <Widget>[
                                       if(_videoFile != null)
                                        _videoPlayerController!.value.isInitialized
                                                ? AspectRatio(
                                                aspectRatio: _videoPlayerController!.value.aspectRatio,
                                                 child: VideoPlayer(_videoPlayerController!),
                                                     )
                                                 : Container()
                                               else
                                       Text("", style: TextStyle(fontSize: 18.0),),

                           InkWell(
                               onTap: () {
                                     getVideo();
                                        },
                                 child:
                                 Column(
                                   children: [
                                     Container(height: 50,
                                     width: 150,
                                       padding: EdgeInsets.all(10),

                                     decoration: BoxDecoration(
                                       color: Colors.deepPurpleAccent,
                                       borderRadius: BorderRadius.circular(10),


                                     ),

                                     child: Row(
                                       children: [
                                         Icon(Icons.video_library_outlined,
                                           color: Colors.white,
                                         ),
                                         Text('Pick Video ',
                                           style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,letterSpacing: 0.85),
                                         )
                                       ],
                                     ),

                                   ),

                                   ],
                                 ),

                                       ),
                                    ],
                                   ),
                                 ),
                   Spacer(),
                           InkWell(onTap: (){

                           Get.to(()=>ImagePreview());
                             },child: Column(
                                    children: [
                                      Container(height: 50,
                                        width: 150,

                                        decoration: BoxDecoration(
                                          color: Colors.deepPurpleAccent,
                                          borderRadius: BorderRadius.circular(10),


                                        ),
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.grid_view,
                                              color: Colors.white,
                                            ),
                                            Text('View_Image',
                                              style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,letterSpacing: 0.85),
                                            )
                                          ],
                                        ),

                                      ),

                                              ],
                                   ),

                               ),
                         Spacer(),
                              InkWell(onTap: (){


                                         Get.to(()=>VideoPreview());
                                          },child: Column(
                                               children: [
                                                 Container(height: 50,
                                                   width: 150,

                                                   decoration: BoxDecoration(
                                                     color: Colors.deepPurpleAccent,
                                                     borderRadius: BorderRadius.circular(10),


                                                   ),
                                                   padding: EdgeInsets.only(left: 10),
                                                   child: Row(
                                                     children: [
                                                       Icon(Icons.video_library,
                                                         color: Colors.white,
                                                       ),
                                                       Text('View_Video',
                                                         style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,letterSpacing: 0.85),
                                                       )
                                                     ],
                                                   ),

                                                 ),
                                                         
                                                         ],
                                                        ),

                                     ),
              Spacer(),
              InkWell(onTap: (){


                Get.to(()=>FilePickk());
              },child: Column(
                children: [
                  Container(height: 50,
                    width: 150,

                    decoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      borderRadius: BorderRadius.circular(10),


                    ),
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Icon(Icons.file_copy_rounded,
                          color: Colors.white,
                        ),
                        Text('Pick_File',
                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.w900,letterSpacing: 0.85),
                        )
                      ],
                    ),

                  ),

                ],
              ),

              ),
              Spacer(flex: 12,)

            ],
          ),
        ),
      ),
    );
  }
}