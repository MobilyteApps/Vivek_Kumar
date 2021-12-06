

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoPreview extends StatefulWidget{
  VideoPreview({Key ?key, }) : super(key: key);
  @override
  _VideoPreview createState(){
    return _VideoPreview();
  }
}
class _VideoPreview extends State<VideoPreview>{
  final firestoreInstance = FirebaseFirestore.instance;
  var size, height, width;
  String video='';
  List<String> video_view= [];



  void initState(){

    super.initState();

    getFirebaseVideoFolder();
  }

  void getFirebaseVideoFolder() {
    // image_view.clear();
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('video');
    firebaseStorageRef.listAll().then((result) {
      result.items.forEach(( ref) async {
        await firebaseStorageRef.child('${ref.fullPath.split('/')[1]}').getDownloadURL().then((value) {
          print('url>>>> $value');
          video_view.add(value);
          setState(() {

          });
         // print(image_view.first);
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
          title: Text("Video Gallery"),
        ),
        body:
       video_view.isBlank==''?  Center(child: CircularProgressIndicator()):
        GridView.builder(

            gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: video_view.length,
            itemBuilder: (BuildContext context, int index) {
              return  Stack(

              children: [

                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: InkWell(onTap: (){
                    Get.to(()=>Video(url:video_view[index]));
                    },
                    child: Container(
                      height: height,
                       width: width,
                    color: Colors.black,
                      child: Container(height: 10,width: 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow),),),
                  ),
                ),

              ],
            );
        }
        )







    );
  }

}
class Video extends StatefulWidget{


  Video({Key ?key,this.url }) : super(key: key);
  final url;
  @override
  _Video createState(){
    return _Video();
  }
}
  class _Video extends State<Video>{
    var size, height, width;

   VideoPlayerController? _controller;
       @override
        void initState() {
                super.initState();

                   _controller = VideoPlayerController.network(
                       '${widget.url}',

                     videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
                    );

                 _controller!.addListener(() {
                   CircularProgressIndicator();
                   });
    //_controller!.setLooping(true);

               _controller!.initialize();
                  }
  // _controller=widget.url;
            @override
            Widget build(BuildContext context) {
              size = MediaQuery
                  .of(context)
                  .size;
              height = size.height;
              width = size.width;

           return Scaffold(

                 body: SafeArea(


                     child: SingleChildScrollView(
                       child: Column(
                            children: [
                               Center(
                                 child: Container(height:height/2,
                                   width:width ,

                                   child:VideoPlayer(
                                       _controller!
                                   ),

                                      ),
                               ),
                                 InkWell(
                                    onTap: () {

                                            setState(() {

                                      if (_controller!.value.isPlaying) {
                                                 _controller!.pause();
                                            } else {

                                       _controller!.play();
                                         }
                                       });
                                     },

                                   child: Icon(
                                   _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                           ),
            )
          ],
        ),
                     ),
      ),
    );
  }
}